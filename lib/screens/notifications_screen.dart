// lib/screens/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

// Model & Service Imports
import '../models/notification_model.dart';
import '../services/supabase_service.dart';

// UI & Util Imports
import '../widgets/animated_particle_background.dart';
import '../utils/app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  final String userId;

  const NotificationsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchNotificationsAndMarkRead();
  }

  Future<void> _fetchNotificationsAndMarkRead() async {
    if(!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final notifications = await _supabaseService.getUserNotifications(widget.userId);
      if (mounted) {
        setState(() {
          _notifications = notifications;
          _isLoading = false;
        });
        if (notifications.any((n) => !n.isRead)) {
          await _supabaseService.markAllNotificationsAsRead(widget.userId);
          if (mounted) {
            setState(() {
              for (var notification in _notifications) {
                notification.isRead = true;
              }
            });
          }
        }
      }
    } catch (e) {
      print("Error fetching/marking notifications for user ${widget.userId}: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Failed to load notifications: ${e.toString().split(':').last.trim()}";
        });
      }
    }
  }

  // --- NEW METHOD TO DELETE A NOTIFICATION ---
  Future<void> _deleteNotification(int index) async {
    final notificationToDelete = _notifications[index];
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // Optimistically remove from UI
    setState(() {
      _notifications.removeAt(index);
    });

    try {
      await _supabaseService.deleteNotification(notificationToDelete.id);
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Notification deleted.'), duration: Duration(seconds: 2)),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error deleting notification: $e'), backgroundColor: Colors.red),
      );
      // Revert UI on failure
      if (mounted) {
        setState(() {
          _notifications.insert(index, notificationToDelete);
        });
      }
    }
  }

  IconData _getIconForNotificationType(String? type) {
    switch (type?.toLowerCase()) {
      case 'quest_complete':
      case 'reward_claimed':
        return FontAwesomeIcons.gift;
      case 'achievement_unlocked':
        return FontAwesomeIcons.trophy;
      case 'new_quest':
        return FontAwesomeIcons.bullhorn;
      case 'quest_pending':
        return FontAwesomeIcons.hourglassHalf;
      case 'manual_quest_approved':
        return FontAwesomeIcons.solidCircleCheck;
      case 'manual_quest_rejected':
        return FontAwesomeIcons.solidCircleXmark;
      // --- NEW NOTIFICATION TYPES ---
      case 'join_request':
        return FontAwesomeIcons.userPlus;
      case 'news_update':
        return FontAwesomeIcons.newspaper;
      // --- END ---
      default:
        return FontAwesomeIcons.infoCircle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final DateFormat dateFormat = DateFormat('MMM d, yyyy - hh:mm a');

    Widget bodyContent;

    if (_isLoading) {
      bodyContent = Center(child: CircularProgressIndicator(color: theme.colorScheme.secondary).animate().fadeIn());
    } else if (_errorMessage != null) {
      bodyContent = Center(
        child: Card(
          elevation: 2,
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline_rounded, size: 50, color: theme.colorScheme.error.withOpacity(0.7)),
                const SizedBox(height: 16),
                Text(_errorMessage!, textAlign: TextAlign.center, style: theme.textTheme.titleMedium),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text("Retry"),
                  onPressed: _fetchNotificationsAndMarkRead,
                )
              ],
            ),
          ),
        ).animate().fadeIn(delay: 200.ms),
      );
    } else if (_notifications.isEmpty) {
      bodyContent = Center(
        child: Card(
          elevation: 2,
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(FontAwesomeIcons.inbox, size: 60, color: theme.textTheme.bodySmall?.color?.withOpacity(0.5)),
                const SizedBox(height: 16),
                Text("No notifications yet!", style: theme.textTheme.titleMedium?.copyWith(color: theme.textTheme.bodyLarge?.color)),
                const SizedBox(height: 8),
                Text("Check back later for updates on your quests and rewards.", style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.7)), textAlign: TextAlign.center),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 300.ms),
      );
    } else {
      bodyContent = ListView.builder(
        itemCount: _notifications.length,
        padding: EdgeInsets.only(
            top: kToolbarHeight + MediaQuery.of(context).padding.top + 8,
            left: 8, right: 8, bottom: 20
        ),
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          bool isEffectivelyRead = notification.isRead;

          // --- WRAP CARD WITH DISMISSIBLE ---
          return Dismissible(
            key: ValueKey(notification.id),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _deleteNotification(index);
            },
            background: Container(
              color: Colors.red.withOpacity(0.8),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: const FaIcon(FontAwesomeIcons.trashCan, color: Colors.white),
            ),
            child: Card(
              elevation: isEffectivelyRead ? 1.0 : 3.0,
              margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isEffectivelyRead
                    ? theme.dividerColor.withOpacity(0.2)
                    : theme.colorScheme.secondary.withOpacity(0.7),
                  width: isEffectivelyRead ? 0.8 : 1.2,
                )
              ),
              color: isEffectivelyRead ? theme.cardColor.withOpacity(0.85) : theme.cardColor,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.secondary.withOpacity(isEffectivelyRead ? 0.1 : 0.25),
                  child: FaIcon(
                    _getIconForNotificationType(notification.type),
                    size: 20,
                    color: theme.colorScheme.secondary.withOpacity(isEffectivelyRead ? 0.7 : 1.0),
                  ),
                ),
                title: Text(
                  notification.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: isEffectivelyRead ? FontWeight.normal : FontWeight.bold,
                    color: (theme.textTheme.bodyLarge?.color ?? Colors.black).withOpacity(isEffectivelyRead ? 0.75 : 1.0)
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.body,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 13,
                        color: (theme.textTheme.bodyMedium?.color ?? Colors.grey).withOpacity(isEffectivelyRead ? 0.7 : 0.9)
                      )
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateFormat.format(notification.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                          color: (theme.textTheme.bodySmall?.color ?? Colors.grey).withOpacity(isEffectivelyRead ? 0.5 : 0.6)
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(delay: (80 * index).ms).slideX(begin: index.isEven ? -0.1 : 0.1);
        },
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.8),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _fetchNotificationsAndMarkRead,
            tooltip: "Refresh Notifications",
          )
        ],
      ),
      body: AnimatedParticleBackground(
        baseColor: theme.scaffoldBackgroundColor,
        particleColor1: AppColors.particleGoldSoft.withOpacity(isDark ? 0.4 : 0.6),
        particleColor2: AppColors.particleDarkGrey.withOpacity(isDark ? 0.3 : 0.4),
        child: RefreshIndicator(
          onRefresh: _fetchNotificationsAndMarkRead,
          color: theme.colorScheme.secondary,
          backgroundColor: theme.cardColor,
          child: bodyContent,
        ),
      ),
    );
  }
}
