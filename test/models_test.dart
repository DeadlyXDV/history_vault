import 'package:flutter_test/flutter_test.dart';
import 'package:history_vault/models/event_model.dart';
import 'package:history_vault/models/search_result_model.dart';
import 'package:history_vault/models/article_model.dart';

void main() {
  group('EventModel', () {
    test('fromJson parses correctly', () {
      final json = {
        'text': 'The Berlin Wall fell',
        'year': 1989,
        'pages': [
          {
            'title': 'Berlin Wall',
            'thumbnail': {'source': 'https://example.com/img.jpg'},
            'content_urls': {'desktop': {'page': 'https://en.wikipedia.org/wiki/Berlin_Wall'}},
          }
        ],
      };
      final event = EventModel.fromJson(json);
      expect(event.text, 'The Berlin Wall fell');
      expect(event.year, 1989);
      expect(event.title, 'Berlin Wall');
      expect(event.thumbnailUrl, 'https://example.com/img.jpg');
    });

    test('fromJson handles missing thumbnail', () {
      final json = {
        'text': 'Some event',
        'year': 1900,
        'pages': [
          {
            'title': 'Some Page',
            'content_urls': {'desktop': {'page': 'https://en.wikipedia.org/wiki/Some_Page'}},
          }
        ],
      };
      final event = EventModel.fromJson(json);
      expect(event.thumbnailUrl, isNull);
    });

    test('fromJson handles empty pages', () {
      final json = {'text': 'No pages event', 'year': 1800, 'pages': []};
      final event = EventModel.fromJson(json);
      expect(event.title, '');
    });
  });

  group('SearchResultModel', () {
    test('fromJson parses correctly', () {
      final json = {
        'title': 'World War II',
        'snippet': 'Global war from 1939 to 1945...',
        'pageid': 32927,
      };
      final result = SearchResultModel.fromJson(json);
      expect(result.title, 'World War II');
      expect(result.snippet, 'Global war from 1939 to 1945...');
      expect(result.pageId, 32927);
    });
  });

  group('ArticleModel', () {
    test('fromJson parses page summary correctly', () {
      final json = {
        'title': 'Berlin Wall',
        'extract': 'The Berlin Wall was a guarded concrete barrier...',
        'thumbnail': {'source': 'https://example.com/img.jpg'},
        'content_urls': {'desktop': {'page': 'https://en.wikipedia.org/wiki/Berlin_Wall'}},
      };
      final article = ArticleModel.fromJson(json);
      expect(article.title, 'Berlin Wall');
      expect(article.extract, 'The Berlin Wall was a guarded concrete barrier...');
      expect(article.thumbnailUrl, 'https://example.com/img.jpg');
      expect(article.wikiUrl, 'https://en.wikipedia.org/wiki/Berlin_Wall');
    });

    test('toJson and fromJson round-trip', () {
      final article = ArticleModel(
        title: 'Test',
        extract: 'Extract text',
        thumbnailUrl: 'https://example.com/img.jpg',
        wikiUrl: 'https://en.wikipedia.org/wiki/Test',
      );
      final json = article.toJson();
      final restored = ArticleModel.fromJson(json);
      expect(restored.title, article.title);
      expect(restored.extract, article.extract);
      expect(restored.thumbnailUrl, article.thumbnailUrl);
      expect(restored.wikiUrl, article.wikiUrl);
    });

    test('fromJson handles missing thumbnail', () {
      final json = {
        'title': 'No Image',
        'extract': 'Some text',
        'content_urls': {'desktop': {'page': 'https://en.wikipedia.org/wiki/No_Image'}},
      };
      final article = ArticleModel.fromJson(json);
      expect(article.thumbnailUrl, isNull);
    });
  });
}
