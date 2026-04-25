// lib/screens/xp_balance_screen.dart
import 'package:cabal/models/user_profile_model.dart';
import '../services/supabase_service.dart'; // <-- CORRECTED IMPORT
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../utils/app_colors.dart';
import '../widgets/diamond_mesh_background.dart';

class XpBalanceScreen extends StatefulWidget {
  final UserProfile initialProfile;
  const XpBalanceScreen({Key? key, required this.initialProfile}) : super(key: key);

  @override
  State<XpBalanceScreen> createState() => _XpBalanceScreenState();
}

class _XpBalanceScreenState extends State<XpBalanceScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  final TextEditingController _xpController = TextEditingController();
  
  late UserProfile _userProfile;
  double _cabalBalance = 0.0;
  double _usdtBalance = 0.0;
  bool _isLoading = true;
  bool _isConverting = false;

  final double _conversionRate = 0.01; // 1 XP = 0.01 $CAB

  @override
  void initState() {
    super.initState();
    _userProfile = widget.initialProfile;
    _loadBalances();
  }

  Future<void> _loadBalances() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final balances = await _supabaseService.getUserBalances(_userProfile.id);
      if (mounted) {
        setState(() {
          _cabalBalance = (balances['cabal_token_balance'] as num).toDouble();
          _usdtBalance = (balances['usdt_balance'] as num).toDouble();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading balances: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error loading balances: $e")));
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _convertXp() async {
    if (_isConverting) return;
    final amountToConvert = int.tryParse(_xpController.text);
    if (amountToConvert == null || amountToConvert <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter a valid amount of XP to convert.")));
      return;
    }

    setState(() => _isConverting = true);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final result = await _supabaseService.convertXp(amountToConvert);
      if (result['success'] == true) {
        scaffoldMessenger.showSnackBar(SnackBar(content: Text(result['message']), backgroundColor: AppColors.success));
        // Update state with new values from the backend
        setState(() {
          _userProfile.totalXp = (result['new_xp_total'] as num).toInt();
          _cabalBalance = (result['new_cabal_balance'] as num).toDouble();
          _xpController.clear();
        });
      } else {
        throw Exception(result['message']);
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Conversion failed: $e"), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isConverting = false);
    }
  }

  @override
  void dispose() {
    _xpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberFormat = NumberFormat.decimalPattern();
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final xpAmount = int.tryParse(_xpController.text) ?? 0;
    final cabAmount = xpAmount * _conversionRate;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Balances & Conversion"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: DiamondMeshBackground(
        child: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.only(
                top: kToolbarHeight + MediaQuery.of(context).padding.top + 20,
                left: 16, right: 16, bottom: 40
              ),
              children: [
                _buildBalanceCard(
                  theme: theme,
                  icon: FontAwesomeIcons.star,
                  title: "XP Balance",
                  value: numberFormat.format(_userProfile.totalXp),
                  color: AppColors.gold,
                ),
                const SizedBox(height: 16),
                _buildBalanceCard(
                  theme: theme,
                  icon: FontAwesomeIcons.coins,
                  title: "\$CAB Token Balance",
                  value: numberFormat.format(_cabalBalance),
                  color: AppColors.primaryAccent,
                ),
                const SizedBox(height: 16),
                _buildBalanceCard(
                  theme: theme,
                  icon: FontAwesomeIcons.dollarSign,
                  title: "USDT Balance",
                  value: currencyFormat.format(_usdtBalance),
                  color: AppColors.success,
                  isWithdraw: true,
                ),
                const SizedBox(height: 24),
                _buildConversionCard(theme, numberFormat, xpAmount, cabAmount),
              ],
            ),
      ),
    );
  }

  Widget _buildBalanceCard({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    bool isWithdraw = false,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            FaIcon(icon, size: 28, color: color),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodyMedium),
                Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            if (isWithdraw) ...[
              const Spacer(),
              OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Withdrawal functionality coming soon!")));
                },
                child: const Text("Withdraw"),
              )
            ]
          ],
        ),
      ),
    ).animate().fadeIn().slideX(begin: -0.2);
  }

  Widget _buildConversionCard(ThemeData theme, NumberFormat numberFormat, int xpAmount, double cabAmount) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Convert XP to \$CAB", style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text("Rate: 1 XP = $_conversionRate \$CAB", style: theme.textTheme.bodySmall),
            const SizedBox(height: 16),
            TextField(
              controller: _xpController,
              decoration: InputDecoration(
                labelText: 'XP Amount to Convert',
                hintText: 'e.g., 1000',
                suffixText: 'Max: ${numberFormat.format(_userProfile.totalXp)}',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  const FaIcon(FontAwesomeIcons.arrowDown, size: 20),
                  const SizedBox(height: 8),
                  Text(
                    'You will receive:',
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    '${numberFormat.format(cabAmount)} \$CAB',
                    style: theme.textTheme.headlineMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isConverting ? null : _convertXp,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: _isConverting 
                  ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white))
                  : const Text('Convert Now'),
              ),
            )
          ],
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.2);
  }
}
