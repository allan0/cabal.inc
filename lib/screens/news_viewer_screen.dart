// lib/screens/news_viewer_screen.dart
import 'package:cabal/models/coin_data_model.dart';
import 'package:cabal/models/news_article_model.dart';
import 'package:cabal/models/user_profile_model.dart';
import 'package:cabal/services/supabase_service.dart';
import 'package:cabal/widgets/diamond_mesh_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/repositories/coin_repository.dart';
import '../utils/app_colors.dart';
import 'login_screen.dart';

class NewsViewerScreen extends StatefulWidget {
  final NewsArticle article;
  final UserProfile? userProfile;

  const NewsViewerScreen({
    Key? key,
    required this.article,
    this.userProfile,
  }) : super(key: key);

  @override
  State<NewsViewerScreen> createState() => _NewsViewerScreenState();
}

class _NewsViewerScreenState extends State<NewsViewerScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  List<CoinData> _favoriteCoins = [];
  bool _isLoadingCoins = true;
  bool _isFavorited = false;
  bool _isTogglingFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorited = widget.userProfile?.favoritedNewsLinks.contains(widget.article.link) ?? false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFavoriteCoinsData();
    });
  }
  
  // --- FIX: Added logic to handle favoriting news articles ---
  Future<void> _toggleFavorite() async {
    if (widget.userProfile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please log in to save articles.")));
      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      return;
    }
    if (_isTogglingFavorite) return;
    
    setState(() {
      _isTogglingFavorite = true;
      _isFavorited = !_isFavorited;
    });

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      await _supabaseService.toggleFavoriteNews(widget.article.link);
      // You may want to refresh the user profile in a parent provider here
    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
      if (mounted) setState(() => _isFavorited = !_isFavorited); // Revert UI on failure
    } finally {
      if (mounted) setState(() => _isTogglingFavorite = false);
    }
  }

  Future<void> _loadFavoriteCoinsData() async {
    if (!mounted) return;
    if (widget.userProfile == null || widget.userProfile!.preferredCoinIds.isEmpty) {
      if (mounted) setState(() => _isLoadingCoins = false);
      return;
    }

    try {
      final coinRepo = Provider.of<CoinRepository>(context, listen: false);
      final allCoins = await coinRepo.getTopNCoinData(count: 250);
      final favs = allCoins.where((coin) => widget.userProfile!.preferredCoinIds.contains(coin.id)).toList();
      if (mounted) {
        setState(() {
          _favoriteCoins = favs;
          _isLoadingCoins = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading favorite coins for news viewer: $e");
      if (mounted) setState(() => _isLoadingCoins = false);
    }
  }

  Future<void> _launchUrl() async {
    final uri = Uri.tryParse(widget.article.link);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open article link: ${widget.article.link}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.article.source ?? 'News Article'),
        backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.85),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.shareNodes, size: 20),
            onPressed: () {
              Share.share(
                'Check out this article from Cabal: ${widget.article.title}\n\n${widget.article.link}',
                subject: widget.article.title,
              );
            },
            tooltip: "Share Article",
          ),
          IconButton(
            icon: _isTogglingFavorite
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5))
              : FaIcon(_isFavorited ? FontAwesomeIcons.solidBookmark : FontAwesomeIcons.bookmark, size: 20),
            onPressed: _isTogglingFavorite ? null : _toggleFavorite,
            tooltip: _isFavorited ? "Unsave Article" : "Save Article",
          ),
        ],
      ),
      body: DiamondMeshBackground(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(height: kToolbarHeight + MediaQuery.of(context).padding.top),
            if (_isLoadingCoins)
              const LinearProgressIndicator(),
            if (!_isLoadingCoins && _favoriteCoins.isNotEmpty)
              _buildFavoritesBar(theme),
            
            if (widget.article.imageUrl != null && widget.article.imageUrl!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.article.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.article.title,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Published on ${widget.article.pubDate != null ? DateFormat.yMMMd().add_jm().format(widget.article.pubDate!) : 'a recent date'}',
                    style: theme.textTheme.bodySmall,
                  ),
                  const Divider(height: 32),
                  Text(
                    widget.article.description ?? "No summary available.",
                    style: theme.textTheme.bodyLarge?.copyWith(fontSize: 18, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.open_in_new),
                      label: const Text("Read Full Article"),
                      onPressed: _launchUrl,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                   const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(0.5),
      ),
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _favoriteCoins.length,
        itemBuilder: (context, index) {
          final coin = _favoriteCoins[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Chip(
              avatar: CircleAvatar(backgroundImage: NetworkImage(coin.imageUrl)),
              label: Text(coin.symbol.toUpperCase()),
              side: BorderSide(color: theme.dividerColor),
            ).animate().fadeIn(delay: (100 * index).ms),
          );
        },
      ),
    );
  }
}
