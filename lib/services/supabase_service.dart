import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile_model.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  User? get currentUser => _client.auth.currentUser;
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// Fetches a profile or creates one if it doesn't exist (Lazy provisioning)
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final data = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (data == null) return null;
      return UserProfile.fromSupabase(data);
    } catch (e) {
      debugPrint("SupabaseService: Error fetching profile: $e");
      return null;
    }
  }

  /// Links a blockchain wallet to the Supabase Auth identity
  Future<void> syncWalletToProfile(String address, String chain) async {
    final user = currentUser;
    if (user == null) return;

    final profile = await getUserProfile(user.id);
    final Map<String, dynamic> currentWallets = 
        profile != null ? Map<String, dynamic>.from(profile.connectedWallets) : {};
    
    currentWallets[chain.toLowerCase()] = address;

    await _client.from('profiles').upsert({
      'id': user.id,
      'connected_wallets': currentWallets,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> signOutUser() async => await _client.auth.signOut();
}
