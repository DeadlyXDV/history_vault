class EventModel {
  final String text;
  final int year;
  final String title;
  final String? thumbnailUrl;
  final String wikiUrl;
  final String category;

  EventModel({
    required this.text,
    required this.year,
    required this.title,
    this.thumbnailUrl,
    required this.wikiUrl,
    String? category,
  }) : category = category ?? _categorizeEvent(title, text);

  factory EventModel.fromJson(Map<String, dynamic> json) {
    final pages = json['pages'] as List<dynamic>? ?? [];
    final page = pages.isNotEmpty
        ? pages.first as Map<String, dynamic>
        : <String, dynamic>{};
    final thumbnail = page['thumbnail'] as Map<String, dynamic>?;
    final contentUrls = page['content_urls'] as Map<String, dynamic>?;
    final desktop = contentUrls?['desktop'] as Map<String, dynamic>?;

    final title = page['title'] as String? ?? '';
    final text = json['text'] as String? ?? '';

    return EventModel(
      text: text,
      year: json['year'] as int? ?? 0,
      title: title,
      thumbnailUrl: thumbnail?['source'] as String?,
      wikiUrl: desktop?['page'] as String? ?? '',
    );
  }

  static String _categorizeEvent(String title, String text) {
    if (title.isEmpty && text.isEmpty) return 'Event';

    final combined = '$title $text'.toLowerCase();

    // Check for Places
    if (combined.contains('city') ||
        combined.contains('country') ||
        combined.contains('town') ||
        combined.contains('island') ||
        combined.contains('mountain') ||
        combined.contains('river') ||
        combined.contains('battle') ||
        combined.contains('kingdom')) {
      return 'Place';
    }

    // Check for People
    if (combined.contains('born') ||
        combined.contains('died') ||
        combined.contains('president') ||
        combined.contains('king') ||
        combined.contains('queen') ||
        combined.contains('inventor') ||
        combined.contains('author') ||
        combined.contains('artist') ||
        combined.contains('politician') ||
        combined.contains('general') ||
        combined.contains('emperor') ||
        combined.contains('actress') ||
        combined.contains('actor')) {
      return 'Person';
    }

    // Check for Technology/Discovery
    if (combined.contains('invented') ||
        combined.contains('discovered') ||
        combined.contains('technology') ||
        combined.contains('invention') ||
        combined.contains('patent') ||
        combined.contains('launched') ||
        combined.contains('developed') ||
        combined.contains('founded')) {
      return 'Discovery';
    }

    // Default
    return 'Event';
  }
}
