// lib/features/onboarding/application/onboarding_provider.dart
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart'; // For list equality check
import '../../../data/repositories/coin_repository.dart';
import '../../../models/coin_data_model.dart';
import '../../../models/user_profile_model.dart';
import '../../../services/supabase_service.dart';

// Define some example interests/categories for onboarding
// These should ideally come from a backend or constants file in a real app.
const List<String> availableInterests = [
  'DeFi', 'NFTs', 'Gaming', 'Metaverse', 'Layer 1s', 'Layer 2s',
  'Web3 Social', 'Decentralized Identity', 'Yield Farming', 'DEXs',
  'DAOs', 'Wallets', 'Security', 'Scalability', 'Privacy',
];

class OnboardingProvider with ChangeNotifier {
  final CoinRepository _coinRepository;
  final SupabaseService _supabaseService;

  // <--- ADD THIS PUBLIC GETTER!
  SupabaseService get supabaseService => _supabaseService; 
  // --- END OF ADDITION ---

  List<CoinData> _availableCoins = [];
  bool _isLoadingCoins = false;
  String? _coinLoadError;

  List<String> _selectedPreferredCoinIds = [];
  List<String> _selectedInterests = [];
  bool _isSavingPreferences = false;
  String? _saveError;

  OnboardingProvider(this._coinRepository, this._supabaseService);

  // Getters
  List<CoinData> get availableCoins => _availableCoins;
  bool get isLoadingCoins => _isLoadingCoins;
  String? get coinLoadError => _coinLoadError;

  List<String> get selectedPreferredCoinIds => _selectedPreferredCoinIds;
  List<String> get selectedInterests => _selectedInterests;
  bool get isSavingPreferences => _isSavingPreferences;
  String? get saveError => _saveError;

  // Initialize selected values from user profile if available
  void initializeFromUserProfile(UserProfile? userProfile) {
    if (userProfile != null) {
      _selectedPreferredCoinIds = List.from(userProfile.preferredCoinIds);
      _selectedInterests = List.from(userProfile.interests);
      notifyListeners();
      debugPrint("OnboardingProvider: Initialized from user profile. Coins: ${_selectedPreferredCoinIds.length}, Interests: ${_selectedInterests.length}");
    }
  }

  // Fetch Coins
  Future<void> fetchAvailableCoins() async {
    if (_isLoadingCoins) return;
    _isLoadingCoins = true;
    _coinLoadError = null;
    notifyListeners();

    try {
      _availableCoins = await _coinRepository.getTopNCoinData(count: 200); // Fetch top 200 coins
      debugPrint("OnboardingProvider: Fetched ${_availableCoins.length} coins.");
    } catch (e) {
      _coinLoadError = 'Failed to load coins: ${e.toString()}';
      debugPrint("OnboardingProvider: Error fetching coins: $e");
    } finally {
      _isLoadingCoins = false;
      notifyListeners();
    }
  }

  // Toggle Coin Selection
  void toggleCoinSelection(String coinId) {
    if (_selectedPreferredCoinIds.contains(coinId)) {
      _selectedPreferredCoinIds.remove(coinId);
    } else {
      if (_selectedPreferredCoinIds.length < 10) { // Limit to 10 favorite coins
        _selectedPreferredCoinIds.add(coinId);
      } else {
        _coinLoadError = 'You can select up to 10 favorite coins.'; // Reuse error for feedback
      }
    }
    notifyListeners();
    _clearErrorAfterDelay();
  }

  // Toggle Interest Selection
  void toggleInterestSelection(String interest) {
    if (_selectedInterests.contains(interest)) {
      _selectedInterests.remove(interest);
    } else {
      if (_selectedInterests.length < 5) { // Limit to 5 interests
        _selectedInterests.add(interest);
      } else {
        _coinLoadError = 'You can select up to 5 interests.'; // Reuse error for feedback
      }
    }
    notifyListeners();
    _clearErrorAfterDelay();
  }

  // Save Preferences to Supabase
  Future<bool> savePreferences(String userId) async {
    if (_isSavingPreferences) return false;
    _isSavingPreferences = true;
    _saveError = null;
    notifyListeners();

    try {
      if (_selectedPreferredCoinIds.isEmpty || _selectedInterests.isEmpty) {
        throw Exception("Please select at least one coin and one interest.");
      }

      final Map<String, dynamic> updateData = {
        'preferred_coin_ids': _selectedPreferredCoinIds,
        'interests': _selectedInterests,
      };
      await _supabaseService.updateUserProfile(updateData);
      debugPrint("OnboardingProvider: Saved preferences for user $userId. Coins: $_selectedPreferredCoinIds, Interests: $_selectedInterests");
      return true;
    } catch (e) {
      _saveError = 'Failed to save preferences: ${e.toString()}';
      debugPrint("OnboardingProvider: Error saving preferences: $e");
      return false;
    } finally {
      _isSavingPreferences = false;
      notifyListeners();
    }
  }

  void _clearErrorAfterDelay() {
    Future.delayed(const Duration(seconds: 3), () {
      if (coinLoadError != null && _isLoadingCoins == false) {
        _coinLoadError = null;
        notifyListeners();
      }
      if (saveError != null && _isSavingPreferences == false) {
        _saveError = null;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    debugPrint("OnboardingProvider disposed.");
    super.dispose();
  }
}
