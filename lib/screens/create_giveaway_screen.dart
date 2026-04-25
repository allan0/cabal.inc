// lib/screens/create_giveaway_screen.dart
import 'package:cabal/features/wallet/application/wallet_provider.dart';
import 'package:cabal/services/web3_service.dart';
import 'package:cabal/widgets/animated_particle_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';

enum PrizeType { ETH, ERC20 }

class CreateGiveawayScreen extends StatefulWidget {
  final String cabalId;
  const CreateGiveawayScreen({Key? key, required this.cabalId}) : super(key: key);

  @override
  State<CreateGiveawayScreen> createState() => _CreateGiveawayScreenState();
}

class _CreateGiveawayScreenState extends State<CreateGiveawayScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _goalController = TextEditingController();
  final _prizeAmountController = TextEditingController();
  final _tokenAddressController = TextEditingController();

  PrizeType _selectedPrizeType = PrizeType.ETH;
  bool _isLaunching = false;

  Future<void> _launchGiveaway() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    
    final walletProvider = context.read<WalletProvider>();
    final web3Service = context.read<Web3Service>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    if (!walletProvider.isConnectedEVM) {
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Please connect your wallet to launch a giveaway.")));
      return;
    }

    setState(() => _isLaunching = true);

    try {
      // TODO: Implement the actual deployGiveawayContract function in Web3Service.
      // It will need to handle the ERC20 approval flow if necessary.
      // final newGiveawayContractAddress = await web3Service.deployGiveawayContract(
      //   goalTarget: _goalController.text.trim(),
      //   prizeType: _selectedPrizeType,
      //   prizeAmount: _prizeAmountController.text.trim(),
      //   tokenAddress: _tokenAddressController.text.trim(),
      //   credentials: walletProvider.getCredentials(),
      // );

      // Simulate transaction flow
      if (_selectedPrizeType == PrizeType.ERC20) {
        scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Please approve the token transfer in your wallet...")));
        await Future.delayed(const Duration(seconds: 3));
      }
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Deploying giveaway contract... Please confirm in your wallet.")));
      await Future.delayed(const Duration(seconds: 4));

      // TODO: Link the newGiveawayContractAddress to the cabalId in Supabase.
      
      scaffoldMessenger.showSnackBar(const SnackBar(
        content: Text("Giveaway contract launched successfully!"),
        backgroundColor: AppColors.success,
      ));
      navigator.pop(true);

    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Launch failed: $e"), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() => _isLaunching = false);
    }
  }
  
  @override
  void dispose() {
    _goalController.dispose();
    _prizeAmountController.dispose();
    _tokenAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Create a New Giveaway")),
      body: AnimatedParticleBackground(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text("Launch a Trustless Giveaway", style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                "Lock a prize into a smart contract that automatically pays out to a winner once you confirm the goal is met. This builds trust and supercharges your community growth.",
                style: theme.textTheme.bodyLarge,
              ),
              const Divider(height: 32),
              
              Text("1. Define the Prize", style: theme.textTheme.titleLarge),
              const SizedBox(height: 16),
              ToggleButtons(
                isSelected: [_selectedPrizeType == PrizeType.ETH, _selectedPrizeType == PrizeType.ERC20],
                onPressed: (index) {
                  setState(() {
                    _selectedPrizeType = index == 0 ? PrizeType.ETH : PrizeType.ERC20;
                  });
                },
                borderRadius: BorderRadius.circular(8),
                children: const [
                  Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: Text("ETH")),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: Text("ERC20 Token")),
                ],
              ),
              const SizedBox(height: 16),
              if (_selectedPrizeType == PrizeType.ERC20)
                TextFormField(
                  controller: _tokenAddressController,
                  decoration: const InputDecoration(labelText: "ERC20 Token Contract Address *"),
                  validator: (v) => (_selectedPrizeType == PrizeType.ERC20 && (v == null || v.isEmpty)) ? "Token address is required" : null,
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _prizeAmountController,
                decoration: InputDecoration(labelText: "Prize Amount *"),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
                validator: (v) {
                  if (v == null || v.isEmpty) return "Prize amount is required";
                  if (double.tryParse(v) == null || double.parse(v) <= 0) return "Must be a valid positive number";
                  return null;
                },
              ),
              const SizedBox(height: 24),

              Text("2. Set the Goal", style: theme.textTheme.titleLarge),
              const SizedBox(height: 16),
               TextFormField(
                controller: _goalController,
                decoration: const InputDecoration(labelText: "Goal Description *", hintText: "e.g., '1,000 New Referrals'"),
                validator: (v) => (v == null || v.isEmpty) ? "Goal description is required" : null,
              ),
              const SizedBox(height: 32),

              ElevatedButton.icon(
                icon: _isLaunching
                    ? Container(width: 24, height: 24, padding: const EdgeInsets.all(2.0), child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                    : const FaIcon(FontAwesomeIcons.rocket),
                label: Text(_isLaunching ? 'Deploying...' : 'Launch Giveaway'),
                onPressed: _isLaunching ? null : _launchGiveaway,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
