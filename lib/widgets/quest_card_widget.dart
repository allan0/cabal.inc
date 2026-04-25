// lib/widgets/quest_card_widget.dart
import 'dart:ui'; // For ImageFilter.blur
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:url_launcher/url_launcher.dart';

import '../models/quest_model.dart';
import '../models/user_profile_model.dart';
import '../utils/app_colors.dart';
import '../utils/icon_mapper.dart';
import '../utils/constants.dart' show QuestType, questTypeToString;
import '../screens/login_screen.dart';

class QuestCardWidget extends StatefulWidget {
  final Quest quest;
  final VoidCallback onClaimReward;
  final bool isLoadingClaim;
  final Color cardColor;
  final Color textColor;
  final Color accentColor;
  final UserProfile? viewingUserProfile;
  final UserProfile? currentUserProfile;

  const QuestCardWidget({
    Key? key,
    required this.quest,
    required this.onClaimReward,
    required this.isLoadingClaim,
    required this.cardColor,
    required this.textColor,
    required this.accentColor,
    this.viewingUserProfile,
    this.currentUserProfile,
  }) : super(key: key);

  @override
  State<QuestCardWidget> createState() => _QuestCardWidgetState();
}

class _QuestCardWidgetState extends State<QuestCardWidget> {
  bool _isExpanded = false;

  Map<String, dynamic> _getInteractionStateForCurrentUser() {
    if (widget.currentUserProfile == null) {
      bool canGuestInteractButton = (widget.quest.type == QuestType.custom &&
                                   (widget.quest.taskButtonText?.toLowerCase() == "info" ||
                                    widget.quest.detailedContent != null && widget.quest.detailedContent!.isNotEmpty)) ||
                                  (widget.quest.actionUrl != null &&
                                   widget.quest.actionUrl!.isNotEmpty &&
                                   (widget.quest.type == QuestType.websiteVisit ||
                                    widget.quest.type == QuestType.custom));

      String buttonText = "Log in to Start";
      if (widget.quest.type == QuestType.custom && (widget.quest.taskButtonText?.toLowerCase() == "info" || (widget.quest.detailedContent != null && widget.quest.detailedContent!.isNotEmpty))) {
        buttonText = widget.quest.taskButtonText ?? "View Info";
      } else if (widget.quest.actionUrl != null && widget.quest.actionUrl!.isNotEmpty && (widget.quest.type == QuestType.websiteVisit || widget.quest.type == QuestType.custom)) {
        buttonText = widget.quest.taskButtonText ?? "Visit Site";
      }
      return {'canInteract': canGuestInteractButton, 'buttonText': buttonText, 'isPendingForActor': false};
    }

    String actorSpecificStatus = 'not_started';
    bool isActorViewingSelf = widget.currentUserProfile!.id == widget.viewingUserProfile?.id;

    if (isActorViewingSelf) {
        actorSpecificStatus = widget.quest.userQuestSpecificStatus;
    }

    bool isPendingForActor = actorSpecificStatus == 'pending_verification';
    String statusTextForButton = widget.quest.statusText;

    if (isActorViewingSelf && isPendingForActor) {
      statusTextForButton = "Pending Review";
    }

    bool appearsInteractable;
    if (isActorViewingSelf) {
        appearsInteractable = !widget.isLoadingClaim &&
                              !widget.quest.isLockedForUser &&
                              (!widget.quest.isCompletedByUser || (widget.quest.isCompletedByUser && widget.quest.cooldownPeriod != null && !widget.quest.isOnCooldownForUser)) &&
                              !isPendingForActor;
    } else {
        appearsInteractable = !widget.isLoadingClaim &&
                              !widget.quest.isLockedForUser &&
                              (widget.quest.type == QuestType.websiteVisit || (widget.quest.type == QuestType.custom && widget.quest.actionUrl != null && widget.quest.actionUrl!.isNotEmpty));
        if (!appearsInteractable) {
            statusTextForButton = "Viewing";
        }
    }

    return {'canInteract': appearsInteractable, 'buttonText': statusTextForButton, 'isPendingForActor': isPendingForActor};
  }

  Future<void> _handleTap() async {
    String questIdDebug = widget.quest.id;
    String questTitleDebug = widget.quest.title;
    String questTypeDebug = widget.quest.type.toString();
    String questActionUrlDebug = widget.quest.actionUrl ?? "NULL_ACTION_URL";
    String questDetailedContentPreview = "NULL_DETAILED_CONTENT";
    if (widget.quest.detailedContent != null) {
        questDetailedContentPreview = widget.quest.detailedContent!.substring(0,
            (widget.quest.detailedContent!.length > 50 ? 50 : widget.quest.detailedContent!.length)) + "...";
    }

    debugPrint("QuestCardWidget: _handleTap CALLED.");
    debugPrint("  Quest Details from WIDGET.QUEST:");
    debugPrint("    ID: $questIdDebug");
    debugPrint("    Title: '$questTitleDebug'");
    debugPrint("    Type: $questTypeDebug");
    debugPrint("    ActionURL: $questActionUrlDebug");
    debugPrint("    DetailedContent (start): $questDetailedContentPreview");
    debugPrint("    TaskButtonText: ${widget.quest.taskButtonText ?? "NULL_BUTTON_TEXT"}");
    debugPrint("  Current User Profile ID: ${widget.currentUserProfile?.id ?? "NULL_CURRENT_USER"}");
    debugPrint("  Viewing User Profile ID: ${widget.viewingUserProfile?.id ?? "NULL_VIEWING_USER"}");
    debugPrint("  widget.isLoadingClaim: ${widget.isLoadingClaim}");

    if (widget.isLoadingClaim) {
      debugPrint("QuestCardWidget: Bailing: isLoadingClaim is true.");
      return;
    }

    if (widget.currentUserProfile == null) {
      debugPrint("QuestCardWidget: Handling guest interaction.");
      bool canGuestInteractSimple =
          (widget.quest.type == QuestType.custom && (widget.quest.taskButtonText?.toLowerCase() == "info" || (widget.quest.detailedContent != null && widget.quest.detailedContent!.isNotEmpty))) ||
          (widget.quest.actionUrl != null && widget.quest.actionUrl!.isNotEmpty && (widget.quest.type == QuestType.websiteVisit || widget.quest.type == QuestType.custom));

      if (canGuestInteractSimple) {
        if (widget.quest.detailedContent != null && widget.quest.detailedContent!.isNotEmpty) {
          if (mounted) setState(() => _isExpanded = !_isExpanded);
          if ((widget.quest.actionUrl == null || widget.quest.actionUrl!.isEmpty) && _isExpanded) {
             return;
          }
        }
        if (widget.quest.actionUrl != null && widget.quest.actionUrl!.isNotEmpty &&
            (widget.quest.type == QuestType.websiteVisit || (widget.quest.type == QuestType.custom && (widget.quest.taskButtonText?.toLowerCase() == "visit site" || widget.quest.taskButtonText?.toLowerCase() == "learn more")) )) {
          debugPrint("QuestCardWidget (Guest): Calling onClaimReward for URL launch for quest $questIdDebug");
          widget.onClaimReward();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please log in to interact with this quest.')),
          );
          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
        }
      }
      return;
    }

    debugPrint("QuestCardWidget: Handling logged-in user interaction.");
    final interactionState = _getInteractionStateForCurrentUser();
    bool isActorViewingSelf = widget.currentUserProfile!.id == widget.viewingUserProfile?.id;

    if (interactionState['isPendingForActor'] == true && isActorViewingSelf) {
        debugPrint("QuestCardWidget: Quest is pending for actor viewing self. Bailing.");
        if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('This quest is currently pending verification for you.')),
            );
        }
        return;
    }

    if (! (interactionState['canInteract'] as bool? ?? false) ) {
        debugPrint("QuestCardWidget: Actor cannot interact based on interactionState. Checking for details expansion.");
        if (widget.quest.detailedContent != null && widget.quest.detailedContent!.isNotEmpty) {
            if (mounted) setState(() => _isExpanded = !_isExpanded);
        } else {
             if (widget.quest.isLockedForUser) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('This quest is locked.')));
             } else if (widget.quest.isCompletedByUser && widget.quest.cooldownPeriod == null) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quest already completed.')));
             }
        }
        return;
    }

    if (widget.quest.detailedContent != null && widget.quest.detailedContent!.isNotEmpty) {
      if (!_isExpanded) {
        debugPrint("QuestCardWidget (User): Expanding details for quest $questIdDebug.");
        if (mounted) setState(() => _isExpanded = true);
      } else {
        debugPrint("QuestCardWidget (User): Calling onClaimReward (expanded card) for quest $questIdDebug");
        widget.onClaimReward();
      }
    } else {
      debugPrint("QuestCardWidget (User): Calling onClaimReward (no details) for quest $questIdDebug");
      widget.onClaimReward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final globalTheme = Theme.of(context);
    final currentCardColor = widget.cardColor;
    final currentTextColor = widget.textColor;
    final currentAccentColor = widget.accentColor;

    final interactionState = _getInteractionStateForCurrentUser();
    final String buttonText = interactionState['buttonText'] as String;
    final bool canInteractButtonVisual = interactionState['canInteract'] as bool? ?? false;
    final bool isQuestPendingForActorDisplay = interactionState['isPendingForActor'] as bool? ?? false;

    final String questTypeStr = questTypeToString(widget.quest.type);
    final questSpecificBorderColor = AppColors.questBorderColor(questTypeStr);
    final bool hasSpecificBorder = questSpecificBorderColor != AppColors.questTypeDefaultBorder;

    bool isLockedForViewingUser = widget.viewingUserProfile != null ? widget.quest.isLockedForUser : true;
    bool isCompletedByViewingUser = widget.viewingUserProfile != null ? widget.quest.isCompletedByUser : false;
    bool isOnCooldownForViewingUser = widget.viewingUserProfile != null ? widget.quest.isOnCooldownForUser : false;
    String viewingUserSpecificStatus = widget.viewingUserProfile != null ? widget.quest.userQuestSpecificStatus : 'not_started';
    bool isPendingForViewingUser = viewingUserSpecificStatus == 'pending_verification';

    List<Color> borderGradientColors;
    if (widget.viewingUserProfile == null) {
        borderGradientColors = [currentTextColor.withOpacity(0.2), currentTextColor.withOpacity(0.1)];
    } else if (isPendingForViewingUser) {
        borderGradientColors = [AppColors.warning, AppColors.warning.withOpacity(0.5)];
    } else if (hasSpecificBorder) {
        borderGradientColors = [questSpecificBorderColor, questSpecificBorderColor.withOpacity(0.6)];
    } else if (isCompletedByViewingUser && !isOnCooldownForViewingUser && widget.quest.cooldownPeriod == null) {
        borderGradientColors = [AppColors.success, AppColors.success.withOpacity(0.5)];
    } else if (isLockedForViewingUser || isOnCooldownForViewingUser) {
        borderGradientColors = [currentTextColor.withOpacity(0.3), currentTextColor.withOpacity(0.15)];
    } else {
        borderGradientColors = [AppColors.primaryAccent, AppColors.secondaryAccent];
    }

    Color xpColor;
    if (widget.viewingUserProfile == null) {
        xpColor = currentTextColor.withOpacity(0.6);
    } else if (isCompletedByViewingUser && !isOnCooldownForViewingUser && widget.quest.cooldownPeriod == null) {
        xpColor = globalTheme.brightness == Brightness.dark ? AppColors.darkTextSecondary.withOpacity(0.6) : AppColors.textSecondary.withOpacity(0.6);
    } else if (isLockedForViewingUser || isOnCooldownForViewingUser || isPendingForViewingUser) {
        xpColor = currentTextColor.withOpacity(0.5);
    } else {
        xpColor = AppColors.gold;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: InkWell(
          onTap: (widget.isLoadingClaim || (isQuestPendingForActorDisplay && widget.currentUserProfile?.id == widget.viewingUserProfile?.id) ) ? null : _handleTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: currentAccentColor.withOpacity(0.12),
          highlightColor: currentAccentColor.withOpacity(0.06),
          child: Container(
            decoration: BoxDecoration(
              color: currentCardColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: currentTextColor.withOpacity(0.1)),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: borderGradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(1.5),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: currentCardColor,
                  borderRadius: BorderRadius.circular(14.5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0, right: 12.0),
                          child: FaIcon(
                            isLockedForViewingUser ? FontAwesomeIcons.lock :
                            (isPendingForViewingUser ? FontAwesomeIcons.hourglassHalf : getIconFromName(widget.quest.iconName)),
                            color: isLockedForViewingUser ? currentTextColor.withOpacity(0.5) :
                                     (isPendingForViewingUser ? AppColors.warning : AppColors.primaryAccent),
                            size: 20
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.quest.title,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: (isLockedForViewingUser || isPendingForViewingUser)
                                      ? currentTextColor.withOpacity(0.6)
                                      : currentTextColor,
                                  decoration: (isCompletedByViewingUser && !isOnCooldownForViewingUser && widget.quest.cooldownPeriod == null && !isPendingForViewingUser)
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  decorationColor: currentTextColor.withOpacity(0.6),
                                ),
                              ),
                              if (widget.quest.description.isNotEmpty && !_isExpanded) ...[
                                const SizedBox(height: 6),
                                Text(
                                  widget.quest.description,
                                  style: TextStyle(fontSize: 14, color: currentTextColor.withOpacity(0.75), height: 1.4),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ]
                            ],
                          ),
                        ),
                      ],
                    ),

                    if (widget.quest.totalSteps > 1 && (widget.viewingUserProfile == null || (!isCompletedByViewingUser && !isPendingForViewingUser)) ) ...[
                       const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: (widget.viewingUserProfile != null && widget.quest.totalSteps > 0)
                                  ? (widget.quest.userCurrentStepsCompleted.toDouble() / widget.quest.totalSteps.toDouble()).clamp(0.0, 1.0)
                                  : 0.0,
                              backgroundColor: AppColors.primaryAccent.withOpacity(0.2),
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryAccent),
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            widget.viewingUserProfile != null ? '${widget.quest.userCurrentStepsCompleted}/${widget.quest.totalSteps}' : '0/${widget.quest.totalSteps}',
                             style: TextStyle(fontSize: 12, color: currentTextColor.withOpacity(0.7), fontWeight: FontWeight.w500),
                          ),
                        ],
                      ).animate().fadeIn(delay: 100.ms),
                    ],

                    if (_isExpanded && widget.quest.detailedContent != null && widget.quest.detailedContent!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 32.0),
                        child: MarkdownBody(
                          data: widget.quest.detailedContent!,
                          styleSheet: MarkdownStyleSheet.fromTheme(globalTheme).copyWith(
                            p: globalTheme.textTheme.bodyMedium?.copyWith(
                              color: currentTextColor.withOpacity(0.85),
                              height: 1.5,
                            ),
                            h1: globalTheme.textTheme.titleLarge?.copyWith(
                              color: currentAccentColor,
                              fontWeight: FontWeight.bold,
                            ),
                            h2: globalTheme.textTheme.titleMedium?.copyWith(
                              color: currentAccentColor,
                              fontWeight: FontWeight.bold,
                            ),
                            a: TextStyle(color: AppColors.secondaryAccent, decoration: TextDecoration.underline),
                            listBullet: globalTheme.textTheme.bodyMedium?.copyWith(
                              color: currentTextColor.withOpacity(0.85),
                            ),
                          ),
                          onTapLink: (text, href, title) {
                            if (href != null) {
                              launchUrl(Uri.parse(href));
                            }
                          },
                          selectable: true,
                        ),
                      ).animate().fadeIn(duration: 200.ms),

                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: xpColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                               FaIcon(FontAwesomeIcons.star, size: 12, color: xpColor),
                               const SizedBox(width: 6),
                               Text(
                                '${NumberFormat.compact().format(widget.quest.xpReward)} XP',
                                style: TextStyle(
                                  color: xpColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: (widget.isLoadingClaim || (isQuestPendingForActorDisplay && widget.currentUserProfile?.id == widget.viewingUserProfile?.id) || !canInteractButtonVisual)
                                      ? null
                                      : _handleTap,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: canInteractButtonVisual ? AppColors.primaryAccent : currentTextColor.withOpacity(0.1),
                            foregroundColor: canInteractButtonVisual ? AppColors.lightText : currentTextColor.withOpacity(0.5),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            minimumSize: const Size(90, 40),
                            elevation: (canInteractButtonVisual && !widget.isLoadingClaim && !(isQuestPendingForActorDisplay && widget.currentUserProfile?.id == widget.viewingUserProfile?.id)) ? 4 : 0,
                          ),
                          child: widget.isLoadingClaim
                              ? const SizedBox(
                                  height: 20, width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                                )
                              : Text(buttonText, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
