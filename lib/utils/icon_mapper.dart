// lib/utils/icon_mapper.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// No Supabase import needed if not using Supabase types.

IconData getIconFromName(String? iconName) {
  if (iconName == null) return FontAwesomeIcons.questionCircle;
  switch (iconName.toLowerCase()) {
    // Social Media
    case 'twitter':
    case 'x':
      return FontAwesomeIcons.twitter; // Or .xing if specific
    case 'discord':
      return FontAwesomeIcons.discord;
    case 'telegram':
      return FontAwesomeIcons.telegram;
    case 'youtube':
      return FontAwesomeIcons.youtube;
    case 'instagram':
      return FontAwesomeIcons.instagram;

    // Web & Info
    case 'website':
    case 'globe':
      return FontAwesomeIcons.globe;
    case 'readme':
    case 'book':
    case 'article':
      return FontAwesomeIcons.bookOpenReader;
    case 'envelope':
    case 'email':
    case 'newsletter':
      return FontAwesomeIcons.solidEnvelope;
    case 'link':
      return FontAwesomeIcons.link;
    case 'survey':
      return FontAwesomeIcons.squarePollVertical;
    case 'quiz':
      return FontAwesomeIcons.clipboardQuestion;

    // Wallet & Blockchain
    case 'wallet':
    case 'ethereum': // EVM generic
    case 'base':     // EVM generic
    // case 'solana': // Removed
      return FontAwesomeIcons.wallet;

    // Quest States & General
    case 'onboarding':
      return FontAwesomeIcons.playCircle;
    case 'challenge':
    case 'trophy': // For achievement icon consistency
      return FontAwesomeIcons.trophy;
    case 'locked':
      return FontAwesomeIcons.lock;
    case 'unlocked':
      return FontAwesomeIcons.lockOpen;
    case 'xp':
    case 'star': // For achievement icon consistency
        return FontAwesomeIcons.star;
    case 'manualverification': // Icon for manual verification tasks
    case 'upload':
    case 'submit':
        return FontAwesomeIcons.arrowUpFromBracket;
    case 'pending':
        return FontAwesomeIcons.hourglassHalf;
    case 'completed':
        return FontAwesomeIcons.solidCircleCheck;


    default:
      debugPrint("icon_mapper.dart: Unknown icon name '$iconName', defaulting to solidStar.");
      return FontAwesomeIcons.solidStar; // A generic fallback
  }
}
