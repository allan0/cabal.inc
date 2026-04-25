// lib/features/wallet/presentation/widgets/wallet_connector_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../application/wallet_provider.dart';
import 'package:cabal/utils/app_colors.dart';
import '../../../../widgets/info_tooltip.dart';

class WalletConnectorWidget extends StatelessWidget {
  const WalletConnectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildEvmWalletSection(context, walletProvider, theme),
            const Divider(height: 32),
            _buildSolanaWalletSection(context, walletProvider, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildSolanaWalletSection(BuildContext context, WalletProvider wp, ThemeData theme) {
    const solanaGradient = LinearGradient(colors: [Color(0xFF9945FF), Color(0xFF14F195)]);

    Widget connectButton = Container(
      decoration: BoxDecoration(
        gradient: solanaGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: ElevatedButton.icon(
        icon: const FaIcon(FontAwesomeIcons.ghost, size: 18),
        label: const Text('Connect Solana Wallet'),
        onPressed: (wp.isLoading || kIsWeb) ? null : () => wp.connectSolanaWallet(), // Disable on web
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          disabledBackgroundColor: Colors.grey.withOpacity(0.5),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const FaIcon(FontAwesomeIcons.ghost, color: Color(0xFF9945FF), size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text("Solana Wallet", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
            ),
            const InfoTooltip(message: "Connect your Phantom wallet (or other mobile Solana wallets) to interact with Solana-based quests."),
          ],
        ),
        const SizedBox(height: 16),
        if (wp.isLoadingSolana)
          const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator()))
        else if (wp.isConnectedSolana)
          _buildConnectedWalletInfo(
            theme: theme,
            address: wp.connectedSolanaAddress!,
            chainInfo: "Mainnet Beta",
            onDisconnect: () => wp.disconnectSolanaWallet(),
            walletTypeLabel: "Solana Wallet Connected",
            gradient: solanaGradient,
          )
        else if (kIsWeb)
          Tooltip(
            message: "Solana mobile connection is not available on web.",
            child: connectButton,
          )
        else
          connectButton.animate().fadeIn(delay: 100.ms).slideY(begin: 0.2),
        if (wp.solanaError != null) ...[
          const SizedBox(height: 12),
          Text(wp.solanaError!, style: TextStyle(color: theme.colorScheme.error, fontSize: 13)),
        ],
      ],
    );
  }

  Widget _buildEvmWalletSection(BuildContext context, WalletProvider wp, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FaIcon(FontAwesomeIcons.ethereum, color: theme.colorScheme.secondary, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text("EVM Wallets", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
            ),
            const InfoTooltip(
              message: "Connect any EVM-compatible wallet (like MetaMask, Trust Wallet) using WalletConnect.",
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (wp.isLoadingEVM)
          const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator()))
              .animate().fadeIn()
        else if (wp.isConnectedEVM)
          _buildConnectedWalletInfo(
            theme: theme,
            address: wp.connectedEVMAddress!,
            chainInfo: "Chain ID: ${wp.currentEVMChainId ?? 'N/A'}",
            onDisconnect: () => wp.disconnectEVMWallet(),
            walletTypeLabel: "EVM Wallet Connected",
            accentColor: AppColors.tertiaryAccent,
          ).animate().fadeIn(duration: 300.ms)
        else
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(FontAwesomeIcons.wallet, size: 18),
              label: const Text('Connect EVM Wallet'),
              onPressed: wp.isLoading ? null : () => wp.connectEVMWallet(context: context),
              style: theme.elevatedButtonTheme.style,
            ),
          ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2),
        if (wp.evmError != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: theme.colorScheme.error, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(wp.evmError!, style: TextStyle(color: theme.colorScheme.error, fontSize: 13))),
                TextButton(
                  onPressed: wp.clearEVMErrors,
                  child: const Text('OK'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    foregroundColor: theme.colorScheme.error
                  ),
                )
              ],
            ),
          ).animate().shakeX(amount: 4, duration: 300.ms),
        ],
      ],
    );
  }

  Widget _buildConnectedWalletInfo({
    required ThemeData theme,
    required String address,
    required String chainInfo,
    required VoidCallback onDisconnect,
    required String walletTypeLabel,
    Color? accentColor,
    Gradient? gradient,
  }) {
    final displayAddress = "${address.substring(0, 6)}...${address.substring(address.length - 4)}";
    final effectiveAccentColor = accentColor ?? theme.colorScheme.primary;
    
    BoxDecoration decoration;
    if (gradient != null) {
      decoration = BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
      );
    } else {
      decoration = BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: effectiveAccentColor, width: 1.5)
      );
    }

    return Container(
      padding: const EdgeInsets.all(1.5),
      decoration: decoration,
      child: Container(
        padding: const EdgeInsets.all(14.5),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(10.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FaIcon(FontAwesomeIcons.solidCircleCheck, color: gradient != null ? Colors.white : effectiveAccentColor, size: 16),
                const SizedBox(width: 8),
                Text(walletTypeLabel, style: theme.textTheme.titleSmall?.copyWith(color: gradient != null ? Colors.white : effectiveAccentColor, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Text("Address:", style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.7))),
            SelectableText(displayAddress, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, fontFamily: 'monospace')),
            if(chainInfo.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(chainInfo, style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.7))),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.link_off_rounded, size: 20),
                label: const Text('Disconnect'),
                onPressed: onDisconnect,
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                  side: BorderSide(color: theme.colorScheme.error.withOpacity(0.5)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
