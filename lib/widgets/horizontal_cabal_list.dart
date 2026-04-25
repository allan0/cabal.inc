// lib/widgets/horizontal_cabal_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/cabal_model.dart';
import 'cabal_card_widget.dart';
import 'shimmer_widget.dart';
import 'package:page_transition/page_transition.dart';
import '../screens/cabal_detail_screen.dart';

class HorizontalCabalList extends StatelessWidget {
  final String title;
  final List<Cabal> cabals;
  final bool isLoading;
  final String? emptyMessage;

  const HorizontalCabalList({
    Key? key,
    required this.title,
    required this.cabals,
    this.isLoading = false,
    this.emptyMessage,
  }) : super(key: key);

  void _navigateToCabalDetail(BuildContext context, Cabal cabal) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        child: CabalDetailScreen(cabalId: cabal.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(title, style: theme.textTheme.titleLarge),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 230, // Fixed height for the horizontal list
          child: isLoading
              ? _buildLoadingState()
              : cabals.isEmpty
                  ? Center(child: Text(emptyMessage ?? "Nothing to see here... yet!", style: theme.textTheme.bodyMedium))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: cabals.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemBuilder: (context, index) {
                        final cabal = cabals[index];
                        return SizedBox(
                          width: MediaQuery.of(context).size.width * 0.75, // Make cards wide
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: CabalCardWidget(
                              project: cabal,
                              onTap: () => _navigateToCabalDetail(context, cabal),
                            ),
                          ),
                        ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.2);
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemBuilder: (context, index) => SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        child: const Padding(
          padding: EdgeInsets.only(right: 12.0),
          child: ShimmerWidget.rectangular(height: 230),
        ),
      ),
    );
  }
}
