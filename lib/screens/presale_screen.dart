// lib/screens/presale_screen.dart
import 'package:cabal/services/web3_service.dart';
import 'package:cabal/widgets/diamond_mesh_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:intl/intl.dart';
import '../../features/wallet/application/wallet_provider.dart';
import '../utils/app_colors.dart';

class PresaleScreen extends StatefulWidget {
  const PresaleScreen({Key? key}) : super(key: key);

  @override
  State<PresaleScreen> createState() => _PresaleScreenState();
}

class _PresaleScreenState extends State<PresaleScreen> {
  final TextEditingController _ethController = TextEditingController();
  
  final double _presaleRate = 2500;
  final double _presaleCap = 10000000;
  
  Future<Map<String, dynamic>>? _presaleDataFuture;
  bool _isProcessing = false;
  String _cblToReceive = "0.0";

  @override
  void initState() {
    super.initState();
    _ethController.addListener(_updateCblAmount);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPresaleData();
    });
  }

  void _loadPresaleData() {
    final walletProvider = context.read<WalletProvider>();
    final web3Service = context.read<Web3Service>();
    if (walletProvider.isConnectedEVM) {
      setState(() {
        _presaleDataFuture = _fetchData(web3Service, walletProvider.connectedEVMAddress!);
      });
    } else {
       setState(() {
        _presaleDataFuture = web3Service.getPresaleTokensSold().then((sold) {
          return {'whitelisted': false, 'sold': sold.toDouble() / 1e18};
        });
      });
    }
  }

  Future<Map<String, dynamic>> _fetchData(Web3Service web3, String address) async {
    final results = await Future.wait([
      web3.getPresaleTokensSold(),
      web3.isWhitelisted(address),
    ]);
    return {
      'sold': (results[0] as BigInt).toDouble() / 1e18,
      'whitelisted': results[1] as bool,
    };
  }

  void _updateCblAmount() {
    final ethAmount = double.tryParse(_ethController.text);
    if (ethAmount != null && ethAmount > 0) {
      setState(() {
        _cblToReceive = (ethAmount * _presaleRate).toStringAsFixed(2);
      });
    } else {
      setState(() {
        _cblToReceive = "0.0";
      });
    }
  }

  Future<void> _buyTokens() async {
    final walletProvider = context.read<WalletProvider>();
    final web3Service = context.read<Web3Service>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (!walletProvider.isConnectedEVM) {
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Please connect your EVM wallet first.")));
      // --- THIS IS THE FIX ---
      await walletProvider.connectEVMWallet(context: context);
      _loadPresaleData();
      return;
    }
    
    final ethAmount = double.tryParse(_ethController.text);
    if (ethAmount == null || ethAmount <= 0) {
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Please enter a valid amount to swap.")));
      return;
    }
    
    setState(() => _isProcessing = true);

    try {
      final amountInWei = EtherAmount.fromUnitAndValue(EtherUnit.ether, ethAmount).getInWei;
      final tx = web3Service.buildBuyPresaleTokensTransaction(amountInWei: amountInWei);
      
      final txHash = await walletProvider.sendTransaction(tx);

      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text("Purchase successful! Tx: $txHash"),
        backgroundColor: AppColors.success,
      ));
      _ethController.clear();
      _loadPresaleData();
    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Transaction failed: $e"), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  void dispose() {
    _ethController.removeListener(_updateCblAmount);
    _ethController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("\$CBL Token Presale"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: DiamondMeshBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              top: kToolbarHeight + MediaQuery.of(context).padding.top + 20,
              left: 16, right: 16, bottom: 40
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("Join the Cabal Early", style: theme.textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Text("Purchase \$CBL at a fixed presale rate before the public launch.", style: theme.textTheme.bodyMedium),
                      const Divider(height: 32),
                      
                      FutureBuilder<Map<String, dynamic>>(
                        future: _presaleDataFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(child: Text("Error: ${snapshot.error}"));
                          }
                          if (!snapshot.hasData) {
                             return const Center(child: Text("Could not load presale data."));
                          }

                          final data = snapshot.data!;
                          final bool isWhitelisted = data['whitelisted'];
                          final double tokensSold = data['sold'];

                          if (!isWhitelisted) {
                            return _buildWhitelistNotice(theme);
                          } else {
                            return _buildPurchaseForm(theme, tokensSold);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPurchaseForm(ThemeData theme, double tokensSold) {
    final progress = tokensSold / _presaleCap;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("Presale Progress", style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          minHeight: 12,
          borderRadius: BorderRadius.circular(6),
        ),
        const SizedBox(height: 4),
        Text("${NumberFormat.compact().format(tokensSold)} / ${NumberFormat.compact().format(_presaleCap)} \$CBL Sold", style: theme.textTheme.bodySmall),
        
        const SizedBox(height: 24),
        TextField(
          controller: _ethController,
          decoration: const InputDecoration(
            labelText: "Amount in ETH you pay",
            suffixIcon: Padding(
              padding: EdgeInsets.all(8.0),
              child: FaIcon(FontAwesomeIcons.ethereum),
            )
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
        ),
        
        const SizedBox(height: 16),
        TextField(
          controller: TextEditingController(text: _cblToReceive),
          readOnly: true,
          decoration: InputDecoration(
            labelText: "Amount in \$CBL you receive",
            suffixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("\$CBL", style: theme.textTheme.titleMedium),
            )
          ),
        ),

        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _isProcessing ? null : _buyTokens,
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
          child: _isProcessing 
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white))
            : const Text("Buy Tokens"),
        ),
        const SizedBox(height: 8),
        Text("Min: 0.1 ETH / Max: 5 ETH per wallet", textAlign: TextAlign.center, style: theme.textTheme.bodySmall),
      ],
    );
  }

  Widget _buildWhitelistNotice(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.error)
      ),
      child: Column(
        children: [
          const FaIcon(FontAwesomeIcons.circleExclamation, size: 32),
          const SizedBox(height: 12),
          Text("Wallet Not Whitelisted", style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.error)),
          const SizedBox(height: 8),
          Text(
            "The presale is currently open only to whitelisted addresses. Please connect a different wallet or check back for public sale announcements.",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
