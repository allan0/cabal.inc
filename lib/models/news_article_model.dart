// lib/models/news_article_model.dart

class NewsArticle {
  final String title;
  final String link;
  final DateTime? pubDate;
  final String? source;
  final String? description;
  final String? imageUrl; // Optional image URL from the feed

  NewsArticle({
    required this.title,
    required this.link,
    this.pubDate,
    this.source,
    this.description,
    this.imageUrl,
  });
}
