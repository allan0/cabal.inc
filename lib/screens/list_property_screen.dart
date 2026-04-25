// lib/screens/list_property_screen.dart
import 'dart:io';
import 'package:cabal/services/nft_service.dart';
import 'package:cabal/services/web3_service.dart';
import 'package:cabal/widgets/animated_particle_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../features/wallet/application/wallet_provider.dart';
import '../utils/app_colors.dart';

class ListPropertyScreen extends StatefulWidget {
  const ListPropertyScreen({Key? key}) : super(key: key);

  @override
  State<ListPropertyScreen> createState() => _ListPropertyScreenState();
}

class _ListPropertyScreenState extends State<ListPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  
  // Form Controllers
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _sqftController = TextEditingController();
  final _bedsController = TextEditingController();
  final _bathsController = TextEditingController();
  final _escrowController = TextEditingController(); // <-- NEW

  XFile? _propertyImage;
  bool _isMinting = false;

  Future<void> _pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80, maxWidth: 1200);
    if (pickedImage != null) {
      setState(() {
        _propertyImage = pickedImage;
      });
    }
  }

  Future<void> _mintDeed() async {
    if (!_formKey.currentState!.validate()) return;
    if (_propertyImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please upload a property image.")));
      return;
    }
    _formKey.currentState!.save();

    final walletProvider = context.read<WalletProvider>();
    final web3Service = context.read<Web3Service>();
    final nftService = NftService();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    if (!walletProvider.isConnectedEVM) {
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Please connect your wallet to mint a deed.")));
      return;
    }
    
    setState(() => _isMinting = true);

    try {
      // Step 1: Upload metadata to IPFS
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Uploading property data to IPFS...")));
      
      final attributes = {
        "Square Footage": _sqftController.text.trim(),
        "Bedrooms": _bedsController.text.trim(),
        "Bathrooms": _bathsController.text.trim(),
        "Required Escrow": "${_escrowController.text.trim()} ETH", // <-- NEW
      };
      
      final tokenURI = await nftService.uploadToIpfs(
        imageFile: _propertyImage!, 
        name: _addressController.text.trim(), 
        description: _descriptionController.text.trim(), 
        attributes: attributes
      );

      // Step 2: Mint the NFT on-chain
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Minting NFT... Please confirm in your wallet.")));
      
      final propertyId = "${_addressController.text.trim()}-${DateTime.now().millisecondsSinceEpoch}";
      
      final tx = web3Service.buildMintDeedTransaction(
        ownerAddress: walletProvider.connectedEVMAddress!,
        tokenURI: tokenURI,
        propertyId: propertyId,
      );

      final txHash = await walletProvider.sendTransaction(tx);
      
      // Step 3: Store property details in Supabase (including escrow amount)
      // TODO: Implement a `createProperty` method in SupabaseService
      // await supabaseService.createProperty(details: {...});

      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text("Deed minted successfully! Tx: $txHash"),
        backgroundColor: AppColors.success,
      ));
      navigator.pop(true);

    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Minting failed: $e"), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() => _isMinting = false);
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _descriptionController.dispose();
    _sqftController.dispose();
    _bedsController.dispose();
    _bathsController.dispose();
    _escrowController.dispose(); // <-- NEW
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("List a New Property")),
      body: AnimatedParticleBackground(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text("Property Details", style: theme.textTheme.headlineSmall),
              const SizedBox(height: 16),
              _buildImagePicker(theme),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Property Address *"),
                validator: (v) => (v == null || v.isEmpty) ? "Address is required" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description *", alignLabelWithHint: true),
                maxLines: 4,
                validator: (v) => (v == null || v.isEmpty) ? "Description is required" : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _sqftController,
                      decoration: const InputDecoration(labelText: "Sq. Footage *"),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _bedsController,
                      decoration: const InputDecoration(labelText: "Beds *"),
                      keyboardType: TextInputType.number,
                       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                       validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _bathsController,
                      decoration: const InputDecoration(labelText: "Baths *"),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
                      validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // --- NEW ESCROW FIELD ---
              Text("Transaction Terms", style: theme.textTheme.headlineSmall),
              const SizedBox(height: 16),
              TextFormField(
                controller: _escrowController,
                decoration: const InputDecoration(
                  labelText: "Required Escrow Deposit (in ETH) *",
                  hintText: "e.g., 1.5",
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: FaIcon(FontAwesomeIcons.ethereum),
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
                validator: (v) {
                  if (v == null || v.isEmpty) return "Escrow amount is required";
                  final val = double.tryParse(v);
                  if (val == null || val <= 0) return "Must be a positive number";
                  return null;
                },
              ),
              // --- END NEW FIELD ---
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: _isMinting 
                  ? Container(width: 24, height: 24, padding: const EdgeInsets.all(2.0), child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                  : const FaIcon(FontAwesomeIcons.fileSignature),
                label: Text(_isMinting ? 'Minting Deed...' : 'Mint Property Deed NFT'),
                onPressed: _isMinting ? null : _mintDeed,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              )
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
        child: _propertyImage == null
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo_outlined, size: 48),
                  SizedBox(height: 8),
                  Text("Upload Property Image"),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Image.file(
                  File(_propertyImage!.path),
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}
