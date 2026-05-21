import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/nft_listing_model.dart';
import '../services/supabase_service.dart';
import '../widgets/diamond_mesh_background.dart';
import '../widgets/nft_listing_card.dart';
import '../utils/app_colors.dart';
import 'nft_detail_screen.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final SupabaseService _supabase = SupabaseService();
  List<NftListing> _listings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchListings();
  }

  Future<void> _fetchListings() async {
    final data = await _supabase.getNftListings();
    setState(() {
      _listings = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MARKETPLACE", style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: DiamondMeshBackground(
        child: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : RefreshIndicator(
              onRefresh: _fetchListings,
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: _listings.length,
                itemBuilder: (context, index) {
                  final item = _listings[index];
                  return NftListingCard(
                    listing: item,
                    onTap: () => Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (_) => NftDetailScreen(listing: item))
                    ),
                  ).animate().fadeIn(delay: (index * 50).ms).scale();
                },
              ),
            ),
      ),
    );
  }
}
