class SearchResultModel {
  final String title;
  final String snippet;
  final int pageId;

  SearchResultModel({
    required this.title,
    required this.snippet,
    required this.pageId,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      title: json['title'] as String? ?? '',
      snippet: (json['snippet'] as String? ?? '').replaceAll(RegExp(r'<[^>]+>'), ''),
      pageId: json['pageid'] as int? ?? 0,
    );
  }
}
