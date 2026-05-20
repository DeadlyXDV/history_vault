import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/search_result_model.dart';
import '../services/wikipedia_service.dart';

class SearchProvider extends ChangeNotifier {
  final WikipediaService _service;

  SearchProvider(this._service);

  List<SearchResultModel> _results = [];
  List<SearchResultModel> _suggestions = [];
  bool _isLoadingResults = false;
  bool _isLoadingSuggestions = false;
  String _error = '';
  Timer? _debounce;

  List<SearchResultModel> get results => _results;
  List<SearchResultModel> get suggestions => _suggestions;
  bool get isLoadingResults => _isLoadingResults;
  bool get isLoadingSuggestions => _isLoadingSuggestions;
  String get error => _error;

  void onQueryChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      _suggestions = [];
      notifyListeners();
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      _isLoadingSuggestions = true;
      notifyListeners();
      try {
        _suggestions = await _service.searchArticles(query.trim(), limit: 5);
      } catch (_) {
        _suggestions = [];
      }
      _isLoadingSuggestions = false;
      notifyListeners();
    });
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;
    _debounce?.cancel();
    _suggestions = [];
    _isLoadingResults = true;
    _error = '';
    notifyListeners();
    try {
      _results = await _service.searchArticles(query.trim());
    } catch (_) {
      _error = 'Search failed. Check your connection.';
      _results = [];
    }
    _isLoadingResults = false;
    notifyListeners();
  }

  void clearSuggestions() {
    _debounce?.cancel();
    _suggestions = [];
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
