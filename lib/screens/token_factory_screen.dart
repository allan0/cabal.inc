import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../features/wallet/application/wallet_provider.dart';
import '../services/web3_service.dart';
import '../utils/app_colors.dart';
import '../widgets/diamond_mesh_background.dart';

class TokenFactoryScreen extends StatefulWidget {
  const TokenFactoryScreen({super.key});

  @override
  State<TokenFactoryScreen> createState() => _TokenFactoryScreenState();
}

class _TokenFactoryScreenState extends State<TokenFactoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _symbolController = TextEditingController();
  final _supplyController = TextEditingController();
  bool _isDeploying = false;

  Future<void> _launchToken() async {
    if (!_formKey.currentState!.validate()) return;
    
    final wallet = context.read<WalletProvider>();
    if (!wallet.isConnectedEVM) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Connect Wallet First")));
       return;
    }

    setState(() => _isDeploying = true);

    try {
      // In a real implementation, this calls the buildDeployTokenTransaction 
      // in Web3Service which targets the Factory Contract Address
      await Future.delayed(const Duration(seconds: 3));
      
      if (mounted) {
        setState(() => _isDeploying = false);
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isDeploying = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: AppColors.error));
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text("TOKEN DEPLOYED"),
        content: const Text("Your community token is now live on the Sepolia Testnet. You can now link it to your Cabal."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("LFG!", style: TextStyle(color: AppColors.gold)))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TOKEN FACTORY"), backgroundColor: Colors.transparent, elevation: 0),
      body: DiamondMeshBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: FaIcon(FontAwesomeIcons.coins, size: 64, color: AppColors.gold)),
                const SizedBox(height: 32),
                const Text("LAUNCH YOUR ECONOMY", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                const Text("Deploy a standard ERC20 token with custom supply and branding.", style: TextStyle(color: AppColors.greyText)),
                const SizedBox(height: 40),
                
                _buildField("TOKEN NAME", "e.g. Genesis Gold", _nameController),
                const SizedBox(height: 20),
                _buildField("SYMBOL", "e.g. GOLD", _symbolController),
                const SizedBox(height: 20),
                _buildField("INITIAL SUPPLY", "e.g. 1000000", _supplyController, isNumber: true),
                
                const SizedBox(height: 48),
                
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isDeploying ? null : _launchToken,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: _isDeploying 
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text("DEPLOY TO BLOCKCHAIN", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, String hint, TextEditingController controller, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, letterSpacing: 2, color: AppColors.gold, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: const TextStyle(fontSize: 18),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white24),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
          validator: (v) => v!.isEmpty ? "Required" : null,
        ),
      ],
    );
  }
}
