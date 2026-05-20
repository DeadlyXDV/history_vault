import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event_model.dart';
import '../models/search_result_model.dart';
import '../models/article_model.dart';

class WikipediaService {
  static const _baseRest = 'https://en.wikipedia.org/api/rest_v1';
  static const _baseApi = 'https://en.wikipedia.org/w/api.php';

  final http.Client _client;

  WikipediaService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<EventModel>> fetchOnThisDay(int month, int day) async {
    final uri = Uri.parse('$_baseRest/feed/onthisday/events/$month/$day');
    final response = await _client.get(uri).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch on this day: ${response.statusCode}');
    }
    return parseOnThisDay(response.body);
  }

  Future<List<SearchResultModel>> searchArticles(String query, {int limit = 20}) async {
    final uri = Uri.parse(_baseApi).replace(queryParameters: {
      'action': 'query',
      'list': 'search',
      'srsearch': query,
      'srlimit': limit.toString(),
      'format': 'json',
      'origin': '*',
    });
    final response = await _client.get(uri).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception('Failed to search: ${response.statusCode}');
    }
    return parseSearch(response.body);
  }

  Future<ArticleModel> fetchPageSummary(String title) async {
    final encoded = Uri.encodeComponent(title);
    final uri = Uri.parse('$_baseRest/page/summary/$encoded');
    final response = await _client.get(uri).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch page summary: ${response.statusCode}');
    }
    return parsePageSummary(response.body);
  }

  Future<ArticleModel> fetchRandomArticle() async {
    final uri = Uri.parse('$_baseRest/page/random/summary');
    final response = await _client.get(uri).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch random article: ${response.statusCode}');
    }
    return parsePageSummary(response.body);
  }

  static List<EventModel> parseOnThisDay(String body) {
    final data = jsonDecode(body) as Map<String, dynamic>;
    final events = data['events'] as List<dynamic>? ?? [];
    return events
        .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static List<SearchResultModel> parseSearch(String body) {
    final data = jsonDecode(body) as Map<String, dynamic>;
    final query = data['query'] as Map<String, dynamic>? ?? {};
    final search = query['search'] as List<dynamic>? ?? [];
    return search
        .map((e) => SearchResultModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static ArticleModel parsePageSummary(String body) {
    final data = jsonDecode(body) as Map<String, dynamic>;
    return ArticleModel.fromJson(data);
  }
}