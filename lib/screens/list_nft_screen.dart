// lib/screens/list_nft_screen.dart
import 'package:cabal/models/nft_listing_model.dart';
import 'package:cabal/models/user_profile_model.dart';
import 'package:cabal/services/supabase_service.dart';
import 'package:cabal/services/web3_service.dart';
import 'package:cabal/widgets/animated_particle_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import '../../features/wallet/application/wallet_provider.dart';
import '../screens/user_wallet_screen.dart'; // For the UserNft model
import '../utils/app_colors.dart';

class ListNftScreen extends StatefulWidget {
  final UserNft nft;
  final UserProfile userProfile;

  const ListNftScreen({
    Key? key,
    required this.nft,
    required this.userProfile,
  }) : super(key: key);

  @override
  State<ListNftScreen> createState() => _ListNftScreenState();
}

class _ListNftScreenState extends State<ListNftScreen> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();

  bool _isApproved = false; // To track if the 'approve' transaction was successful
  bool _isApproving = false;
  bool _isListing = false;

  Future<void> _approveMarketplace() async {
    final walletProvider = context.read<WalletProvider>();
    final web3Service = context.read<Web3Service>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (!walletProvider.isConnectedEVM) {
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Please connect your wallet first.")));
      return;
    }

    setState(() => _isApproving = true);

    try {
      final tx = web3Service.buildApproveNftTransaction(
        nftContractAddress: widget.nft.contractAddress,
        tokenId: BigInt.from(widget.nft.tokenId),
      );

      final txHash = await walletProvider.sendTransaction(tx);
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Approval transaction sent! Waiting for confirmation... Tx: $txHash")));

      // TODO: In a production app, you would use a transaction receipt listener to confirm.
      await Future.delayed(const Duration(seconds: 10));

      setState(() => _isApproved = true);
      scaffoldMessenger.showSnackBar(const SnackBar(
        content: Text("Marketplace approved! You can now list your item."),
        backgroundColor: AppColors.success,
      ));

    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Approval failed: $e"), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() => _isApproving = false);
    }
  }

  Future<void> _listItemForSale() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final walletProvider = context.read<WalletProvider>();
    final web3Service = context.read<Web3Service>();
    final supabaseService = context.read<SupabaseService>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    
    final priceDouble = double.tryParse(_priceController.text);
    if (priceDouble == null || priceDouble <= 0) return;

    setState(() => _isListing = true);

    try {
      // Safest way to convert double ETH to BigInt wei
      final etherInWei = BigInt.from(10).pow(18);
      final priceInWei = BigInt.from(priceDouble * etherInWei.toDouble());

      // --- Step 1: Send the on-chain transaction ---
      final tx = web3Service.buildListItemTransaction(
        nftContractAddress: widget.nft.contractAddress,
        tokenId: BigInt.from(widget.nft.tokenId),
        priceInWei: priceInWei,
      );
      final txHash = await walletProvider.sendTransaction(tx);
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Listing transaction sent! Waiting for confirmation... Tx: $txHash")));

      // TODO: Wait for transaction confirmation.
      await Future.delayed(const Duration(seconds: 10));
      
      // --- Step 2: Save the listing to our off-chain cache in Supabase ---
      final newListing = NftListing(
        id: '', // Supabase will generate this
        nftContractAddress: widget.nft.contractAddress,
        tokenId: widget.nft.tokenId,
        sellerAddress: walletProvider.connectedEVMAddress!,
        priceWei: priceInWei.toString(),
        isActive: true,
        listerUserId: widget.userProfile.id,
        tokenUri: '', // This could be fetched and stored if needed
        nftName: widget.nft.name,
        nftImageUrl: widget.nft.imageUrl,
        collectionName: widget.nft.collectionName,
        createdAt: DateTime.now(),
      );
      await supabaseService.createNftListing(newListing);
      
      scaffoldMessenger.showSnackBar(const SnackBar(
        content: Text("Your NFT is now listed on the marketplace!"),
        backgroundColor: AppColors.success,
      ));
      navigator.pop(true); // Pop with success to trigger refresh

    } catch (e) {
       scaffoldMessenger.showSnackBar(SnackBar(content: Text("Listing failed: $e"), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() => _isListing = false);
    }
  }


  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bool isLoading = _isApproving || _isListing;

    return Scaffold(
      appBar: AppBar(title: const Text("List NFT for Sale")),
      body: AnimatedParticleBackground(
        child: AbsorbPointer(
          absorbing: isLoading,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Image.network(widget.nft.imageUrl, height: 250, fit: BoxFit.cover),
                    ListTile(
                      title: Text(widget.nft.name),
                      subtitle: Text(widget.nft.collectionName),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text("Set Your Price", style: theme.textTheme.headlineSmall),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: "Price in ETH",
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: FaIcon(FontAwesomeIcons.ethereum),
                    )
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Price is required";
                    if (double.tryParse(v) == null || double.parse(v) <= 0) return "Enter a valid price";
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 32),
              
              if (!_isApproved)
                ElevatedButton(
                  onPressed: isLoading ? null : _approveMarketplace,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: _isApproving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('1. Approve Marketplace'),
                ),
              
              if (_isApproved)
                ElevatedButton(
                  onPressed: isLoading ? null : _listItemForSale,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.success
                  ),
                  child: _isListing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('2. List for Sale'),
                ),
              const SizedBox(height: 12),
              Text(
                _isApproved 
                ? "You've approved the marketplace. Now you can finalize the listing." 
                : "You must first send an 'approve' transaction to allow the marketplace contract to transfer your NFT upon sale.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
