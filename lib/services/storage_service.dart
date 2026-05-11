// lib/services/storage_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class StorageService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<String?> uploadImage(XFile file, String bucket, String folder) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
      final path = '$folder/$fileName';

      await supabase.storage.from(bucket).upload(path, File(file.path));

      final publicUrl = supabase.storage.from(bucket).getPublicUrl(path);
      return publicUrl;
    } catch (e) {
      print("Storage upload error: $e");
      return null;
    }
  }

  // Profile Picture Upload
  Future<String?> uploadProfilePicture(XFile file) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return null;
    return await uploadImage(file, 'profile-pictures', userId);
  }

  // Cabal Logo
  Future<String?> uploadCabalLogo(XFile file, String cabalId) async {
    return await uploadImage(file, 'cabal-logos', cabalId);
  }
}
