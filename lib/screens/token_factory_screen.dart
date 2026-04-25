// lib/screens/token_factory_screen.dart
import 'package:cabal/features/wallet/application/wallet_provider.dart';
import 'package:cabal/models/user_profile_model.dart';
import 'package:cabal/services/web3_service.dart';
import 'package:cabal/utils/app_colors.dart';
import 'package:cabal/widgets/animated_particle_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TokenFactoryScreen extends StatefulWidget {
  final UserProfile userProfile;
  const TokenFactoryScreen({Key? key, required this.userProfile}) : super(key: key);

  @override
  State<TokenFactoryScreen> createState() => _TokenFactoryScreenState();
}

class _TokenFactoryScreenState extends State<TokenFactoryScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form Controllers
  final _tokenNameController = TextEditingController();
  final _tokenSymbolController = TextEditingController();
  final _totalSupplyController = TextEditingController();

  bool _isDeploying = false;
  String? _deployedAddress;

  Future<void> _deployToken() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final walletProvider = context.read<WalletProvider>();
    final web3Service = context.read<Web3Service>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (!walletProvider.isConnectedEVM) {
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Please connect your EVM wallet to deploy.")));
      return;
    }

    setState(() => _isDeploying = true);

    try {
      // In a real application, you would have a `deployERC20` function in your Web3Service.
      // This function would take the name, symbol, and supply, and use web3dart to
      // deploy the bytecode of a pre-compiled ERC20 contract.

      // --- SIMULATION ---
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Preparing deployment... Please confirm in your wallet.")));
      await Future.delayed(const Duration(seconds: 4)); // Simulate user confirming in wallet
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Deploying to the blockchain... This may take a moment.")));
      await Future.delayed(const Duration(seconds: 8)); // Simulate deployment time
      // --- END SIMULATION ---

      // This would be the real contract address returned from the deployment
      final newAddress = "0x" + List.generate(40, (_) => 'abcdef1234567890'[DateTime.now().millisecond % 16]).join();

      setState(() {
        _deployedAddress = newAddress;
      });

      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text("Token contract deployed successfully!"), backgroundColor: AppColors.success),
      );

    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Deployment failed: $e"), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() => _isDeploying = false);
    }
  }

  @override
  void dispose() {
    _tokenNameController.dispose();
    _tokenSymbolController.dispose();
    _totalSupplyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Token Factory"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: AnimatedParticleBackground(
        child: AbsorbPointer(
          absorbing: _isDeploying,
          child: _deployedAddress != null
              ? _buildSuccessView(theme)
              : _buildFormView(theme),
        ),
      ),
    );
  }

  Widget _buildFormView(ThemeData theme) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.only(
          top: kToolbarHeight + MediaQuery.of(context).padding.top + 20,
          left: 16, right: 16, bottom: 40
        ),
        children: [
          Text("Launch Your ERC20 Token", style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text("Fill in the details for your new community token. This will be deployed as a standard ERC20 contract on the Sepolia testnet."),
          const Divider(height: 32),

          TextFormField(
            controller: _tokenNameController,
            decoration: const InputDecoration(labelText: "Token Name *", hintText: "e.g., Cabal Gold"),
            validator: (v) => (v == null || v.isEmpty) ? "Token name is required" : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _tokenSymbolController,
            decoration: const InputDecoration(labelText: "Token Symbol *", hintText: "e.g., CBLG"),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[A-Z]')), LengthLimitingTextInputFormatter(5)],
            validator: (v) => (v == null || v.isEmpty) ? "Symbol is required" : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _totalSupplyController,
            decoration: const InputDecoration(labelText: "Total Supply *", hintText: "e.g., 1000000"),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) {
              if (v == null || v.isEmpty) return "Total supply is required";
              if (int.tryParse(v) == null || int.parse(v) <= 0) return "Must be a valid positive number";
              return null;
            },
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            icon: _isDeploying 
              ? Container(width: 24, height: 24, padding: const EdgeInsets.all(2.0), child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
              : const FaIcon(FontAwesomeIcons.rocket),
            label: Text(_isDeploying ? 'Deploying...' : 'Deploy Token'),
            onPressed: _isDeploying ? null : _deployToken,
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView(ThemeData theme) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FaIcon(FontAwesomeIcons.solidCircleCheck, size: 48, color: AppColors.success),
              const SizedBox(height: 16),
              Text("Deployment Successful!", style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              const Text("Your new ERC20 token contract is live on the blockchain.", textAlign: TextAlign.center),
              const SizedBox(height: 16),
              SelectableText(_deployedAddress!, style: const TextStyle(fontFamily: 'monospace')),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.open_in_new),
                label: const Text("View on Etherscan"),
                onPressed: () async {
                  final url = Uri.parse('https://sepolia.etherscan.io/address/$_deployedAddress');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Back to Web3 Hub"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
