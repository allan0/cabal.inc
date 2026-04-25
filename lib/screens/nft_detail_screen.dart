// lib/screens/nft_detail_screen.dart
import 'package:cabal/models/nft_listing_model.dart';
import 'package:cabal/services/supabase_service.dart';
import 'package:cabal/services/web3_service.dart';
import 'package:cabal/widgets/diamond_mesh_background.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import '../../features/wallet/application/wallet_provider.dart';
import '../utils/app_colors.dart';

class NftDetailScreen extends StatefulWidget {
  final NftListing listing;
  const NftDetailScreen({Key? key, required this.listing}) : super(key: key);

  @override
  State<NftDetailScreen> createState() => _NftDetailScreenState();
}

class _NftDetailScreenState extends State<NftDetailScreen> {
  bool _isBuying = false;

  Future<void> _buyNft() async {
    final walletProvider = context.read<WalletProvider>();
    final web3Service = context.read<Web3Service>();
    final supabaseService = context.read<SupabaseService>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    if (!walletProvider.isConnectedEVM) {
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Please connect your wallet to buy.")));
      walletProvider.connectEVMWallet(context: context);
      return;
    }

    if (walletProvider.connectedEVMAddress?.toLowerCase() == widget.listing.sellerAddress.toLowerCase()) {
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("You cannot buy your own listing.")));
      return;
    }

    setState(() => _isBuying = true);

    try {
      // In a real app, you would have a buildBuyItemTransaction method in your Web3Service
      // For now, we simulate the logic.
      final tx = Transaction(
        to: EthereumAddress.fromHex(web3Service.nftMarketplaceAddress), // Placeholder
        value: EtherAmount.inWei(BigInt.parse(widget.listing.priceWei)),
        // data: web3Service.buildBuyItemData(widget.listing.nftContractAddress, widget.listing.tokenId),
      );
      
      final txHash = await walletProvider.sendTransaction(tx);
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Purchase transaction sent! Waiting for confirmation... Tx: $txHash")));

      // TODO: In a real app, you would wait for the transaction to be mined.
      await Future.delayed(const Duration(seconds: 5));

      // After successful transaction, update the off-chain cache
      await supabaseService.deactivateNftListing(widget.listing.id);

      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text("Purchase successful! You now own ${widget.listing.nftName}."),
        backgroundColor: AppColors.success,
      ));
      
      navigator.pop(true); // Pop with success to trigger refresh on previous screen

    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Purchase failed: $e"), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() => _isBuying = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberFormat = NumberFormat("###,##0.00####", "en_US");
    final displaySellerAddress = "${widget.listing.sellerAddress.substring(0, 6)}...${widget.listing.sellerAddress.substring(widget.listing.sellerAddress.length - 4)}";

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.listing.nftName ?? "NFT Details"),
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
                  Hero(
                    tag: 'nft_image_${widget.listing.id}',
                    child: Image.network(
                      widget.listing.nftImageUrl ?? 'https://via.placeholder.com/400/1E1E1E/FFFFFF?Text=NFT',
                      height: MediaQuery.of(context).size.width,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.listing.collectionName ?? 'Unknown Collection',
                          style: theme.textTheme.titleMedium
                        ),
                        Text(
                          widget.listing.nftName ?? 'Unnamed NFT',
                          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        SelectableText(
                          "Owned by: $displaySellerAddress",
                          style: theme.textTheme.bodyMedium?.copyWith(fontFamily: 'monospace'),
                        ),
                        const Divider(height: 32),
                        Text("Description", style: theme.textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(
                          "This unique digital asset represents a verifiable item within the Cabal ecosystem. Ownership is secured on the blockchain.", // Placeholder description
                          style: theme.textTheme.bodyLarge,
                        ),
                         const SizedBox(height: 16),
                        // Placeholder for attributes
                        Text("Attributes", style: theme.textTheme.titleLarge),
                        const SizedBox(height: 8),
                        const Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                             Chip(label: Text("Type: Real Estate")),
                             Chip(label: Text("Location: Genesis City")),
                          ],
                        )
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
    final walletProvider = context.watch<WalletProvider>();
    final isOwner = walletProvider.isConnectedEVM && walletProvider.connectedEVMAddress?.toLowerCase() == widget.listing.sellerAddress.toLowerCase();
    
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
                Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.ethereum, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      numberFormat.format(widget.listing.priceInEth),
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            ElevatedButton.icon(
              icon: _isBuying
                  ? Container(width: 24, height: 24, padding: const EdgeInsets.all(2.0), child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                  : const Icon(Icons.shopping_cart_checkout_rounded),
              label: Text(_isBuying ? 'Processing...' : (isOwner ? 'Your Listing' : 'Buy Now')),
              onPressed: (_isBuying || isOwner) ? null : _buyNft,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                textStyle: theme.textTheme.titleLarge,
              ),
            )
          ],
        ),
      ),
    );
  }
}
