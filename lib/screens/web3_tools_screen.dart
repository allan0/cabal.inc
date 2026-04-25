// lib/screens/web3_tools_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/diamond_mesh_background.dart';
import '../models/bot_model.dart';
import '../widgets/bot_card_widget.dart';
import '../services/supabase_service.dart';

class Web3ToolsScreen extends StatefulWidget {
  const Web3ToolsScreen({Key? key}) : super(key: key);
  @override
  State<Web3ToolsScreen> createState() => _Web3ToolsScreenState();
}

class _Web3ToolsScreenState extends State<Web3ToolsScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  List<BotModel> _bots = [];
  bool _isLoading = true;

  final _formKey = GlobalKey<FormState>();
  final _botNameController = TextEditingController();
  final _botTokenController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBots();
  }

  Future<void> _fetchBots() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    final bots = await _supabaseService.getConnectedBots();
    if (mounted) {
      setState(() {
        _bots = bots;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _botNameController.dispose();
    _botTokenController.dispose();
    super.dispose();
  }

  void _showAddBotDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Connect a Telegram Bot"),
          content: Form(
            key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextFormField(controller: _botNameController, decoration: const InputDecoration(labelText: "Bot Name"), validator: (v) => (v == null || v.isEmpty) ? "Name is required" : null),
              const SizedBox(height: 16),
              TextFormField(controller: _botTokenController, decoration: const InputDecoration(labelText: "Telegram Bot Token"), validator: (v) => (v == null || v.isEmpty) ? "Token is required" : null, obscureText: true),
            ]),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancel")),
            ElevatedButton(onPressed: _onConnectBot, child: const Text("Connect")),
          ],
        );
      },
    );
  }

  Future<void> _onConnectBot() async {
    if (_formKey.currentState!.validate()) {
      final newBot = await _supabaseService.addBot(
        name: _botNameController.text,
        type: 'Telegram Bot',
        token: _botTokenController.text,
      );
      if (newBot != null && mounted) {
        setState(() => _bots.insert(0, newBot));
        _botNameController.clear();
        _botTokenController.clear();
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Bot connected successfully!")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to connect bot."), backgroundColor: Colors.red));
      }
    }
  }

  Future<void> _onUpdateBotStatus(BotModel bot, BotStatus newStatus) async {
    try {
      // Optimistic UI update
      final originalStatus = bot.status;
      setState(() {
        final botInList = _bots.firstWhere((b) => b.id == bot.id);
        botInList.status = newStatus;
      });
      await _supabaseService.updateBotStatus(bot.id, newStatus);
    } catch (e) {
      // Revert on error
      setState(() {
         final botInList = _bots.firstWhere((b) => b.id == bot.id);
         botInList.status = bot.status; // Revert to original
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update bot: $e")));
      }
    }
  }

  Future<void> _onDeleteBot(BotModel bot) async {
    try {
      // Optimistic UI update
      final botIndex = _bots.indexWhere((b) => b.id == bot.id);
      if (botIndex == -1) return;
      
      setState(() => _bots.removeAt(botIndex));
      await _supabaseService.deleteBot(bot.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bot "${bot.name}" deleted.')));
      }
    } catch (e) {
      // Revert on error - re-fetch the list for simplicity
      await _fetchBots();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to delete bot: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text("Web3 Tools"), backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.85)),
      body: DiamondMeshBackground(
        child: RefreshIndicator(
          onRefresh: _fetchBots,
          child: ListView(
            padding: EdgeInsets.only(top: kToolbarHeight + MediaQuery.of(context).padding.top + 16, left: 16, right: 16, bottom: 100),
            children: [
              Card(
                elevation: 4,
                color: theme.cardColor.withOpacity(0.8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text("Trading Bot Hub", style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary)),
                    const SizedBox(height: 8),
                    Text("Connect and manage your automated trading bots.", style: theme.textTheme.bodyLarge),
                  ]),
                ),
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 24),
              Text("Your Connected Bots", style: theme.textTheme.titleLarge).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 8),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_bots.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Center(
                    child: Text("You haven't connected any bots yet.\nTap the '+' button to add one!", textAlign: TextAlign.center, style: theme.textTheme.bodyLarge?.copyWith(color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7))),
                  ),
                )
              else
                ..._bots.map((bot) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: BotCardWidget(
                    bot: bot,
                    onUpdateStatus: (newStatus) => _onUpdateBotStatus(bot, newStatus),
                    onDelete: () => _onDeleteBot(bot),
                  ),
                )).toList().animate(interval: 100.ms).fadeIn().slideY(begin: 0.2),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddBotDialog,
        icon: const Icon(Icons.add),
        label: const Text("Add New Bot"),
      ).animate().slide(begin: const Offset(0, 2)).fadeIn(),
    );
  }
}
