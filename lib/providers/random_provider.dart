import 'package:flutter/foundation.dart';
import '../models/article_model.dart';
import '../services/wikipedia_service.dart';

class RandomProvider extends ChangeNotifier {
  final WikipediaService _service;

  RandomProvider(this._service);

  bool _isLoading = false;
  ArticleModel? _article;

  bool get isLoading => _isLoading;
  ArticleModel? get article => _article;

  Future<ArticleModel?> fetchRandom() async {
    _isLoading = true;
    notifyListeners();
    try {
      _article = await _service.fetchRandomArticle();
      return _article;
    } catch (_) {
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
