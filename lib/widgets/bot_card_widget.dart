// lib/widgets/bot_card_widget.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../models/bot_model.dart';
import '../utils/app_colors.dart';

class BotCardWidget extends StatelessWidget {
  final BotModel bot;
  final Function(BotStatus) onUpdateStatus;
  final VoidCallback onDelete;

  const BotCardWidget({
    Key? key,
    required this.bot,
    required this.onUpdateStatus,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pnlFormat = NumberFormat.simpleCurrency(locale: 'en_US');

    Color statusColor;
    String statusText;
    switch (bot.status) {
      case BotStatus.active:
        statusColor = AppColors.success;
        statusText = "Active";
        break;
      case BotStatus.paused:
        statusColor = AppColors.warning;
        statusText = "Paused";
        break;
      case BotStatus.error:
        statusColor = AppColors.error;
        statusText = "Error";
        break;
    }

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.secondary.withOpacity(0.1),
                  child: FaIcon(FontAwesomeIcons.robot, color: theme.colorScheme.secondary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(bot.name, style: theme.textTheme.titleMedium),
                      Text(bot.type, style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.7))),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'pause') onUpdateStatus(BotStatus.paused);
                    if (value == 'start') onUpdateStatus(BotStatus.active);
                    if (value == 'delete') onDelete();
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    if (bot.status == BotStatus.active)
                      const PopupMenuItem<String>(
                        value: 'pause',
                        child: ListTile(leading: Icon(Icons.pause), title: Text('Pause Bot')),
                      ),
                    if (bot.status == BotStatus.paused || bot.status == BotStatus.error)
                      const PopupMenuItem<String>(
                        value: 'start',
                        child: ListTile(leading: Icon(Icons.play_arrow), title: Text('Start Bot')),
                      ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: ListTile(leading: Icon(Icons.delete_outline, color: Colors.red), title: Text('Delete Bot', style: TextStyle(color: Colors.red))),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn("24h P&L", pnlFormat.format(bot.pnl24h), bot.pnl24h >= 0 ? AppColors.success : AppColors.error, theme),
                _buildStatColumn("Total Trades", bot.totalTrades.toString(), theme.textTheme.bodyLarge!.color!, theme),
                _buildStatColumn("Status", statusText, statusColor, theme),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color valueColor, ThemeData theme) {
    return Column(
      children: [
        Text(label, style: theme.textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.titleMedium?.copyWith(color: valueColor, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
