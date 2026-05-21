import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../features/wallet/application/wallet_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/diamond_mesh_background.dart';

class DexScreen extends StatefulWidget {
  const DexScreen({super.key});

  @override
  State<DexScreen> createState() => _DexScreenState();
}

class _DexScreenState extends State<DexScreen> {
  final TextEditingController _amountController = TextEditingController();
  bool _isSwapping = false;

  Future<void> _handleSwap() async {
    final wallet = context.read<WalletProvider>();
    if (!wallet.isConnectedEVM) return;

    setState(() => _isSwapping = true);
    
    // Logic: In a production DEX, we'd build a swap transaction via a Router contract (Uniswap/Pancake)
    // Here we simulate the delay and the confirmation popup.
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() => _isSwapping = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Swap Successfully Composed. Check Wallet."), backgroundColor: AppColors.success),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DiamondMeshBackground(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FaIcon(FontAwesomeIcons.rightLeft, size: 48, color: AppColors.gold),
              const SizedBox(height: 24),
              const Text("SWAP ASSETS", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2)),
              const SizedBox(height: 32),
              
              _buildSwapInput("PAY", "ETH"),
              const SizedBox(height: 8),
              const FaIcon(FontAwesomeIcons.circleArrowDown, size: 20, color: AppColors.greyText),
              const SizedBox(height: 8),
              _buildSwapInput("RECEIVE", "CBL"),
              
              const SizedBox(height: 40),
              
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSwapping ? null : _handleSwap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isSwapping 
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text("PROCEED TO SWAP", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwapInput(String label, String token) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.greyText, letterSpacing: 1)),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(border: InputBorder.none, hintText: "0.0"),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Text(token, style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
