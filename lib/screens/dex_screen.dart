// lib/screens/dex_screen.dart
import 'package:cabal/models/cabal_model.dart';
import 'package:cabal/models/user_profile_model.dart';
import 'package:cabal/services/web3_service.dart';
import 'package:cabal/widgets/diamond_mesh_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../features/wallet/application/wallet_provider.dart';

class DexScreen extends StatefulWidget {
  final Cabal cabal;
  final UserProfile userProfile;

  const DexScreen({
    Key? key,
    required this.cabal,
    required this.userProfile,
  }) : super(key: key);

  @override
  State<DexScreen> createState() => _DexScreenState();
}

class _DexScreenState extends State<DexScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _payController = TextEditingController();
  final TextEditingController _receiveController = TextEditingController();

  bool _isSwapping = false;

  // Placeholder values for swap rate and balance
  final double _swapRate = 1500.50; // e.g., 1 ETH = 1500.50 $TOKEN
  final double _nativeBalance = 1.25; // e.g., 1.25 ETH

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _payController.addListener(_onPayAmountChanged);
  }

  void _onPayAmountChanged() {
    final payAmount = double.tryParse(_payController.text);
    if (payAmount != null) {
      final receiveAmount = payAmount * _swapRate;
      _receiveController.text = receiveAmount.toStringAsFixed(4);
    } else {
      _receiveController.clear();
    }
  }

  Future<void> _performSwap() async {
    final walletProvider = context.read<WalletProvider>();
    final web3Service = context.read<Web3Service>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (!walletProvider.isConnectedEVM) {
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Please connect your EVM wallet first.")));
      return;
    }
    
    final payAmount = double.tryParse(_payController.text);
    if (payAmount == null || payAmount <= 0) {
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Please enter a valid amount to swap.")));
      return;
    }
    
    setState(() => _isSwapping = true);
    
    try {
      // In a real implementation, you would:
      // 1. Get the swap parameters (amounts, path) from a router contract or calculate them.
      // 2. Encode the function call for the smart contract's swap method.
      // 3. Use walletProvider to send the transaction.
      // For now, we simulate the process.
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Simulating swap... Please check your wallet to confirm.")));
      await Future.delayed(const Duration(seconds: 3)); // Simulate wallet confirmation delay
      
      // final txHash = await web3Service.executeSwap(...);
      
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Swap submitted successfully! Tx: 0x...placeholder")));
      _payController.clear();
    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Swap failed: $e"), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() => _isSwapping = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _payController.dispose();
    _receiveController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chainSymbol = "ETH"; // This could be dynamic based on chainId in the future
    final cabalTokenSymbol = widget.cabal.tokenSymbol ?? 'TOKEN';
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('${widget.cabal.name} Treasury & DEX'),
        backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.85),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: FaIcon(FontAwesomeIcons.rightLeft), text: 'Swap'),
            Tab(icon: FaIcon(FontAwesomeIcons.landmark), text: 'Treasury'),
          ],
        ),
      ),
      body: DiamondMeshBackground(
        child: Padding(
          padding: EdgeInsets.only(top: kToolbarHeight + (AppBar().preferredSize.height) + MediaQuery.of(context).padding.top),
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildSwapView(theme, chainSymbol, cabalTokenSymbol),
              _buildTreasuryView(theme, cabalTokenSymbol),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwapView(ThemeData theme, String chainSymbol, String cabalTokenSymbol) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSwapInput(
                theme: theme,
                label: "You Pay",
                controller: _payController,
                tokenSymbol: chainSymbol,
                balance: _nativeBalance,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: IconButton(
                  icon: const FaIcon(FontAwesomeIcons.arrowDown),
                  onPressed: () { /* TODO: Implement logic to swap input fields */ },
                ),
              ),
              _buildSwapInput(
                theme: theme,
                label: "You Receive",
                controller: _receiveController,
                tokenSymbol: cabalTokenSymbol,
                readOnly: true,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSwapping ? null : _performSwap,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: _isSwapping 
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white))
                    : const Text('Swap'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSwapInput({
    required ThemeData theme,
    required String label,
    required TextEditingController controller,
    required String tokenSymbol,
    double? balance,
    bool readOnly = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: theme.textTheme.bodySmall),
              if (balance != null)
                Text("Balance: ${balance.toStringAsFixed(4)}", style: theme.textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  readOnly: readOnly,
                  decoration: const InputDecoration(
                    hintText: '0.0',
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: theme.textTheme.headlineSmall,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Chip(
                label: Text(tokenSymbol, style: theme.textTheme.titleMedium),
                avatar: const FaIcon(FontAwesomeIcons.circleQuestion), // Replace with token logo later
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildTreasuryView(ThemeData theme, String cabalTokenSymbol) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FaIcon(FontAwesomeIcons.buildingColumns, size: 40),
              const SizedBox(height: 16),
              Text('Treasury Information', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                'Details about the $cabalTokenSymbol token, treasury balance, and transaction history will be displayed here. (Coming Soon)',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
