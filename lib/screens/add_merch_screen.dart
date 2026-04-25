// lib/screens/add_merch_screen.dart
import 'dart:io';
import 'package:cabal/features/wallet/application/wallet_provider.dart';
import 'package:cabal/models/user_profile_model.dart';
import 'package:cabal/services/nft_service.dart';
import 'package:cabal/services/supabase_service.dart';
import 'package:cabal/services/web3_service.dart';
import 'package:cabal/widgets/animated_particle_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';

class AddMerchScreen extends StatefulWidget {
  final String cabalId;
  final UserProfile userProfile;

  const AddMerchScreen({
    Key? key,
    required this.cabalId,
    required this.userProfile,
  }) : super(key: key);

  @override
  State<AddMerchScreen> createState() => _AddMerchScreenState();
}

class _AddMerchScreenState extends State<AddMerchScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // Form Controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _paymentTokenAddressController = TextEditingController();
  final _paymentTokenSymbolController = TextEditingController();
  final _bonusTokenAddressController = TextEditingController();
  final _bonusTokenSymbolController = TextEditingController();
  final _bonusAmountController = TextEditingController();
  
  XFile? _productImage;
  bool _isListing = false;

  Future<void> _pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80, maxWidth: 1024);
    if (pickedImage != null) {
      setState(() => _productImage = pickedImage);
    }
  }

  Future<void> _listProduct() async {
    if (!_formKey.currentState!.validate()) return;
    if (_productImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please upload a product image.")));
      return;
    }
    _formKey.currentState!.save();
    
    final walletProvider = context.read<WalletProvider>();
    final web3Service = context.read<Web3Service>();
    final supabaseService = context.read<SupabaseService>();
    final nftService = NftService();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    if (!walletProvider.isConnectedEVM) {
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Please connect your wallet to list merchandise.")));
      return;
    }
    
    setState(() => _isListing = true);

    try {
      // Step 1: Upload image to IPFS to get a permanent URL for the metadata
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Uploading product image...")));
      final imageUrl = await nftService.uploadToIpfs(
        imageFile: _productImage!,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        attributes: {},
      );

      // Step 2: Send the on-chain transaction to list the product
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Sending transaction... Please confirm in your wallet.")));
      
      // TODO: Implement the buildListProductTransaction in Web3Service
      // For now, we simulate success
      await Future.delayed(const Duration(seconds: 3));
      final onChainProductId = 0; // This would come from the transaction receipt event log

      // Step 3: Save the product metadata to Supabase for fast querying
      await supabaseService.createMerchandiseProduct({
        'cabal_id': widget.cabalId,
        'creator_user_id': widget.userProfile.id,
        'product_id_onchain': onChainProductId,
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'image_url': imageUrl,
        'payment_token_address': _paymentTokenAddressController.text.trim(),
        'payment_token_symbol': _paymentTokenSymbolController.text.trim(),
        'price_in_wei': (double.parse(_priceController.text.trim()) * 1e18).toStringAsFixed(0),
        'bonus_token_address': _bonusTokenAddressController.text.trim().isEmpty ? null : _bonusTokenAddressController.text.trim(),
        'bonus_token_symbol': _bonusTokenSymbolController.text.trim().isEmpty ? null : _bonusTokenSymbolController.text.trim(),
        'bonus_amount_in_wei': _bonusAmountController.text.trim().isEmpty ? null : (double.parse(_bonusAmountController.text.trim()) * 1e18).toStringAsFixed(0),
      });
      
      scaffoldMessenger.showSnackBar(const SnackBar(
        content: Text("Product listed successfully!"),
        backgroundColor: AppColors.success,
      ));
      navigator.pop(true); // Pop with success to trigger a refresh

    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Listing failed: $e"), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() => _isListing = false);
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _paymentTokenAddressController.dispose();
    _paymentTokenSymbolController.dispose();
    _bonusTokenAddressController.dispose();
    _bonusTokenSymbolController.dispose();
    _bonusAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("List New Merchandise")),
      body: AnimatedParticleBackground(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text("Product Details", style: theme.textTheme.headlineSmall),
              const SizedBox(height: 16),
              _buildImagePicker(theme),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Product Name *"),
                validator: (v) => (v == null || v.isEmpty) ? "Name is required" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description", alignLabelWithHint: true),
                maxLines: 3,
              ),
              
              const Divider(height: 32),
              
              Text("Payment", style: theme.textTheme.headlineSmall),
              const SizedBox(height: 16),
              TextFormField(
                controller: _paymentTokenAddressController,
                decoration: const InputDecoration(labelText: "Payment Token Address *"),
                validator: (v) => (v == null || !v.startsWith('0x') || v.length != 42) ? "Enter a valid address" : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: "Price *"),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
                      validator: (v) => (v == null || v.isEmpty || double.tryParse(v) == null) ? "Required" : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _paymentTokenSymbolController,
                      decoration: const InputDecoration(labelText: "Symbol *", hintText: "e.g., USDC"),
                      validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
                    ),
                  ),
                ],
              ),
              
              const Divider(height: 32),

              Text("Bonus Reward (Optional)", style: theme.textTheme.headlineSmall),
              const SizedBox(height: 16),
               TextFormField(
                controller: _bonusTokenAddressController,
                decoration: const InputDecoration(labelText: "Bonus Token Address"),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _bonusAmountController,
                      decoration: const InputDecoration(labelText: "Bonus Amount"),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _bonusTokenSymbolController,
                      decoration: const InputDecoration(labelText: "Symbol", hintText: "e.g., CAB"),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: _isListing 
                  ? Container(width: 24, height: 24, padding: const EdgeInsets.all(2.0), child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                  : const Icon(Icons.add_shopping_cart_rounded),
                label: Text(_isListing ? 'Listing Product...' : 'List Product'),
                onPressed: _isListing ? null : _listProduct,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker(ThemeData theme) {
    return InkWell(
      onTap: _pickImage,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(12),
          color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        ),
        child: _productImage == null
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo_outlined, size: 48),
                  SizedBox(height: 8),
                  Text("Upload Product Image *"),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Image.file(
                  File(_productImage!.path),
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}
