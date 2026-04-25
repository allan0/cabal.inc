// lib/services/news_service.dart
import 'package:xml/xml.dart' as xml;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/news_article_model.dart';

class NewsService {
  final String _functionName = 'news-proxy';

  // The constructor is no longer needed as the Supabase client handles auth.

  Future<List<NewsArticle>> fetchNews() async {
    try {
      debugPrint("NewsService: Invoking Supabase Edge Function: $_functionName");

      final response = await Supabase.instance.client.functions.invoke(
        _functionName,
      );

      if (response.status == 200) {
        final String feedText = response.data as String;
        final document = xml.XmlDocument.parse(feedText);
        final items = document.findAllElements('item');

        final articles = items.map((node) {
          final title = node.findElements('title').first.innerText;
          final link = node.findElements('link').first.innerText;
          final pubDateStr = node.findElements('pubDate').firstOrNull?.innerText;
          final descriptionHtml = node.findElements('description').firstOrNull?.innerText ?? '';
          final contentEncoded = node.findElements('content:encoded').firstOrNull?.innerText ?? '';
          final source = document.findAllElements('channel').firstOrNull?.findElements('title').firstOrNull?.innerText ?? 'The Defiant';

          DateTime? pubDate;
          if (pubDateStr != null) {
            try {
              // Using a more robust date format parser that handles various RFC 822 formats
              pubDate = DateFormat("EEE, dd MMM yyyy HH:mm:ss Z").parse(pubDateStr);
            } catch (e) {
               try {
                 pubDate = DateFormat("EEE, dd MMM yy HH:mm:ss Z").parse(pubDateStr);
               } catch (e2) {
                 debugPrint("NewsService: Could not parse date '$pubDateStr'. Error: $e2");
               }
            }
          }

          String? imageUrl;
          final imgRegex = RegExp(r'<img[^>]+src="([^">]+)"');
          final match = imgRegex.firstMatch(contentEncoded);
          if (match != null && match.groupCount > 0) {
            imageUrl = match.group(1);
          }

          return NewsArticle(
            title: title,
            link: link,
            pubDate: pubDate,
            source: source,
            description: _stripHtml(descriptionHtml),
            imageUrl: imageUrl,
          );
        }).toList();

        // --- FIX: Sort by publication date, newest first. Handle null dates gracefully. ---
        articles.sort((a, b) => (b.pubDate ?? DateTime(0)).compareTo(a.pubDate ?? DateTime(0)));

        debugPrint("NewsService: Successfully fetched and parsed ${articles.length} articles via Edge Function.");
        return articles;
      } else {
        debugPrint("NewsService: Edge Function returned non-200 status: ${response.status}. Body: ${response.data}");
        throw Exception('Failed to load news feed via Edge Function: ${response.data}');
      }
    } catch (e) {
      debugPrint("NewsService: Error invoking Edge Function: $e");
      rethrow;
    }
  }

  String? _stripHtml(String? htmlString) {
    if (htmlString == null) return null;
    final RegExp htmlRegExp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(htmlRegExp, '').replaceAll('<![CDATA[', '').replaceAll(']]>', '').trim();
  }
}
