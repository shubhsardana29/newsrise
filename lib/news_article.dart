import 'package:uuid/uuid.dart';

class NewsArticle {
  final String? sourceId;
  final String? sourceName;
  final String? author;
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;
  bool isSaved;
  String? id;

  NewsArticle({
    this.sourceId,
    this.sourceName,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
    this.isSaved = false,
    this.id,
  });

  factory NewsArticle.fromMap(Map<String, dynamic> map) {
    final String id = Uuid().v4(); // Generate a unique ID for the article
    return NewsArticle(
      id: id,
      sourceId: map['source']['id'] as String?,
      sourceName: map['source']['name'] as String?,
      author: map['author'] as String?,
      title: map['title'] as String?,
      description: map['description'] as String?,
      url: map['url'] as String?,
      urlToImage: map['urlToImage'] as String?,
      publishedAt: map['publishedAt'] as String?,
      content: map['content'] as String?,
    );
  }
}
