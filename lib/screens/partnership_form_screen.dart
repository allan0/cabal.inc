// lib/screens/partnership_form_screen.dart
import 'package:flutter/material.dart';
import 'package:cabal/services/supabase_service.dart';
import 'package:cabal/widgets/animated_particle_background.dart';
import 'package:cabal/utils/app_colors.dart';

class PartnershipFormScreen extends StatefulWidget {
  final String partnershipType;

  const PartnershipFormScreen({Key? key, required this.partnershipType}) : super(key: key);

  @override
  State<PartnershipFormScreen> createState() => _PartnershipFormScreenState();
}

class _PartnershipFormScreenState extends State<PartnershipFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _supabaseService = SupabaseService();
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _projectNameController = TextEditingController();
  final _projectUrlController = TextEditingController();
  final _twitterController = TextEditingController();
  final _proposalController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _projectNameController.dispose();
    _projectUrlController.dispose();
    _twitterController.dispose();
    _proposalController.dispose();
    super.dispose();
  }

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      await _supabaseService.submitPartnershipApplication(
        contactName: _nameController.text.trim(),
        contactEmail: _emailController.text.trim(),
        partnershipType: widget.partnershipType,
        proposalDetails: _proposalController.text.trim(),
        projectName: _projectNameController.text.trim(),
        projectUrl: _projectUrlController.text.trim(),
        twitterHandle: _twitterController.text.trim(),
      );

      if (mounted) {
        scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text('Application submitted successfully! We will be in touch.'),
          backgroundColor: AppColors.success,
        ));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bool isProject = widget.partnershipType == 'Project';
    bool isKOL = widget.partnershipType == 'KOL';

    return Scaffold(
      appBar: AppBar(title: Text('${widget.partnershipType} Application')),
      body: AnimatedParticleBackground(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text('Contact Information', style: theme.textTheme.titleLarge),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Your Name / Handle *'),
                validator: (v) => (v == null || v.isEmpty) ? 'This field is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Contact Email *'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => (v == null || !v.contains('@')) ? 'Please enter a valid email' : null,
              ),
              if (isProject || isKOL) const SizedBox(height: 16),
              if (isProject || isKOL)
                TextFormField(
                  controller: _twitterController,
                  decoration: const InputDecoration(labelText: 'X / Twitter Handle'),
                ),
              
              if (isProject) ...[
                 const SizedBox(height: 24),
                 Text('Project Details', style: theme.textTheme.titleLarge),
                 const SizedBox(height: 16),
                 TextFormField(
                  controller: _projectNameController,
                  decoration: const InputDecoration(labelText: 'Project Name *'),
                  validator: (v) => (isProject && (v == null || v.isEmpty)) ? 'Project name is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _projectUrlController,
                  decoration: const InputDecoration(labelText: 'Project Website / URL'),
                ),
              ],

              const SizedBox(height: 24),
              Text('Your Proposal', style: theme.textTheme.titleLarge),
              const SizedBox(height: 16),
              TextFormField(
                controller: _proposalController,
                decoration: InputDecoration(
                  labelText: 'Tell us about your project or how you can help *',
                  alignLabelWithHint: true,
                  hintText: isKOL
                      ? 'Describe your audience, engagement metrics, and ideas for collaboration.'
                      : isProject
                          ? 'Describe your project and how a partnership with Cabal would create value.'
                          : 'Tell us about your background and what you envision for your role.',
                ),
                maxLines: 8,
                validator: (v) => (v == null || v.trim().length < 50) ? 'Please provide a detailed proposal (min 50 characters)' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitApplication,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: _isLoading
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white))
                    : const Text('Submit Application'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
