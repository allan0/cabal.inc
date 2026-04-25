// lib/widgets/quest_section_widget.dart
import 'package:flutter/material.dart';

// Model Imports
import '../models/quest_section_model.dart';
import '../models/quest_model.dart';
import '../models/user_profile_model.dart'; // For UserProfile type

// Widget Imports
import '../widgets/quest_card_widget.dart'; // The QuestCardWidget should be up-to-date

// Typedef for callback
typedef QuestActionCallback = Future<void> Function(Quest quest);

class QuestSectionWidget extends StatefulWidget {
  final String cabalId;
  final QuestSection section;
  final UserProfile? viewingUserProfile;     // User whose progress is shown for this section
  final UserProfile? currentUserProfile;   // Currently authenticated user (the actor for actions)
  final List<Quest> quests; // Quests in this section; their status fields should be pre-updated
                            // by the parent screen based on viewingUserProfile's progress data.

  // Progress data for viewingUserProfile (passed down but primarily used by parent to update quest objects)
  final Set<String> completedQuestIdsForProject;
  final Map<String, DateTime?> userQuestCompletionTimestamps;
  final Map<String, int> userQuestStepsMap;
  final Map<String, String> userQuestStatusMap; // This is the source for quest.userQuestSpecificStatus

  final QuestActionCallback onClaimReward; // Action performed by currentUserProfile
  final String? loadingClaimQuestId; // ID of quest currently being processed

  // Theme-related properties passed from parent
  final Color cardColor;
  final Color textColor;
  final Color accentColor;

  const QuestSectionWidget({
    Key? key,
    required this.cabalId,
    required this.section,
    this.viewingUserProfile,
    this.currentUserProfile,
    required this.quests,
    required this.completedQuestIdsForProject,
    required this.userQuestCompletionTimestamps,
    required this.userQuestStepsMap,
    required this.userQuestStatusMap, // This map contains the actual statuses like 'pending_verification'
    required this.onClaimReward,
    this.loadingClaimQuestId,
    required this.cardColor,
    required this.textColor,
    required this.accentColor,
  }) : super(key: key);

  @override
  State<QuestSectionWidget> createState() => _QuestSectionWidgetState();
}

class _QuestSectionWidgetState extends State<QuestSectionWidget> {
  bool _isExpanded = true; // Default to expanded, or could use PageStorage

  @override
  void initState() {
    super.initState();
    // Optional: If you want to persist expansion state across rebuilds when in a list:
    // final pageStorageBucket = PageStorage.of(context);
    // _isExpanded = pageStorageBucket.readState(context, identifier: PageStorageKey('quest_section_${widget.section.id}_${widget.viewingUserProfile?.id ?? 'guest'}')) as bool? ?? true;
    // Adding viewingUserProfile?.id to the key makes the persisted state user-specific if needed.
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Use colors passed from parent
    final effectiveCardColor = widget.cardColor;
    final effectiveTextColor = widget.textColor;
    final effectiveAccentColor = widget.accentColor;
    final effectiveIconColor = widget.textColor.withOpacity(0.7); // For ExpansionTile icon

    // Calculate completed quests IN THIS SECTION for the VIEWING USER
    // The `quest.isCompletedByUser` and `quest.userQuestSpecificStatus` fields on each `quest` object
    // in `widget.quests` should have already been set by the parent (`CabalDetailScreen`)
    // based on the `widget.viewingUserProfile`'s progress data (via _updateQuestObjectsWithViewingUserProgress).
    int completedInSection = 0;
    for (var quest in widget.quests) {
        // A quest is counted as completed for the section header if its specific status for the viewing user is 'completed'
        // AND it's not currently on an active cooldown for that user.
        if (quest.userQuestSpecificStatus == 'completed' && !quest.isOnCooldownForUser) {
            completedInSection++;
        }
    }

    String progressText = "";
    if (widget.viewingUserProfile != null) { // Only show detailed progress if viewing a specific user's progress
        if (widget.section.progressTextFormat != null && widget.section.progressTextFormat!.isNotEmpty) {
            progressText = widget.section.progressTextFormat!
                .replaceAll('{completed}', completedInSection.toString())
                .replaceAll('{total}', widget.quests.length.toString());
        } else if (widget.quests.isNotEmpty) {
            progressText = '$completedInSection / ${widget.quests.length} Done';
        } else {
            progressText = "0 / 0 Done"; // Or "No Quests" if preferred
        }
    } else { // Guest view or general cabal view (not tied to a specific user's progress)
        if (widget.quests.isNotEmpty) {
            progressText = "${widget.quests.length} Quests"; // Simpler for guest
        } else {
            progressText = "No Quests Available";
        }
    }

    return Card(
      color: effectiveCardColor,
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 0),
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme( // Scope Theme to make ExpansionTile divider transparent
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: PageStorageKey<String>("expansion_tile_section_${widget.section.id}_${widget.viewingUserProfile?.id ?? 'guest'}"), // User-specific key
          initiallyExpanded: _isExpanded,
          onExpansionChanged: (expanded) {
            if (mounted) {
              setState(() {
                _isExpanded = expanded;
                // If using PageStorage:
                // PageStorage.of(context).writeState(context, expanded, identifier: PageStorageKey('quest_section_${widget.section.id}_${widget.viewingUserProfile?.id ?? 'guest'}'));
              });
            }
          },
          iconColor: effectiveIconColor,
          collapsedIconColor: effectiveIconColor,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  widget.section.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: effectiveTextColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (progressText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    progressText,
                    style: TextStyle(fontSize: 13, color: effectiveTextColor.withOpacity(0.8), fontWeight: FontWeight.w500),
                  ),
                ),
            ],
          ),
          subtitle: (widget.section.description != null && widget.section.description!.isNotEmpty)
              ? Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(
                      widget.section.description!,
                      style: TextStyle(fontSize: 14, color: effectiveTextColor.withOpacity(0.75), height: 1.35),
                      maxLines: _isExpanded ? 3 : 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                )
              : null,
          childrenPadding: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0, top: 4.0),
          children: widget.quests.isEmpty
              ? [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                    child: Center(
                      child: Text(
                        "No quests in this section match your current filters.", // Or "No quests in this section yet." if no filters applied
                        textAlign: TextAlign.center,
                        style: TextStyle(color: effectiveTextColor.withOpacity(0.65), fontStyle: FontStyle.italic, fontSize: 14),
                      ),
                    ),
                  )
                ]
              : widget.quests.map((quest) {
                  // The 'quest' object passed to QuestCardWidget should have its status fields
                  // (isCompletedByUser, isLockedForUser, userQuestSpecificStatus, etc.)
                  // already correctly populated by the parent screen (CabalDetailScreen)
                  // based on widget.viewingUserProfile's data.
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: QuestCardWidget(
                      quest: quest,
                      onClaimReward: () => widget.onClaimReward(quest), // Action is by currentUserProfile
                      isLoadingClaim: widget.loadingClaimQuestId == quest.id,
                      cardColor: Color.lerp(effectiveCardColor, theme.scaffoldBackgroundColor, 0.08) ?? effectiveCardColor,
                      textColor: effectiveTextColor,
                      accentColor: effectiveAccentColor,
                      viewingUserProfile: widget.viewingUserProfile,    // User whose progress is shown on this card
                      currentUserProfile: widget.currentUserProfile,  // User performing the action
                    ),
                  );
                }).toList(),
        ),
      ),
    );
  }
}
