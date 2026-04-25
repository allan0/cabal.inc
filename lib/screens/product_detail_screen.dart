// lib/screens/product_detail_screen.dart
import 'package:cabal/features/wallet/application/wallet_provider.dart';
import 'package:cabal/models/merchandise_product_model.dart';
import 'package:cabal/models/user_profile_model.dart';
import 'package:cabal/services/web3_service.dart';
import 'package:cabal/widgets/diamond_mesh_background.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import '../utils/app_colors.dart';

class ProductDetailScreen extends StatefulWidget {
  final MerchandiseProduct product;
  final UserProfile userProfile;

  const ProductDetailScreen({
    Key? key,
    required this.product,
    required this.userProfile,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isApproved = false; // To track if the 'approve' transaction was successful
  bool _isApproving = false;
  bool _isPurchasing = false;

  Future<void> _approvePurchase() async {
    final walletProvider = context.read<WalletProvider>();
    final web3Service = context.read<Web3Service>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (!walletProvider.isConnectedEVM) {
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Please connect your wallet to approve.")));
      return;
    }

    setState(() => _isApproving = true);

    try {
      final tx = web3Service.buildErc20ApproveTransaction(
        tokenAddress: widget.product.paymentTokenAddress,
        spenderAddress: web3Service.merchandiseStoreAddress, // The contract needs approval
        amountInWei: BigInt.parse(widget.product.priceInWei),
      );

      final txHash = await walletProvider.sendTransaction(tx);
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Approval sent! Waiting for confirmation... Tx: $txHash")));
      
      // TODO: In production, listen for transaction receipt.
      await Future.delayed(const Duration(seconds: 15));

      setState(() => _isApproved = true);
      scaffoldMessenger.showSnackBar(const SnackBar(
        content: Text("Approved! You can now complete the purchase."),
        backgroundColor: AppColors.success,
      ));

    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Approval failed: $e"), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() => _isApproving = false);
    }
  }

  Future<void> _purchaseItem() async {
    final walletProvider = context.read<WalletProvider>();
    final web3Service = context.read<Web3Service>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    setState(() => _isPurchasing = true);
    
    try {
      final tx = web3Service.buildPurchaseTransaction(
        productId: BigInt.from(widget.product.productIdOnChain),
      );

      final txHash = await walletProvider.sendTransaction(tx);
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Purchase transaction sent! Waiting for confirmation... Tx: $txHash")));

      // TODO: Listen for transaction receipt.
      await Future.delayed(const Duration(seconds: 15));
      
      // TODO: Deactivate in Supabase after successful purchase.
      // await supabaseService.deactivateMerch(widget.product.id);

      scaffoldMessenger.showSnackBar(const SnackBar(
        content: Text("Purchase successful!"),
        backgroundColor: AppColors.success,
      ));
      navigator.pop(true);

    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Purchase failed: $e"), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() => _isPurchasing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberFormat = NumberFormat("###,##0.00####", "en_US");
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.product.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: DiamondMeshBackground(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(top: kToolbarHeight + MediaQuery.of(context).padding.top),
                children: [
                  Image.network(
                    widget.product.imageUrl ?? 'https://via.placeholder.com/400/1E1E1E/FFFFFF?Text=Merch',
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.name,
                          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Divider(height: 32),
                        Text("Description", style: theme.textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(
                          widget.product.description ?? "No description provided.",
                          style: theme.textTheme.bodyLarge,
                        ),
                        if (widget.product.bonusAmount != null && widget.product.bonusAmount! > 0) ...[
                          const Divider(height: 32),
                          Text("Bonus Reward", style: theme.textTheme.titleLarge),
                          const SizedBox(height: 8),
                          Chip(
                            avatar: const FaIcon(FontAwesomeIcons.medal),
                            label: Text("Get ${numberFormat.format(widget.product.bonusAmount)} ${widget.product.bonusTokenSymbol ?? 'Tokens'} with this purchase!"),
                            backgroundColor: AppColors.gold.withOpacity(0.2),
                          )
                        ]
                      ],
                    ),
                  )
                ],
              ),
            ),
            _buildBottomBar(theme, numberFormat),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(ThemeData theme, NumberFormat numberFormat) {
    bool isLoading = _isApproving || _isPurchasing;
    
    return Material(
      elevation: 8,
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).padding.bottom + 16),
        color: theme.cardColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Price", style: theme.textTheme.bodyMedium),
                Text(
                  "${numberFormat.format(widget.product.price)} ${widget.product.paymentTokenSymbol}",
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                ),
              ],
            ),
            
            if (!_isApproved)
              ElevatedButton(
                onPressed: isLoading ? null : _approvePurchase,
                child: _isApproving ? const CircularProgressIndicator(color: Colors.white) : const Text("1. Approve Purchase"),
              ),
            
            if (_isApproved)
              ElevatedButton(
                onPressed: isLoading ? null : _purchaseItem,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                child: _isPurchasing ? const CircularProgressIndicator(color: Colors.white) : const Text("2. Buy Now"),
              )
          ],
        ),
      ),
    );
  }
}
