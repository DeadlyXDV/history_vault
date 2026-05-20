import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article_model.dart';

class FavoritesProvider extends ChangeNotifier {
  static const _key = 'favorites';
  List<ArticleModel> _favorites = [];

  List<ArticleModel> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(String title) =>
      _favorites.any((a) => a.title == title);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    _favorites = raw
        .map((s) => ArticleModel.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
    notifyListeners();
  }

  Future<void> add(ArticleModel article) async {
    if (isFavorite(article.title)) return;
    _favorites.add(article);
    await _persist();
    notifyListeners();
  }

  Future<void> remove(String title) async {
    _favorites.removeWhere((a) => a.title == title);
    await _persist();
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = _favorites.map((a) => jsonEncode(a.toJson())).toList();
    await prefs.setStringList(_key, raw);
  }
}
