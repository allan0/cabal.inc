// lib/screens/escrow_detail_screen.dart
import 'package:cabal/features/wallet/application/wallet_provider.dart';
import 'package:cabal/services/web3_service.dart';
import 'package:cabal/widgets/diamond_mesh_background.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import '../utils/app_colors.dart';

// This model should be in its own file: lib/models/escrow_details_model.dart
class EscrowDetails {
  final String seller;
  final String buyer;
  final String broker;
  final String salePriceEth;
  final BigInt salePriceWei;
  final String state; // e.g., "Locked", "InspectionPassed"
  final bool buyerApproved;
  final bool sellerApproved;
  final bool brokerApproved;

  EscrowDetails({
    required this.seller, required this.buyer, required this.broker,
    required this.salePriceEth, required this.salePriceWei, required this.state,
    required this.buyerApproved, required this.sellerApproved, required this.brokerApproved,
  });
}

class EscrowDetailScreen extends StatefulWidget {
  final int tokenId;
  
  const EscrowDetailScreen({
    Key? key,
    required this.tokenId,
  }) : super(key: key);

  @override
  State<EscrowDetailScreen> createState() => _EscrowDetailScreenState();
}

class _EscrowDetailScreenState extends State<EscrowDetailScreen> {
  Future<EscrowDetails>? _detailsFuture;
  bool _isProcessingAction = false;
  late final Web3Service _web3Service;

  @override
  void initState() {
    super.initState();
    _web3Service = context.read<Web3Service>();
    _loadDetails();
  }

  void _loadDetails() {
    setState(() {
      _detailsFuture = _fetchEscrowDetails();
    });
  }

  Future<EscrowDetails> _fetchEscrowDetails() async {
    return await _web3Service.getEscrowDetails(BigInt.from(widget.tokenId));
  }
  
  Future<void> _handleTransaction(Transaction tx, String successMessage) async {
    final walletProvider = context.read<WalletProvider>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    setState(() => _isProcessingAction = true);
    try {
      final txHash = await walletProvider.sendTransaction(tx);
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text("$successMessage Tx: $txHash. State will update after confirmation."),
        backgroundColor: AppColors.success,
      ));
      
      // In a production app, you would listen for the transaction receipt.
      await Future.delayed(const Duration(seconds: 15));
      _loadDetails(); // Refresh state after action
    } catch(e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Action failed: $e"), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() => _isProcessingAction = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final walletProvider = context.watch<WalletProvider>();
    
    return Scaffold(
      appBar: AppBar(title: const Text("Real Estate Escrow")),
      body: DiamondMeshBackground(
        child: FutureBuilder<EscrowDetails>(
          future: _detailsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return Center(child: Text("Error: ${snapshot.error ?? 'Could not load escrow details.'}"));
            }
            
            final details = snapshot.data!;
            final isSeller = walletProvider.isConnectedEVM && walletProvider.connectedEVMAddress?.toLowerCase() == details.seller.toLowerCase();
            final isBuyer = walletProvider.isConnectedEVM && walletProvider.connectedEVMAddress?.toLowerCase() == details.buyer.toLowerCase();
            final isBroker = walletProvider.isConnectedEVM && walletProvider.connectedEVMAddress?.toLowerCase() == details.broker.toLowerCase();

            return RefreshIndicator(
              onRefresh: () async => _loadDetails(),
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildStatusTimeline(theme, details),
                  const SizedBox(height: 16),
                  _buildPartiesCard(theme, details),
                  const SizedBox(height: 16),
                  _buildActionCard(theme, details, isSeller, isBuyer, isBroker),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusTimeline(ThemeData theme, EscrowDetails details) {
    final states = ["Created", "Locked", "InspectionPassed", "Complete"];
    int currentStateIndex = states.indexOf(details.state);
    if (details.state == "Canceled") currentStateIndex = -1;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Transaction Status", style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(states.length, (index) {
                final bool isComplete = index < currentStateIndex;
                final bool isCurrent = index == currentStateIndex;
                Color color = Colors.grey;
                if (isComplete) color = AppColors.success;
                if (isCurrent) color = theme.colorScheme.primary;
                if (details.state == "Canceled") color = theme.colorScheme.error;

                return Column(
                  children: [
                    Icon(
                      isComplete ? Icons.check_circle : (isCurrent ? Icons.timelapse : Icons.radio_button_unchecked),
                      color: color,
                    ),
                    const SizedBox(height: 4),
                    Text(states[index], style: theme.textTheme.bodySmall?.copyWith(color: isCurrent ? color : null))
                  ],
                );
              }),
            ),
             if (details.state == "Canceled") ...[
              const SizedBox(height: 8),
              Center(child: Text("This sale has been canceled.", style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.bold)))
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildPartiesCard(ThemeData theme, EscrowDetails details) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text("Parties & Price", style: theme.textTheme.titleLarge),
             const Divider(height: 24),
            _buildPartyRow(theme, "Seller", details.seller),
            _buildPartyRow(theme, "Buyer", details.buyer.contains('0000000') ? 'N/A (Waiting for deposit)' : details.buyer),
            _buildPartyRow(theme, "Broker", details.broker),
            const Divider(height: 24),
            _buildPartyRow(theme, "Sale Price", details.salePriceEth, isAddress: false),
          ],
        ),
      ),
    );
  }

  Widget _buildPartyRow(ThemeData theme, String role, String value, {bool isAddress = true}) {
    final displayValue = (isAddress && value.length > 10) ? "${value.substring(0, 6)}...${value.substring(value.length - 4)}" : value;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(role, style: theme.textTheme.bodyLarge),
          SelectableText(displayValue, style: theme.textTheme.bodyMedium?.copyWith(fontFamily: isAddress ? 'monospace' : null)),
        ],
      ),
    );
  }
  
  Widget _buildActionCard(ThemeData theme, EscrowDetails details, bool isSeller, bool isBuyer, bool isBroker) {
    final walletProvider = context.watch<WalletProvider>();
    if (!walletProvider.isConnectedEVM) return const SizedBox.shrink();
    
    final tokenId = BigInt.from(widget.tokenId);
    Widget actionWidget = const Text("No actions available for you at this stage.");
    bool isParty = isSeller || isBuyer || isBroker;

    if (details.state == "Created" && !isSeller) {
      actionWidget = _buildActionButton(
        title: "Deposit Escrow",
        subtitle: "Lock the sale by depositing ${details.salePriceEth}.",
        buttonText: "Deposit Funds",
        onPressed: () => _handleTransaction(
          _web3Service.buildDepositFundsTransaction(tokenId: tokenId, escrowAmountWei: details.salePriceWei),
          "Deposit transaction sent!"
        ),
      );
    } else if (details.state == "Locked" && isParty) {
      actionWidget = _buildInspectionApprovalSection(theme, details, isSeller, isBuyer, isBroker);
    } else if (details.state == "InspectionPassed" && isParty) {
       actionWidget = _buildActionButton(
        title: "Finalize Sale",
        subtitle: "All parties have approved. This will transfer the NFT and release funds.",
        buttonText: "Finalize",
        onPressed: () => _handleTransaction(
          _web3Service.buildFinalizeSaleTransaction(tokenId: tokenId),
          "Finalization transaction sent!"
        ),
        color: AppColors.success,
      );
    }
    
    // Allow cancellation if it's a party and the state is appropriate
    if ((details.state == "Created" || details.state == "Locked") && isParty) {
      actionWidget = Column(children: [
        actionWidget, // Show the primary action first
        const Divider(height: 24),
        _buildActionButton(
          title: "Cancel Sale",
          subtitle: "This will return the NFT to the seller and refund the buyer if funds were deposited.",
          buttonText: "Cancel",
          onPressed: () => _handleTransaction(
            _web3Service.buildCancelSaleTransaction(tokenId: tokenId),
            "Cancellation transaction sent!"
          ),
          color: theme.colorScheme.error,
        ),
      ]);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Your Action", style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            actionWidget,
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _isProcessingAction ? null : onPressed,
          style: ElevatedButton.styleFrom(backgroundColor: color, padding: const EdgeInsets.symmetric(vertical: 12)),
          child: _isProcessingAction ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white)) : Text(buttonText),
        ),
      ],
    );
  }

  Widget _buildInspectionApprovalSection(ThemeData theme, EscrowDetails details, bool isSeller, bool isBuyer, bool isBroker) {
    bool currentUserHasApproved = 
      (isSeller && details.sellerApproved) ||
      (isBuyer && details.buyerApproved) ||
      (isBroker && details.brokerApproved);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Inspection & Due Diligence", style: theme.textTheme.titleMedium),
        const Text("All three parties must approve this stage to proceed."),
        const SizedBox(height: 16),
        _buildApprovalStatus("Seller", details.sellerApproved),
        _buildApprovalStatus("Buyer", details.buyerApproved),
        _buildApprovalStatus("Broker", details.brokerApproved),
        const SizedBox(height: 16),
        if (isSeller || isBuyer || isBroker)
          ElevatedButton(
            onPressed: _isProcessingAction || currentUserHasApproved ? null : () => _handleTransaction(
              _web3Service.buildApproveInspectionTransaction(tokenId: BigInt.from(widget.tokenId)),
              "Approval transaction sent!"
            ),
            child: Text(currentUserHasApproved ? "You Have Approved" : "Approve Inspection"),
          ),
      ],
    );
  }

  Widget _buildApprovalStatus(String role, bool isApproved) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            isApproved ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isApproved ? AppColors.success : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text("$role Approval"),
        ],
      ),
    );
  }
}
