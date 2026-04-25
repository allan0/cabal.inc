// lib/screens/edit_cabal_screen.dart
import 'package:cabal/models/cabal_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/supabase_service.dart';
import '../widgets/animated_particle_background.dart';
import '../utils/app_colors.dart';
import 'create_cabal_screen.dart'; // To get the categories map

class EditCabalScreen extends StatefulWidget {
  final Cabal cabal;
  const EditCabalScreen({Key? key, required this.cabal}) : super(key: key);
  @override
  State<EditCabalScreen> createState() => _EditCabalScreenState();
}

class _EditCabalScreenState extends State<EditCabalScreen> {
  final _formKey = GlobalKey<FormState>();
  final SupabaseService _supabaseService = SupabaseService();

  // --- Basic Info Controllers ---
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _projectUrlController;
  late bool _isPrivate;
  String? _selectedCategory;
  
  // --- WEB3 UPDATE: Web3 Info Controllers ---
  late TextEditingController _tokenAddressController;
  late TextEditingController _tokenSymbolController;
  late int _chainId;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize basic info
    _nameController = TextEditingController(text: widget.cabal.name);
    _descriptionController = TextEditingController(text: widget.cabal.description);
    _projectUrlController = TextEditingController(text: widget.cabal.projectUrl ?? '');
    _isPrivate = widget.cabal.isPrivate;
    _selectedCategory = widget.cabal.category;
    
    // --- WEB3 UPDATE: Initialize Web3 info ---
    _tokenAddressController = TextEditingController(text: widget.cabal.tokenContractAddress ?? '');
    _tokenSymbolController = TextEditingController(text: widget.cabal.tokenSymbol ?? '');
    _chainId = widget.cabal.chainId ?? 11155111; // Default to Sepolia
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _projectUrlController.dispose();
    _tokenAddressController.dispose();
    _tokenSymbolController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    if (!_formKey.currentState!.validate() || _selectedCategory == null) {
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Please correct the errors and select a category.'), backgroundColor: AppColors.warning));
      return;
    }
    _formKey.currentState!.save();
    
    if (mounted) setState(() => _isLoading = true);

    try {
      // Create a new Cabal object with all the updated fields
      final updatedCabal = Cabal(
        id: widget.cabal.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        projectUrl: _projectUrlController.text.trim().isEmpty ? null : _projectUrlController.text.trim(),
        isPrivate: _isPrivate,
        category: _selectedCategory,
        // --- WEB3 UPDATE: Add updated Web3 fields ---
        tokenContractAddress: _tokenAddressController.text.trim().isEmpty ? null : _tokenAddressController.text.trim(),
        tokenSymbol: _tokenSymbolController.text.trim().isEmpty ? null : _tokenSymbolController.text.trim(),
        chainId: _chainId,
        // Carry over existing values that are not editable on this screen
        creatorId: widget.cabal.creatorId,
        creatorHandle: widget.cabal.creatorHandle,
        logoUrl: widget.cabal.logoUrl,
        bannerImageUrl: widget.cabal.bannerImageUrl,
        createdAt: widget.cabal.createdAt,
      );

      await _supabaseService.updateCabal(updatedCabal);

      if (mounted) {
        scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Cabal updated successfully!'), backgroundColor: AppColors.success));
        Navigator.pop(context, true); // Pop with true to indicate a refresh is needed
      }
    } catch (e) {
      if (mounted) scaffoldMessenger.showSnackBar(SnackBar(content: Text('Failed to update cabal: ${e.toString().split(':').last.trim()}'), backgroundColor: Theme.of(context).colorScheme.error));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Edit "${widget.cabal.name}"', overflow: TextOverflow.ellipsis),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.solidFloppyDisk),
            onPressed: _isLoading ? null : _saveChanges,
            tooltip: "Save Changes",
          )
        ],
      ),
      body: AnimatedParticleBackground(
        child: AbsorbPointer(
          absorbing: _isLoading,
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.only(top: kToolbarHeight + MediaQuery.of(context).padding.top + 16, left: 16, right: 16, bottom: 40),
                  children: [
                    Text("Cabal Details", style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary)),
                    const SizedBox(height: 16),
                    TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Cabal Name *'), validator: (v) => (v == null || v.trim().length < 3) ? 'Name must be at least 3 characters.' : null),
                    const SizedBox(height: 16),
                    TextFormField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Cabal Description *'), maxLines: 4, maxLength: 500, validator: (v) => (v == null || v.trim().length < 10) ? 'Description must be at least 10 characters.' : null),
                    const SizedBox(height: 16),
                    TextFormField(controller: _projectUrlController, decoration: const InputDecoration(labelText: 'Project Website URL (Optional)'), keyboardType: TextInputType.url, validator: (v) { if (v == null || v.trim().isEmpty) return null; if (!(Uri.tryParse(v.trim())?.isAbsolute ?? false)) return 'Please enter a valid URL'; return null; }),
                    const SizedBox(height: 24),
                    _buildCategorySelector(theme),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 0,
                      color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                      child: SwitchListTile(
                        title: Text("Private Cabal", style: theme.textTheme.titleMedium),
                        subtitle: Text(_isPrivate ? "Visible only to members." : "Visible to everyone."),
                        value: _isPrivate,
                        onChanged: (bool value) => setState(() => _isPrivate = value),
                        secondary: FaIcon(_isPrivate ? FontAwesomeIcons.lock : FontAwesomeIcons.globe),
                      ),
                    ),
                    const Divider(height: 40),
                    // --- WEB3 UPDATE: Web3 settings section ---
                    Text("Web3 Integration", style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _tokenAddressController,
                      decoration: const InputDecoration(labelText: 'Token Contract Address (Optional)'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _tokenSymbolController,
                      decoration: const InputDecoration(labelText: 'Token Symbol (e.g., MYTKN)'),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _chainId,
                      decoration: const InputDecoration(labelText: 'Blockchain (Chain ID)'),
                      items: const [
                        DropdownMenuItem(value: 1, child: Text("Ethereum Mainnet")),
                        DropdownMenuItem(value: 11155111, child: Text("Sepolia Testnet")),
                        DropdownMenuItem(value: 8453, child: Text("Base Mainnet")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _chainId = value!;
                        });
                      },
                    ),
                  ].animate(interval: 100.ms).fadeIn().slideY(begin: 0.1),
                ),
              ),
              if (_isLoading)
                Container(
                  color: theme.scaffoldBackgroundColor.withOpacity(0.7),
                  child: Center(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 16),
                            Text("Saving...", style: theme.textTheme.titleMedium),
                          ],
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn(),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildCategorySelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Cabal Category *", style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: cabalCategories.entries.map((entry) {
            final isSelected = _selectedCategory == entry.key;
            return ChoiceChip(
              label: Text(entry.key),
              avatar: FaIcon(entry.value, size: 16, color: isSelected ? theme.colorScheme.onSecondary : theme.colorScheme.secondary),
              selected: isSelected,
              onSelected: (selected) => setState(() => _selectedCategory = selected ? entry.key : null),
              selectedColor: theme.colorScheme.secondary,
              labelStyle: theme.chipTheme.labelStyle?.copyWith(color: isSelected ? theme.colorScheme.onSecondary : theme.chipTheme.labelStyle?.color),
            );
          }).toList(),
        ),
      ],
    );
  }
}
