class ArticleModel {
  final String title;
  final String extract;
  final String? thumbnailUrl;
  final String wikiUrl;

  ArticleModel({
    required this.title,
    required this.extract,
    this.thumbnailUrl,
    required this.wikiUrl,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    final thumbnail = json['thumbnail'] as Map<String, dynamic>?;
    final contentUrls = json['content_urls'] as Map<String, dynamic>?;
    final desktop = contentUrls?['desktop'] as Map<String, dynamic>?;

    return ArticleModel(
      title: json['title'] as String? ?? '',
      extract: json['extract'] as String? ?? '',
      thumbnailUrl: thumbnail?['source'] as String?,
      wikiUrl: desktop?['page'] as String? ?? json['wikiUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'extract': extract,
        'thumbnail': thumbnailUrl != null ? {'source': thumbnailUrl} : null,
        'content_urls': {
          'desktop': {'page': wikiUrl}
        },
      };
}
