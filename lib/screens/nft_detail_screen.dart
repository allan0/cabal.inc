import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/nft_listing_model.dart';
import '../features/wallet/application/wallet_provider.dart';
import '../services/web3_service.dart';
import '../utils/app_colors.dart';
import '../widgets/diamond_mesh_background.dart';

class NftDetailScreen extends StatefulWidget {
  final NftListing listing;
  const NftDetailScreen({super.key, required this.listing});

  @override
  State<NftDetailScreen> createState() => _NftDetailScreenState();
}

class _NftDetailScreenState extends State<NftDetailScreen> {
  bool _isProcessing = false;

  Future<void> _handleBuy() async {
    final wallet = context.read<WalletProvider>();
    final web3 = context.read<Web3Service>();

    if (!wallet.isConnectedEVM) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Connect EVM Wallet first")));
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final tx = web3.buildBuyItemTransaction(
        senderAddress: wallet.connectedEVMAddress!,
        nftContractAddress: widget.listing.nftContractAddress,
        tokenId: widget.listing.tokenId,
        priceWei: BigInt.parse(widget.listing.priceWei),
      );

      final txHash = await wallet.sendTransaction(tx);
      if (txHash != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Purchase Broadcasted: $txHash"), backgroundColor: AppColors.success),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: AppColors.error));
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      extendBodyBehindAppBar: true,
      body: DiamondMeshBackground(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(widget.listing.nftImageUrl ?? '', height: 400, width: double.infinity, fit: BoxFit.cover),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.listing.collectionName ?? 'Unknown Collection', style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(widget.listing.nftName ?? 'Item #${widget.listing.tokenId}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 24),
                          const Text("DESCRIPTION", style: TextStyle(fontSize: 12, letterSpacing: 2, color: AppColors.greyText)),
                          const SizedBox(height: 8),
                          const Text("This unique digital asset represents verified membership and ownership within the Cabal ecosystem."),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(24).copyWith(bottom: 40),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("PRICE", style: TextStyle(fontSize: 10, color: AppColors.greyText)),
                Text("${widget.listing.priceInEth} ETH", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _isProcessing ? null : _handleBuy,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gold,
              foregroundColor: Colors.black,
              minimumSize: const Size(160, 54),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _isProcessing 
              ? const CircularProgressIndicator(color: Colors.black)
              : const Text("BUY NOW", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
