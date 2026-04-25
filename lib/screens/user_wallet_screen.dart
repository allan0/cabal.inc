// lib/screens/user_wallet_screen.dart
import 'package:cabal/models/user_profile_model.dart';
import 'package:cabal/screens/list_nft_screen.dart';
import 'package:cabal/services/nft_service.dart';
import 'package:cabal/services/web3_service.dart';
import 'package:cabal/widgets/diamond_mesh_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import '../../features/wallet/application/wallet_provider.dart';
import '../utils/app_colors.dart';

// --- Data Models for UI ---
class UserToken {
  final String name;
  final String symbol;
  final String logoUrl;
  final double balance;
  final double valueUsd;
  final String contractAddress;

  UserToken({
    required this.name,
    required this.symbol,
    required this.logoUrl,
    required this.balance,
    required this.valueUsd,
    required this.contractAddress,
  });
}

class UserNft {
  final String name;
  final String collectionName;
  final String imageUrl;
  final String contractAddress;
  final int tokenId;

  UserNft({
    required this.name,
    required this.collectionName,
    required this.imageUrl,
    required this.contractAddress,
    required this.tokenId,
  });
}

class UserWalletScreen extends StatefulWidget {
  final UserProfile userProfile;
  const UserWalletScreen({Key? key, required this.userProfile}) : super(key: key);

  @override
  State<UserWalletScreen> createState() => _UserWalletScreenState();
}

class _UserWalletScreenState extends State<UserWalletScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Future<Map<String, dynamic>>? _walletDataFuture;

  // --- Services ---
  late final Web3Service _web3Service;
  late final NftService _nftService;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _web3Service = context.read<Web3Service>();
    _nftService = NftService();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final walletProvider = context.read<WalletProvider>();
      if (walletProvider.isConnectedEVM) {
        _loadWalletData();
      }
    });
  }

  void _loadWalletData() {
    setState(() {
      _walletDataFuture = _fetchWalletData();
    });
  }

  Future<Map<String, dynamic>> _fetchWalletData() async {
    final walletProvider = context.read<WalletProvider>();
    final address = walletProvider.connectedEVMAddress!;
    if (address.isEmpty) return {'tokens': [], 'nfts': []};

    try {
      final results = await Future.wait([
        _web3Service.getUserCblBalance(address),
        _web3Service.getEthBalance(address),
        _nftService.fetchUserNfts(address),
      ]);

      // TODO: Get real prices from a price feed service (e.g., CoinGecko)
      final cblBalance = (results[0] as BigInt).toDouble() / 1e18;
      final ethBalance = (results[1] as EtherAmount).getValueInUnit(EtherUnit.ether);
      final cblPrice = 0.025;
      final ethPrice = 3000.0;
      
      final tokens = [
        UserToken(name: "Cabal", symbol: "CBL", logoUrl: "assets/images/cabal_logo.png", balance: cblBalance, valueUsd: cblBalance * cblPrice, contractAddress: _web3Service.cabalTokenAddress),
        UserToken(name: "Ethereum", symbol: "ETH", logoUrl: "", balance: ethBalance, valueUsd: ethBalance * ethPrice, contractAddress: "0x0"),
      ];
      
      final nfts = results[2] as List<UserNft>;
      
      return {'tokens': tokens, 'nfts': nfts};
    } catch (e) {
      debugPrint("Error fetching wallet data: $e");
      rethrow;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final walletProvider = context.watch<WalletProvider>();
    
    if (!walletProvider.isConnectedEVM) {
      return Scaffold(
        appBar: AppBar(title: const Text("My Wallet")),
        body: DiamondMeshBackground(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Please connect your wallet to view your assets."),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => walletProvider.connectEVMWallet(context: context),
                  child: const Text("Connect Wallet"),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("My Wallet"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: DiamondMeshBackground(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _walletDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (!snapshot.hasData) {
              return const Center(child: Text("No data found."));
            }

            final data = snapshot.data!;
            final List<UserToken> tokens = data['tokens'];
            final List<UserNft> nfts = data['nfts'];
            final totalValue = tokens.fold<double>(0, (sum, item) => sum + item.valueUsd);
            final currencyFormat = NumberFormat.currency(symbol: '\$');

            return Column(
              children: [
                SizedBox(height: kToolbarHeight + MediaQuery.of(context).padding.top),
                _buildHeader(theme, currencyFormat.format(totalValue)),
                TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(text: 'Tokens (${tokens.length})'),
                    Tab(text: 'NFTs (${nfts.length})'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTokensTab(theme, currencyFormat, tokens),
                      _buildNftsTab(theme, nfts),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, String totalValue) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text("Total Balance", style: theme.textTheme.titleMedium),
          Text(totalValue, style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _buildTokensTab(ThemeData theme, NumberFormat currencyFormat, List<UserToken> tokens) {
    if (tokens.isEmpty) return const Center(child: Text("You don't own any tokens."));

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: tokens.length,
      itemBuilder: (context, index) {
        final token = tokens[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: token.logoUrl.startsWith('assets/') 
                ? Image.asset(token.logoUrl) 
                : FaIcon(FontAwesomeIcons.circleQuestion, color: theme.iconTheme.color),
            ),
            title: Text(token.name),
            subtitle: Text("${token.balance.toStringAsFixed(4)} ${token.symbol}"),
            trailing: Text(currencyFormat.format(token.valueUsd)),
            onTap: () => _showTokenActions(token),
          ),
        ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.2);
      },
    );
  }

  Widget _buildNftsTab(ThemeData theme, List<UserNft> nfts) {
    if (nfts.isEmpty) return const Center(child: Text("You don't own any NFTs."));

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: nfts.length,
      itemBuilder: (context, index) {
        final nft = nfts[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _showNftActions(nft),
            child: GridTile(
              footer: GridTileBar(
                backgroundColor: Colors.black45,
                title: Text(nft.name, style: const TextStyle(fontSize: 12)),
                subtitle: Text(nft.collectionName, style: const TextStyle(fontSize: 10)),
              ),
              child: Image.network(nft.imageUrl, fit: BoxFit.cover),
            ),
          ),
        ).animate().fadeIn(delay: (100 * index).ms).scale(begin: const Offset(0.8, 0.8));
      },
    );
  }

  void _showTokenActions(UserToken token) {
    showModalBottomSheet(
      context: context, 
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(title: Text(token.name, style: Theme.of(context).textTheme.headlineSmall), subtitle: Text("Manage your ${token.symbol} tokens")),
          const Divider(),
          ListTile(leading: const FaIcon(FontAwesomeIcons.rightLeft), title: const Text('Swap'), onTap: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Swap functionality coming soon!")));
          }),
          ListTile(leading: const FaIcon(FontAwesomeIcons.arrowUpRightFromSquare), title: const Text('Send'), onTap: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Send functionality coming soon!")));
          }),
        ],
      )
    );
  }

  void _showNftActions(UserNft nft) {
    showModalBottomSheet(
      context: context, 
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(title: Text(nft.name, style: Theme.of(context).textTheme.headlineSmall), subtitle: Text("From ${nft.collectionName}")),
          const Divider(),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.tag), 
            title: const Text('List for Sale'), 
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, PageTransition(
                type: PageTransitionType.bottomToTop,
                child: ListNftScreen(nft: nft, userProfile: widget.userProfile)
              )).then((listedSuccessfully) {
                if (listedSuccessfully == true) {
                  _loadWalletData(); // Refresh wallet data if item was listed
                }
              });
            },
          ),
          ListTile(leading: const FaIcon(FontAwesomeIcons.arrowUpRightFromSquare), title: const Text('Transfer'), onTap: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("NFT transfer functionality coming soon!")));
          }),
        ],
      )
    );
  }
}
