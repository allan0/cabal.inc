// lib/screens/token_analytics_screen.dart
import 'package:cabal/services/block_explorer_service.dart';
import 'package:cabal/services/web3_service.dart';
import 'package:cabal/widgets/diamond_mesh_background.dart';
import 'package:cabal/widgets/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kDebugMode; // <-- FIX: IMPORT ADDED
import 'package:cabal/config.dart';                      // <-- FIX: IMPORT ADDED

class TokenAnalyticsScreen extends StatefulWidget {
  const TokenAnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<TokenAnalyticsScreen> createState() => _TokenAnalyticsScreenState();
}

class _TokenAnalyticsScreenState extends State<TokenAnalyticsScreen> {
  Future<Map<String, dynamic>>? _analyticsDataFuture;
  late final String _tokenAddress;

  @override
  void initState() {
    super.initState();
    // FIX: Correctly access environment variables via AppConfig
    _tokenAddress = kDebugMode 
        ? AppConfig.sepoliaCabalTokenAddress 
        : AppConfig.mainnetCabalTokenAddress;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAnalyticsData();
    });
  }

  void _loadAnalyticsData() {
    setState(() {
      _analyticsDataFuture = _fetchAnalyticsData();
    });
  }

  Future<Map<String, dynamic>> _fetchAnalyticsData() async {
    if (_tokenAddress.isEmpty) {
      throw Exception("Token address not configured in environment.");
    }
    
    final web3Service = context.read<Web3Service>();
    final explorerService = BlockExplorerService();

    final results = await Future.wait([
      web3Service.getCirculatingSupply(),
      explorerService.getTokenHolderCount(_tokenAddress),
      explorerService.getTransactions24h(_tokenAddress),
      explorerService.getRecentTransfers(_tokenAddress, count: 5),
      explorerService.getTokenPrice(),
    ]);

    return {
      'circulatingSupply': results[0],
      'holders': results[1],
      'txs24h': results[2],
      'recentTxs': results[3],
      'price': results[4],
    };
  }

  Future<void> _launchExplorer() async {
    if (_tokenAddress.isEmpty) return;
    final url = Uri.parse(
      // FIX: Correctly access kDebugMode
      kDebugMode 
        ? 'https://sepolia.etherscan.io/token/$_tokenAddress'
        : 'https://etherscan.io/token/$_tokenAddress'
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("\$CBL Token Analytics"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: DiamondMeshBackground(
        child: RefreshIndicator(
          onRefresh: () async => _loadAnalyticsData(),
          child: FutureBuilder<Map<String, dynamic>>(
            future: _analyticsDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingState();
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error fetching analytics: ${snapshot.error}"));
              }
              if (!snapshot.hasData) {
                return const Center(child: Text("No analytics data available."));
              }
              
              final data = snapshot.data!;
              final numberFormat = NumberFormat.decimalPattern();
              final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 4);
              final circulatingSupply = (data['circulatingSupply'] as BigInt).toDouble() / 1e18;
              final marketCap = (data['price'] as double) * circulatingSupply;

              return ListView(
                padding: EdgeInsets.only(
                  top: kToolbarHeight + MediaQuery.of(context).padding.top + 20,
                  left: 16, right: 16, bottom: 40,
                ),
                children: [
                    _buildMetricCard(
                      theme: theme,
                      title: "Current Price",
                      value: currencyFormat.format(data['price']),
                      icon: FontAwesomeIcons.dollarSign,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.5,
                      children: [
                        _buildMetricCard(theme: theme, title: "Market Cap", value: "\$${NumberFormat.compact().format(marketCap)}", icon: FontAwesomeIcons.coins),
                        _buildMetricCard(theme: theme, title: "Circulating Supply", value: NumberFormat.compact().format(circulatingSupply), icon: FontAwesomeIcons.arrowsRotate),
                        _buildMetricCard(theme: theme, title: "Total Holders", value: numberFormat.format(data['holders']), icon: FontAwesomeIcons.users),
                        _buildMetricCard(theme: theme, title: "Transactions (24h)", value: numberFormat.format(data['txs24h']), icon: FontAwesomeIcons.rightLeft),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildRecentTransactions(theme, data['recentTxs']),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.open_in_new),
                      label: const Text("View on Etherscan"),
                      onPressed: _launchExplorer,
                    )
                  ].animate(interval: 100.ms).fadeIn().slideY(begin: 0.1),
              );
            },
          ),
        ),
      ),
    );
  }
  
  Widget _buildLoadingState() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: kToolbarHeight + MediaQuery.of(context).padding.top + 20,
        left: 16, right: 16, bottom: 40,
      ),
      child: Column(
        children: [
          const ShimmerWidget.rectangular(height: 80),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: List.generate(4, (_) => const ShimmerWidget.rectangular(height: 100)),
          ),
          const SizedBox(height: 24),
          const ShimmerWidget.rectangular(height: 250),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required ThemeData theme,
    required String title,
    required String value,
    required IconData icon,
    Color? color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: theme.textTheme.bodyMedium),
                FaIcon(icon, size: 16, color: color ?? theme.colorScheme.secondary),
              ],
            ),
            Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(ThemeData theme, List<Map<String, String>> transactions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Recent Transactions", style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: transactions.map((tx) {
              return ListTile(
                leading: const FaIcon(FontAwesomeIcons.receipt),
                title: Text(tx['hash']!, style: const TextStyle(fontFamily: 'monospace', fontSize: 14)),
                subtitle: Text("From: ${tx['from']} To: ${tx['to']}"),
                trailing: Text(tx['amount']!),
                dense: true,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
