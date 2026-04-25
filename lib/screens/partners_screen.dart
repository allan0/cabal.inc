// lib/screens/partners_screen.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cabal/widgets/diamond_mesh_background.dart';
import 'package:cabal/utils/app_colors.dart';
import 'package:page_transition/page_transition.dart';
import 'partnership_form_screen.dart'; // This file will be created next

class PartnersScreen extends StatelessWidget {
  const PartnersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Partner with Cabal"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: DiamondMeshBackground(
        child: ListView(
          padding: EdgeInsets.only(
            top: kToolbarHeight + MediaQuery.of(context).padding.top + 20,
            left: 16, right: 16, bottom: 40,
          ),
          children: [
            _buildSectionHeader(theme, "Grow With Us", "Join an ecosystem designed for mutual success."),
            const SizedBox(height: 24),
            _buildPartnerTypeCard(
              context: context,
              theme: theme,
              icon: FontAwesomeIcons.rocket,
              title: "Project & dApp Partnerships",
              description: "Integrate your project with Cabal to run quests, engage our user base, and grow your community.",
              buttonText: "Apply as a Project",
              onPressed: () {
                Navigator.push(context, PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const PartnershipFormScreen(partnershipType: 'Project'))
                );
              },
            ),
            _buildPartnerTypeCard(
              context: context,
              theme: theme,
              icon: FontAwesomeIcons.bullhorn,
              title: "Influencers & KOLs",
              description: "Bring your audience to Cabal and earn rewards based on the real, active users you onboard. We provide the tools to track your impact.",
              buttonText: "Apply as a KOL",
              onPressed: () {
                 Navigator.push(context, PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const PartnershipFormScreen(partnershipType: 'KOL'))
                );
              },
            ),
             _buildPartnerTypeCard(
              context: context,
              theme: theme,
              icon: FontAwesomeIcons.peopleGroup,
              title: "Strategic & Core Roles",
              description: "Looking to make a bigger impact? We are actively seeking partners for core roles in business development, technology, and leadership.",
              buttonText: "Contact Us Directly",
              onPressed: () {
                Navigator.push(context, PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const PartnershipFormScreen(partnershipType: 'Strategic'))
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.headlineMedium?.copyWith(color: AppColors.gold)),
        const SizedBox(height: 8),
        Text(subtitle, style: theme.textTheme.bodyLarge),
      ],
    );
  }

  Widget _buildPartnerTypeCard({
    required BuildContext context,
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FaIcon(icon, size: 24, color: theme.colorScheme.primary),
                const SizedBox(width: 16),
                Expanded(child: Text(title, style: theme.textTheme.titleLarge)),
              ],
            ),
            const Divider(height: 24),
            Text(description, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: onPressed,
                child: Text(buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
