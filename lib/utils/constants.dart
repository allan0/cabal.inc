// lib/utils/constants.dart
import 'package:flutter/foundation.dart' show debugPrint; 

enum QuestType {
  custom,
  twitterFollow,
  twitterRetweet,
  twitterLike,
  discordJoin,
  telegramChannelJoin,
  telegramGroupJoin,
  youtubeSubscribe,
  youtubeLikeVideo,
  instagramFollow,
  connectWalletEth,
  connectWalletBase,
  newsletterSubscription,
  websiteVisit,
  evmTransaction,
  evmSignMessage,
  manualVerification,
  // --- WEB3 UPDATE: New On-Chain Quest Types ---
  evmSwapToken,
  evmHoldToken,
  evmMintNft,
  // --- Solana Placeholders ---
  // solanaTransaction,
  // solanaSignMessage,
}

// Ensures that if 'type' is null (e.g. from bad data), it defaults to 'custom'
// and won't cause a null error when questTypeToString is called.
String questTypeToString(QuestType? type) { 
  if (type == null) {
    debugPrint("constants.dart: questTypeToString received null type, returning 'custom' as fallback.");
    return 'custom'; 
  }
  return type.toString().split('.').last;
}

// Ensures that if 'typeStr' is null or an unrecognized string, it defaults to QuestType.custom.
QuestType questTypeFromString(String? typeStr) { 
  if (typeStr == null || typeStr.trim().isEmpty) {
    debugPrint("constants.dart: questTypeFromString received null or empty typeStr, defaulting to custom.");
    return QuestType.custom;
  }
  
  final normalizedTypeStr = typeStr.toLowerCase().replaceAll('_', '');

  switch (normalizedTypeStr) {
    case 'custom': return QuestType.custom;
    case 'twitterfollow': return QuestType.twitterFollow;
    case 'twitterretweet': return QuestType.twitterRetweet;
    case 'twitterlike': return QuestType.twitterLike;
    case 'discordjoin': return QuestType.discordJoin;
    case 'telegramchanneljoin': return QuestType.telegramChannelJoin;
    case 'telegramgroupjoin': return QuestType.telegramGroupJoin;
    case 'youtubesubscribe': return QuestType.youtubeSubscribe;
    case 'youtubelikevideo': return QuestType.youtubeLikeVideo;
    case 'instagramfollow': return QuestType.instagramFollow;
    case 'connectwalleteth': return QuestType.connectWalletEth;
    case 'connectwalletbase': return QuestType.connectWalletBase;
    case 'newslettersubscription': return QuestType.newsletterSubscription;
    case 'websitevisit': return QuestType.websiteVisit;
    case 'evmtransaction': return QuestType.evmTransaction;
    case 'evmsignmessage': return QuestType.evmSignMessage;
    case 'manualverification': return QuestType.manualVerification;
    // --- WEB3 UPDATE: Recognize new types from DB ---
    case 'evmswaptoken': return QuestType.evmSwapToken;
    case 'evmholdtoken': return QuestType.evmHoldToken;
    case 'evmmintnft': return QuestType.evmMintNft;
    // --- Solana Placeholders ---
    // case 'solanatransaction': return QuestType.solanaTransaction;
    // case 'solanasignmessage': return QuestType.solanaSignMessage;
    default:
      // Fallback for original underscore versions if any data still uses them
      // This second switch is only hit if the normalized version didn't match.
      // It's less likely to be needed if data is clean or new.
      debugPrint("constants.dart: Unknown quest type string '$typeStr' (normalized: '$normalizedTypeStr'), attempting original underscore or defaulting to custom.");
      switch (typeStr.toLowerCase()) { // Check original string with underscores
        case 'twitter_follow': return QuestType.twitterFollow;
        case 'twitter_retweet': return QuestType.twitterRetweet;
        // ... add other underscore fallbacks if necessary ...
        default:
          debugPrint("constants.dart: Quest type '$typeStr' (normalized: '$normalizedTypeStr') completely unrecognized, defaulting to custom.");
          return QuestType.custom;
      }
  }
}

// Example levels and XP thresholds
const Map<int, int> xpForLevel = {
  1: 0,
  2: 100,
  3: 250,
  4: 500,
  5: 1000,
  // Add more levels as needed
};

int calculateLevel(int totalXp) {
  int currentLevel = 1;
  for (var entry in xpForLevel.entries) {
    if (totalXp >= entry.value) {
      currentLevel = entry.key;
    } else {
      break;
    }
  }
  return currentLevel;
}

int getXpForNextLevel(int currentLevel) {
  return xpForLevel[currentLevel + 1] ?? 999999999;
}

int getXpForCurrentLevelStart(int currentLevel) {
  return xpForLevel[currentLevel] ?? 0;
}
