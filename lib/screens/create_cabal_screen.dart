// lib/screens/create_cabal_screen.dart
import 'dart:typed_data';
import 'package:cabal/features/wallet/application/wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:provider/provider.dart';

import '../services/supabase_service.dart';
import '../models/user_profile_model.dart';
import '../utils/app_colors.dart';
import '../widgets/info_tooltip.dart';
import '../widgets/animated_particle_background.dart';
import 'cabal_detail_screen.dart';

final Map<String, IconData> cabalCategories = { 'Gaming': FontAwesomeIcons.gamepad, 'Leisure': FontAwesomeIcons.martiniGlass, 'DeFi & Trading': FontAwesomeIcons.chartLine, 'Real Estate': FontAwesomeIcons.building, 'E-commerce': FontAwesomeIcons.cartShopping, 'Education': FontAwesomeIcons.book, };

enum Web3IntegrationOption { none, import, create }

class CreateCabalScreen extends StatefulWidget {
  final String? initialCategory;

  const CreateCabalScreen({Key? key, this.initialCategory}) : super(key: key);
  @override
  State<CreateCabalScreen> createState() => _CreateCabalScreenState();
}

class _CreateCabalScreenState extends State<CreateCabalScreen> {
  final _formKey = GlobalKey<FormState>();
  final SupabaseService _supabaseService = SupabaseService();
  final ImagePicker _picker = ImagePicker();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Page 1: Basic Info
  String _name = '';
  String _description = '';
  String? _projectUrl;
  bool _isPrivate = false;
  String? _selectedCategory;

  // Page 2: Branding
  XFile? _logoImageXFile;
  XFile? _bannerImageXFile;
  
  // Page 3: Web3 Integration
  Web3IntegrationOption _web3IntegrationOption = Web3IntegrationOption.none;
  final _tokenContractAddressController = TextEditingController();
  final _tokenSymbolController = TextEditingController();
  final _newTokenNameController = TextEditingController();
  final _newTokenSymbolController = TextEditingController();
  final _newTokenSupplyController = TextEditingController();
  int _chainId = 11155111; // Default to Sepolia testnet

  bool _isLoading = false;
  String _loadingMessage = 'Launching Your Cabal...';
  UserProfile? _currentUserProfile;
  
  final List<String> _pageTitles = [ "1. Basic Info", "2. Branding", "3. Web3 Integration", "4. Review & Launch!" ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _pageController.addListener(() {
      final newPage = _pageController.page?.round() ?? 0;
      if (newPage != _currentPage && mounted) setState(() => _currentPage = newPage);
    });
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final currentUserAuth = _supabaseService.getCurrentUser();
    if (currentUserAuth != null) {
      final profile = await _supabaseService.getUserProfile(currentUserAuth.id);
      if (mounted) setState(() => _currentUserProfile = profile);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You must be logged in to create a cabal."), backgroundColor: Colors.red));
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tokenContractAddressController.dispose();
    _tokenSymbolController.dispose();
    _newTokenNameController.dispose();
    _newTokenSymbolController.dispose();
    _newTokenSupplyController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source, Function(XFile?) onImagePicked) async {
    try {
      final XFile? pickedXFile = await _picker.pickImage(source: source, imageQuality: 70, maxWidth: 1200, maxHeight: 1200);
      if (mounted) setState(() => onImagePicked(pickedXFile));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error picking image: ${e.toString()}'), backgroundColor: Theme.of(context).colorScheme.error));
    }
  }

  void _nextPage() {
    bool canProceed = true;
    if (_currentPage == 0) {
      if (_formKey.currentState?.validate() == false) {
        canProceed = false;
      } else {
        _formKey.currentState?.save();
        if (_selectedCategory == null) {
          canProceed = false;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a category for your cabal.'), backgroundColor: Colors.orangeAccent));
        }
      }
    }
    
    if (canProceed && _currentPage < _pageTitles.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOutQuad);
    } else if (!canProceed) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete the current step correctly.'), backgroundColor: Colors.orangeAccent));
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOutQuad);
    }
  }

  Future<void> _submitForm() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final walletProvider = context.read<WalletProvider>();
    final currentUserAuth = _supabaseService.getCurrentUser();

    if (_currentUserProfile == null || currentUserAuth == null) {
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Authentication error. Please log in again.'), backgroundColor: Colors.red));
      return;
    }
    if (_formKey.currentState?.validate() == false || _selectedCategory == null) {
      _pageController.animateToPage(0, duration: 300.ms, curve: Curves.easeOut);
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Please complete the Basic Info step correctly.'), backgroundColor: Colors.red));
      return;
    }
    _formKey.currentState?.save();
    
    if (mounted) setState(() => _isLoading = true);

    String? finalTokenAddress;
    String? finalTokenSymbol;

    try {
      if (_web3IntegrationOption == Web3IntegrationOption.create) {
        if (!walletProvider.isConnectedEVM) {
          throw Exception("Please connect your EVM wallet to deploy a new token.");
        }
        if (mounted) setState(() => _loadingMessage = 'Deploying your new token...');
        final deployedAddress = await walletProvider.deployERC20Token(
          name: _newTokenNameController.text.trim(),
          symbol: _newTokenSymbolController.text.trim(),
          initialSupply: BigInt.parse(_newTokenSupplyController.text.trim()) * BigInt.from(10).pow(18),
        );
        if (deployedAddress == null) throw Exception("Token deployment failed.");
        finalTokenAddress = deployedAddress;
        finalTokenSymbol = _newTokenSymbolController.text.trim();
      } else if (_web3IntegrationOption == Web3IntegrationOption.import) {
        finalTokenAddress = _tokenContractAddressController.text.trim();
        finalTokenSymbol = _tokenSymbolController.text.trim();
      }
      
      if (mounted) setState(() => _loadingMessage = 'Uploading assets...');
      String? uploadedLogoUrl = _logoImageXFile != null ? await _supabaseService.uploadProfileImage(_logoImageXFile!, currentUserAuth.id) : null;
      String? uploadedBannerUrl = _bannerImageXFile != null ? await _supabaseService.uploadProfileImage(_bannerImageXFile!, currentUserAuth.id) : null;

      if (mounted) setState(() => _loadingMessage = 'Finalizing creation...');
      final creatorHandle = _currentUserProfile!.displayName ?? _currentUserProfile!.telegramUsername ?? currentUserAuth.id.substring(0, 8);
      
      final newCabal = await _supabaseService.createCabal(
        name: _name, description: _description, creatorHandle: creatorHandle,
        isPrivate: _isPrivate, category: _selectedCategory, projectUrl: _projectUrl,
        logoUrl: uploadedLogoUrl, bannerImageUrl: uploadedBannerUrl,
        tokenContractAddress: finalTokenAddress, tokenSymbol: finalTokenSymbol, chainId: _chainId,
      );

      if (newCabal != null) {
        scaffoldMessenger.showSnackBar(SnackBar(content: Text('Cabal "${newCabal.name}" created!'), backgroundColor: AppColors.success));
        navigator.pop(true);
        navigator.pushReplacement(PageTransition(type: PageTransitionType.rightToLeftWithFade, child: CabalDetailScreen(cabalId: newCabal.id)));
      } else {
        throw Exception("Failed to create cabal record.");
      }
    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(SnackBar(content: Text('Failed to create cabal: ${e.toString()}'), backgroundColor: Theme.of(context).colorScheme.error));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_currentPage]),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(12.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: _buildStepIndicator(theme),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: AnimatedParticleBackground(
        child: AbsorbPointer(
          absorbing: _isLoading,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: kToolbarHeight + (AppBar().preferredSize.height * 0.5)),
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildBasicInfoStep(theme),
                    _buildBrandingStep(theme),
                    _buildWeb3Step(theme),
                    _buildReviewStep(theme),
                  ],
                ),
              ),
              if (_isLoading)
                Container(
                  color: theme.scaffoldBackgroundColor.withOpacity(0.7),
                  child: Center(
                    child: Card(
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(color: theme.colorScheme.primary),
                            const SizedBox(height: 20),
                            Text(_loadingMessage, style: theme.textTheme.titleMedium),
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
      bottomNavigationBar: Material(
        elevation: 8.0,
        color: theme.cardColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0).copyWith(bottom: MediaQuery.of(context).padding.bottom + 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentPage > 0)
                TextButton.icon(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
                  label: const Text('Back'),
                  onPressed: _isLoading ? null : _previousPage,
                ).animate().fadeIn().slideX(begin: -0.2)
              else
                const SizedBox(width: 80),
              ElevatedButton.icon(
                label: Text(_currentPage == _pageTitles.length - 1 ? 'Launch Cabal!' : 'Next Step'),
                icon: Icon(_currentPage == _pageTitles.length - 1 ? Icons.rocket_launch_rounded : Icons.arrow_forward_ios_rounded, size: 16),
                onPressed: _isLoading ? null : (_currentPage == _pageTitles.length - 1 ? _submitForm : _nextPage),
              ).animate().fadeIn().slideX(begin: 0.2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pageTitles.length, (index) {
        bool isActive = _currentPage == index;
        return AnimatedContainer(
          duration: 300.ms,
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: isActive ? 24 : 10,
          height: 10,
          decoration: BoxDecoration(
            color: isActive ? theme.colorScheme.primary : theme.colorScheme.outline.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }

  Widget _buildBasicInfoStep(ThemeData theme) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text("Project Vitals", style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary)),
          const SizedBox(height: 8),
          Text("Lay the foundation. What's your cabal called and what's it all about?", style: theme.textTheme.bodyLarge),
          const SizedBox(height: 24),
          TextFormField(initialValue: _name, decoration: const InputDecoration(labelText: 'Cabal Name *'), validator: (v) => (v == null || v.trim().length < 3) ? 'Name must be at least 3 characters.' : null, onSaved: (v) => _name = v?.trim() ?? '', autovalidateMode: AutovalidateMode.onUserInteraction).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),
          const SizedBox(height: 20),
          TextFormField(initialValue: _description, decoration: const InputDecoration(labelText: 'Cabal Description *'), maxLines: 4, maxLength: 500, validator: (v) => (v == null || v.trim().length < 10) ? 'Description must be at least 10 characters.' : null, onSaved: (v) => _description = v?.trim() ?? '', autovalidateMode: AutovalidateMode.onUserInteraction).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1),
          const SizedBox(height: 20),
          TextFormField(initialValue: _projectUrl, decoration: const InputDecoration(labelText: 'Project Website URL (Optional)'), keyboardType: TextInputType.url, validator: (v) { if (v == null || v.trim().isEmpty) return null; if (!(Uri.tryParse(v.trim())?.isAbsolute ?? false)) return 'Please enter a valid URL'; return null; }, onSaved: (v) => _projectUrl = (v?.trim().isEmpty ?? true) ? null : v!.trim(), autovalidateMode: AutovalidateMode.onUserInteraction).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1),
          const SizedBox(height: 24),
          _buildCategorySelector(theme),
          const SizedBox(height: 24),
          Card(
            elevation: 0,
            color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SwitchListTile(
              title: Text("Private Cabal", style: theme.textTheme.titleMedium),
              subtitle: Text(_isPrivate ? "Visible only to members." : "Visible to everyone."),
              value: _isPrivate,
              onChanged: (bool value) => setState(() => _isPrivate = value),
              secondary: FaIcon(_isPrivate ? FontAwesomeIcons.lock : FontAwesomeIcons.globe, color: theme.colorScheme.secondary),
              activeColor: theme.colorScheme.primary,
            ),
          ).animate().fadeIn(delay: 600.ms),
        ],
      ),
    );
  }
  
  Widget _buildBrandingStep(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text("Visual Identity", style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary)),
        const SizedBox(height: 8),
        Text("Upload a logo and a banner to make your cabal shine.", style: theme.textTheme.bodyLarge),
        const SizedBox(height: 24),
        _buildImagePickerWidget(label: "Cabal Logo", imageXFile: _logoImageXFile, onPick: () => _pickImage(ImageSource.gallery, (file) => setState(() => _logoImageXFile = file)), onRemove: () => setState(() => _logoImageXFile = null), theme: theme).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 24),
        _buildImagePickerWidget(label: "Cabal Banner", imageXFile: _bannerImageXFile, onPick: () => _pickImage(ImageSource.gallery, (file) => setState(() => _bannerImageXFile = file)), onRemove: () => setState(() => _bannerImageXFile = null), theme: theme).animate().fadeIn(delay: 300.ms),
      ],
    );
  }

  Widget _buildWeb3Step(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text("Tokenize Your Cabal", style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary)),
        const SizedBox(height: 8),
        Text("Integrate an ERC20 token to enable unique quests, governance, and a community treasury.", style: theme.textTheme.bodyLarge),
        const SizedBox(height: 24),
        SegmentedButton<Web3IntegrationOption>(
          segments: const [
            ButtonSegment(value: Web3IntegrationOption.none, label: Text('None'), icon: Icon(Icons.public_off)),
            ButtonSegment(value: Web3IntegrationOption.import, label: Text('Import'), icon: Icon(Icons.input_rounded)),
            ButtonSegment(value: Web3IntegrationOption.create, label: Text('Create'), icon: Icon(Icons.add_circle_outline_rounded)),
          ],
          selected: {_web3IntegrationOption},
          onSelectionChanged: (Set<Web3IntegrationOption> newSelection) {
            setState(() => _web3IntegrationOption = newSelection.first);
          },
        ),
        const SizedBox(height: 24),
        AnimatedSize(
          duration: 300.ms,
          curve: Curves.easeInOut,
          child: _web3IntegrationOption == Web3IntegrationOption.import ? _buildImportTokenForm(theme) :
                 _web3IntegrationOption == Web3IntegrationOption.create ? _buildCreateTokenForm(theme) :
                 const SizedBox.shrink(),
        ),
      ],
    );
  }
  
  Widget _buildImportTokenForm(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Import an Existing Token", style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        TextFormField(controller: _tokenContractAddressController, decoration: const InputDecoration(labelText: 'Token Contract Address')),
        const SizedBox(height: 16),
        TextFormField(controller: _tokenSymbolController, decoration: const InputDecoration(labelText: 'Token Symbol (e.g., MYTKN)')),
      ],
    ).animate().fadeIn();
  }

  Widget _buildCreateTokenForm(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Launch a New Token with Cabal", style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Text("This will deploy a standard ERC20 contract. You will be the owner and can mint more tokens later.", style: theme.textTheme.bodySmall),
        const SizedBox(height: 16),
        TextFormField(controller: _newTokenNameController, decoration: const InputDecoration(labelText: 'Token Name *', hintText: 'e.g., My Cabal Token')),
        const SizedBox(height: 16),
        TextFormField(controller: _newTokenSymbolController, decoration: const InputDecoration(labelText: 'Token Symbol *', hintText: 'e.g., MCT')),
        const SizedBox(height: 16),
        TextFormField(controller: _newTokenSupplyController, decoration: const InputDecoration(labelText: 'Initial Supply *', hintText: 'e.g., 1000000'), keyboardType: TextInputType.number),
      ],
    ).animate().fadeIn();
  }
  
  Widget _buildReviewStep(ThemeData theme) {
    _formKey.currentState?.save();
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text("Final Checkpoint!", style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary)),
        const SizedBox(height: 8),
        Text("One last look before your cabal goes live.", style: theme.textTheme.bodyLarge),
        const SizedBox(height: 24),
        Card(
          elevation: 0.5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildReviewItem(theme, "Name:", _name),
                _buildReviewItem(theme, "Description:", _description, maxLines: 3),
                _buildReviewItem(theme, "Category:", _selectedCategory ?? "(Not set)"),
                _buildReviewItem(theme, "Privacy:", _isPrivate ? "Private" : "Public"),
                if(_web3IntegrationOption != Web3IntegrationOption.none) ...[
                  const Divider(height: 20),
                  if(_web3IntegrationOption == Web3IntegrationOption.import) ...[
                    _buildReviewItem(theme, "Token Address:", _tokenContractAddressController.text),
                    _buildReviewItem(theme, "Token Symbol:", _tokenSymbolController.text),
                  ],
                  if(_web3IntegrationOption == Web3IntegrationOption.create) ...[
                     _buildReviewItem(theme, "New Token Name:", _newTokenNameController.text),
                     _buildReviewItem(theme, "New Token Symbol:", _newTokenSymbolController.text),
                     _buildReviewItem(theme, "Initial Supply:", _newTokenSupplyController.text),
                  ]
                ]
              ],
            ),
          ),
        ).animate().fadeIn(delay: 200.ms),
      ],
    );
  }

  // --- HELPER WIDGETS ---
  Widget _buildReviewItem(ThemeData theme, String label, String value, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          Expanded(child: SelectableText(value, style: theme.textTheme.bodyMedium, maxLines: maxLines)),
        ],
      ),
    );
  }

  Widget _buildImagePickerWidget({ required String label, required XFile? imageXFile, required Function() onPick, required Function() onRemove, required ThemeData theme, }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
            border: Border.all(color: theme.colorScheme.outline.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: imageXFile != null
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: kIsWeb
                          ? Image.network(imageXFile.path, fit: BoxFit.contain)
                          : FutureBuilder<Uint8List>(
                              future: imageXFile.readAsBytes(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) return Image.memory(snapshot.data!, fit: BoxFit.contain);
                                return const Center(child: CircularProgressIndicator());
                              },
                            ),
                    ),
                    Positioned(
                      top: 4, right: 4,
                      child: Material(
                        color: Colors.black.withOpacity(0.5), shape: const CircleBorder(),
                        child: IconButton(
                          icon: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                          onPressed: onRemove, tooltip: "Remove Image",
                        ),
                      ),
                    )
                  ],
                ).animate().fadeIn()
              : Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.upload_file_rounded, size: 18),
                    label: const Text("Choose Image"),
                    onPressed: onPick,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Cabal Category *", style: theme.textTheme.titleMedium),
            const InfoTooltip(message: "Select the category that best fits your project's focus."),
          ],
        ),
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
        ).animate().fadeIn(delay: 500.ms),
      ],
    );
  }
}
