// lib/services/nft_service.dart
import 'dart:convert';
import 'package:cabal/screens/user_wallet_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

class NftService {
  final Dio _dio = Dio();
  late final String? _pinataApiKey;
  late final String? _pinataApiSecret;

  NftService() {
    // UPDATED: Read API keys from build environment on web, .env on mobile
    _pinataApiKey = kIsWeb 
      ? const String.fromEnvironment('PINATA_API_KEY') 
      : dotenv.env['PINATA_API_KEY'];
    _pinataApiSecret = kIsWeb 
      ? const String.fromEnvironment('PINATA_API_SECRET') 
      : dotenv.env['PINATA_API_SECRET'];

    if (_pinataApiKey == null || _pinataApiKey!.isEmpty || _pinataApiSecret == null || _pinataApiSecret!.isEmpty) {
      debugPrint("NFTService WARNING: Pinata API keys not found in environment. IPFS uploads will fail.");
    }
  }

  // ... (Rest of the file remains the same)
  Future<String> uploadToIpfs({
    required XFile imageFile,
    required String name,
    required String description,
    required Map<String, dynamic> attributes,
  }) async {
    if (_pinataApiKey == null || _pinataApiSecret == null) {
      throw Exception("Pinata API keys are not configured.");
    }
    
    debugPrint("NFTService: Starting real upload to IPFS via Pinata...");

    final imageCid = await _uploadFileToPinata(imageFile);
    debugPrint("  - Image uploaded successfully. CID: $imageCid");

    final metadata = {
      "name": name,
      "description": description,
      "image": "ipfs://$imageCid",
      "attributes": attributes.entries.map((e) => {"trait_type": e.key, "value": e.value.toString()}).toList(),
    };
    
    final metadataCid = await _uploadJsonToPinata(metadata, name);
    debugPrint("  - Metadata JSON uploaded successfully. CID: $metadataCid");

    final tokenUri = "ipfs://$metadataCid";
    debugPrint("NFTService: IPFS upload complete. Final Token URI: $tokenUri");

    return tokenUri;
  }

  Future<String> _uploadFileToPinata(XFile file) async {
    const url = 'https://api.pinata.cloud/pinning/pinFileToIPFS';
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: file.name),
    });

    final response = await _dio.post(
      url,
      data: formData,
      options: Options(headers: {
        'pinata_api_key': _pinataApiKey,
        'pinata_secret_api_key': _pinataApiSecret,
      }),
    );

    if (response.statusCode == 200) {
      return response.data['IpfsHash'];
    } else {
      throw Exception('Failed to upload file to Pinata: ${response.data}');
    }
  }

  Future<String> _uploadJsonToPinata(Map<String, dynamic> jsonData, String name) async {
    const url = 'https://api.pinata.cloud/pinning/pinJSONToIPFS';
    final data = {
      'pinataMetadata': {'name': '${name.replaceAll(' ', '_')}_metadata.json'},
      'pinataContent': jsonData,
    };
    
    final response = await _dio.post(
      url,
      data: data,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'pinata_api_key': _pinataApiKey,
        'pinata_secret_api_key': _pinataApiSecret,
      }),
    );
    
     if (response.statusCode == 200) {
      return response.data['IpfsHash'];
    } else {
      throw Exception('Failed to upload JSON to Pinata: ${response.data}');
    }
  }

  Future<List<UserNft>> fetchUserNfts(String ownerAddress) async {
    debugPrint("NFTService: Simulating fetch of NFTs for address $ownerAddress");
    await Future.delayed(const Duration(milliseconds: 1500));
    final sepoliaAchievementsAddress = kIsWeb ? const String.fromEnvironment('SEPOLIA_CABAL_ACHIEVEMENTS_ADDRESS') : dotenv.env['SEPOLIA_CABAL_ACHIEVEMENTS_ADDRESS'] ?? '';
    final sepoliaDeedAddress = kIsWeb ? const String.fromEnvironment('SEPOLIA_REAL_ESTATE_DEED_ADDRESS') : dotenv.env['SEPOLIA_REAL_ESTATE_DEED_ADDRESS'] ?? '';

    return [
      UserNft(
        name: "First Quest Conqueror",
        collectionName: "Cabal Achievements",
        imageUrl: "https://ipfs.io/ipfs/bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi",
        contractAddress: sepoliaAchievementsAddress,
        tokenId: 1,
      ),
      UserNft(
        name: "Deed: 123 Genesis Plaza",
        collectionName: "Cabal Real Estate",
        imageUrl: "https://ipfs.io/ipfs/bafybeicg2tbafrd5l3gqwsd6vhjw2vweutw2ttjwgxgvaztzfmsn27qgpm",
        contractAddress: sepoliaDeedAddress,
        tokenId: 42,
      ),
    ];
  }
}
