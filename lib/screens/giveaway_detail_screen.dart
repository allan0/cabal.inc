// lib/screens/giveaway_detail_screen.dart
import 'package:cabal/features/wallet/application/wallet_provider.dart';
import 'package:cabal/services/web3_service.dart';
import 'package:cabal/widgets/diamond_mesh_background.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';

// Placeholder model for giveaway details
class GiveawayDetails {
  final String prizeAmount;
  final String prizeSymbol;
  final String goalDescription;
  final int goalTarget;
  final int currentProgress;
  final String state; // "Open", "Canceled", "Complete"
  final String? winnerAddress;
  final String contractOwner;

  GiveawayDetails({
    required this.prizeAmount,
    required this.prizeSymbol,
    required this.goalDescription,
    required this.goalTarget,
    required this.currentProgress,
    required this.state,
    this.winnerAddress,
    required this.contractOwner,
  });
}

class GiveawayDetailScreen extends StatefulWidget {
  final String giveawayContractAddress;
  const GiveawayDetailScreen({Key? key, required this.giveawayContractAddress}) : super(key: key);

  @override
  State<GiveawayDetailScreen> createState() => _GiveawayDetailScreenState();
}

class _GiveawayDetailScreenState extends State<GiveawayDetailScreen> {
  Future<GiveawayDetails>? _detailsFuture;
  bool _isProcessingAction = false;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  void _loadDetails() {
    setState(() {
      _detailsFuture = _fetchGiveawayDetails();
    });
  }

  Future<GiveawayDetails> _fetchGiveawayDetails() async {
    // In a real app, this would fetch data from the smart contract and Supabase
    await Future.delayed(const Duration(seconds: 1));
    return GiveawayDetails(
      prizeAmount: "10,000",
      prizeSymbol: "USDC",
      goalDescription: "1,000 New Referrals",
      goalTarget: 1000,
      currentProgress: 754,
      state: "Open", // or "Complete", "Canceled"
      winnerAddress: null, // or a real address if set
      contractOwner: "0xCreatorAddressPlaceholder", // Fetched from contract.owner()
    );
  }

  Future<void> _claimPrize() async {
    // TODO: Implement call to Giveaway.sol's claimPrize() via Web3Service
  }

  Future<void> _setWinner() {
    // TODO: Show a dialog to input the winner's address and then call setWinner()
    return Future.value();
  }

  Future<void> _cancelGiveaway() {
    // TODO: Implement call to Giveaway.sol's cancelGiveaway() via Web3Service
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final walletProvider = context.watch<WalletProvider>();
    
    return Scaffold(
      appBar: AppBar(title: const Text("Giveaway Details")),
      body: DiamondMeshBackground(
        child: FutureBuilder<GiveawayDetails>(
          future: _detailsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return Center(child: Text("Error: ${snapshot.error ?? 'Could not load giveaway details.'}"));
            }
            
            final details = snapshot.data!;
            final isOwner = walletProvider.isConnectedEVM && walletProvider.connectedEVMAddress?.toLowerCase() == details.contractOwner.toLowerCase();
            final isWinner = walletProvider.isConnectedEVM && details.winnerAddress != null && walletProvider.connectedEVMAddress?.toLowerCase() == details.winnerAddress!.toLowerCase();

            return RefreshIndicator(
              onRefresh: () async => _loadDetails(),
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildPrizeCard(theme, details),
                  const SizedBox(height: 16),
                  _buildProgressCard(theme, details),
                  if (isWinner && details.state == "Open") ...[
                    const SizedBox(height: 24),
                    _buildWinnerActions(theme),
                  ],
                  if (isOwner && details.state == "Open") ...[
                    const SizedBox(height: 24),
                    _buildOwnerActions(theme, details),
                  ]
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPrizeCard(ThemeData theme, GiveawayDetails details) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const FaIcon(FontAwesomeIcons.gift, size: 40, color: AppColors.gold),
            const SizedBox(height: 16),
            Text("Prize", style: theme.textTheme.titleMedium),
            Text(
              "${details.prizeAmount} ${details.prizeSymbol}",
              style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.gold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(ThemeData theme, GiveawayDetails details) {
    final progress = (details.currentProgress / details.goalTarget).clamp(0.0, 1.0);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Goal: ${details.goalDescription}", style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              borderRadius: BorderRadius.circular(6),
            ),
            const SizedBox(height: 8),
            Text("${details.currentProgress} / ${details.goalTarget} (${(progress * 100).toStringAsFixed(1)}%)"),
            const Divider(height: 24),
            Row(
              children: [
                const Text("Status: "),
                Text(details.state, style: TextStyle(fontWeight: FontWeight.bold, color: details.state == "Open" ? AppColors.success : Colors.grey)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWinnerActions(ThemeData theme) {
    return Card(
      color: AppColors.success.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Congratulations!", style: theme.textTheme.headlineSmall?.copyWith(color: AppColors.success)),
            const SizedBox(height: 8),
            const Text("You have won this giveaway. Claim your prize now!", textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isProcessingAction ? null : _claimPrize,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
              child: _isProcessingAction ? const CircularProgressIndicator() : const Text("Claim Prize"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOwnerActions(ThemeData theme, GiveawayDetails details) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Admin Controls", style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isProcessingAction || details.winnerAddress != null ? null : _setWinner,
              child: const Text("Set Winner"),
            ),
            const SizedBox(height: 8),
            Text(details.winnerAddress != null ? "Winner has been set." : "Set a winner once the goal is met.", style: theme.textTheme.bodySmall),
            const Divider(height: 24),
            OutlinedButton(
              onPressed: _isProcessingAction || details.winnerAddress != null ? null : _cancelGiveaway,
              style: OutlinedButton.styleFrom(foregroundColor: theme.colorScheme.error, side: BorderSide(color: theme.colorScheme.error)),
              child: const Text("Cancel Giveaway & Reclaim Prize"),
            ),
          ],
        ),
      ),
    );
  }
}
