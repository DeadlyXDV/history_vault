import 'package:flutter_test/flutter_test.dart';
import 'package:history_vault/services/wikipedia_service.dart';
import 'package:history_vault/models/event_model.dart';
import 'package:history_vault/models/search_result_model.dart';
import 'package:history_vault/models/article_model.dart';

void main() {
  group('WikipediaService.parseOnThisDay', () {
    test('parses events from response body', () {
      final body = '''
{
  "events": [
    {
      "text": "The Berlin Wall fell",
      "year": 1989,
      "pages": [
        {
          "title": "Berlin Wall",
          "content_urls": {"desktop": {"page": "https://en.wikipedia.org/wiki/Berlin_Wall"}}
        }
      ]
    }
  ]
}
''';
      final events = WikipediaService.parseOnThisDay(body);
      expect(events.length, 1);
      expect(events.first, isA<EventModel>());
      expect(events.first.text, 'The Berlin Wall fell');
    });
  });

  group('WikipediaService.parseSearch', () {
    test('parses search results from response body', () {
      final body = '''
{
  "query": {
    "search": [
      {"title": "World War II", "snippet": "Global conflict", "pageid": 1}
    ]
  }
}
''';
      final results = WikipediaService.parseSearch(body);
      expect(results.length, 1);
      expect(results.first, isA<SearchResultModel>());
      expect(results.first.title, 'World War II');
    });
  });

  group('WikipediaService.parsePageSummary', () {
    test('parses article from response body', () {
      final body = '''
{
  "title": "Berlin Wall",
  "extract": "A concrete barrier",
  "content_urls": {"desktop": {"page": "https://en.wikipedia.org/wiki/Berlin_Wall"}}
}
''';
      final article = WikipediaService.parsePageSummary(body);
      expect(article, isA<ArticleModel>());
      expect(article.title, 'Berlin Wall');
      expect(article.extract, 'A concrete barrier');
    });
  });
}
