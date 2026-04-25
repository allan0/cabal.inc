// lib/widgets/coin_chart_widget.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../core/services/coingecko_service.dart';
import '../features/wallet/application/wallet_provider.dart';
import 'shimmer_widget.dart';
import '../utils/app_colors.dart';

class CoinChartWidget extends StatefulWidget {
  final String coinId;
  final VoidCallback onClose;

  const CoinChartWidget({
    Key? key,
    required this.coinId,
    required this.onClose,
  }) : super(key: key);

  @override
  State<CoinChartWidget> createState() => _CoinChartWidgetState();
}

class _CoinChartWidgetState extends State<CoinChartWidget> {
  final CoinGeckoService _coinGeckoService = CoinGeckoService();
  Future<List<FlSpot>>? _chartDataFuture;
  Timer? _priceUpdateTimer;
  double _currentPrice = 0.0;
  double _initialPrice = 0.0;
  bool _isPriceUp = true;
  final _random = Random();

  final List<String> _exchanges = ["Binance", "Coinbase", "Kraken", "KuCoin"];

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }
  
  void _fetchInitialData() {
    _chartDataFuture = _coinGeckoService.getCoinChartData(widget.coinId).then((data) {
      if (data.isNotEmpty) {
        if (mounted) {
          final firstPrice = data.first[1] as double;
          final lastPrice = data.last[1] as double;
          setState(() {
            _currentPrice = lastPrice;
            _initialPrice = firstPrice;
            _startPriceUpdates();
          });
        }
        return data.map((point) => FlSpot(point[0].toDouble(), point[1].toDouble())).toList();
      }
      return [];
    });
  }

  void _startPriceUpdates() {
    _priceUpdateTimer?.cancel();
    _priceUpdateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        double change = _currentPrice * (_random.nextDouble() * 0.001 - 0.0005);
        _currentPrice += change;
        _isPriceUp = change >= 0;
      });
    });
  }

  @override
  void dispose() {
    _priceUpdateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final walletProvider = context.watch<WalletProvider>();
    final priceFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    final overallTrendUp = _currentPrice >= _initialPrice;

    return Card(
      elevation: 4,
      color: theme.cardColor.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.coinId.toUpperCase()} Chart (14d)",
                  style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary),
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.xmark, size: 18),
                  onPressed: widget.onClose,
                  tooltip: "Close Chart",
                )
              ],
            ),
            const Divider(height: 16),
            Row(
              children: [
                Text(priceFormat.format(_currentPrice), style: theme.textTheme.headlineSmall),
                const SizedBox(width: 8),
                FaIcon(
                  _isPriceUp ? FontAwesomeIcons.arrowUp : FontAwesomeIcons.arrowDown,
                  color: _isPriceUp ? AppColors.success : AppColors.error,
                  size: 16,
                )
              ],
            ).animate(key: ValueKey(_currentPrice)).fadeIn(duration: 300.ms),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<FlSpot>>(
                future: _chartDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: ShimmerWidget.rectangular(height: 150));
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}", style: TextStyle(color: theme.colorScheme.error)));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No chart data."));
                  }
                  
                  final spots = snapshot.data!;
                  
                  return Column(
                    children: [
                      Expanded(
                        child: LineChart(
                          LineChartData(
                            gridData: const FlGridData(show: false),
                            titlesData: const FlTitlesData(show: false),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: spots,
                                isCurved: true,
                                color: overallTrendUp ? AppColors.success : AppColors.error,
                                barWidth: 2.5,
                                isStrokeCapRound: true,
                                dotData: const FlDotData(show: false),
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: [
                                      (overallTrendUp ? AppColors.success : AppColors.error).withOpacity(0.3),
                                      (overallTrendUp ? AppColors.success : AppColors.error).withOpacity(0.0),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ],
                            lineTouchData: LineTouchData(
                              touchTooltipData: LineTouchTooltipData(
                                getTooltipColor: (spot) => AppColors.darkGrey.withOpacity(0.8),
                                getTooltipItems: (touchedSpots) {
                                  return touchedSpots.map((spot) {
                                    return LineTooltipItem(
                                      '${priceFormat.format(spot.y)}\n',
                                      TextStyle(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold),
                                      children: [
                                        TextSpan(
                                          text: DateFormat('MMM d, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(spot.x.toInt())),
                                          style: TextStyle(color: theme.colorScheme.onPrimary.withOpacity(0.8), fontSize: 12),
                                        ),
                                      ],
                                    );
                                  }).toList();
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Divider(height: 24),
                      Text("Available On", style: theme.textTheme.titleSmall),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        alignment: WrapAlignment.center,
                        children: _exchanges.map((ex) => Chip(label: Text(ex))).toList(),
                      ),
                      const SizedBox(height: 16),
                      walletProvider.isConnectedEVM
                        ? ElevatedButton.icon(
                            onPressed: () {},
                            icon: const FaIcon(FontAwesomeIcons.rightLeft, size: 16),
                            label: const Text("Buy / Trade Now"),
                          )
                        : ElevatedButton.icon(
                            onPressed: () => walletProvider.connectEVMWallet(context: context),
                            icon: const FaIcon(FontAwesomeIcons.wallet, size: 16),
                            label: const Text("Connect Wallet to Trade"),
                          ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
