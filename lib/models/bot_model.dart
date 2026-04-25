// lib/models/bot_model.dart

enum BotStatus { active, paused, error }

class BotModel {
  final String id;
  final String name;
  final String type;
  BotStatus status; // <-- REMOVED 'final' KEYWORD
  final double pnl24h;
  final int totalTrades;

  BotModel({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.pnl24h,
    required this.totalTrades,
  });
}
