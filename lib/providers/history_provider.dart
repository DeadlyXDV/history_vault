import 'package:flutter/foundation.dart';
import '../models/event_model.dart';
import '../models/search_result_model.dart';
import '../services/wikipedia_service.dart';

enum LoadState { idle, loading, loaded, error }

class HistoryProvider extends ChangeNotifier {
  final WikipediaService _service;

  HistoryProvider(this._service);

  List<EventModel> _todayEvents = [];
  List<SearchResultModel> _timelineResults = [];
  LoadState _homeState = LoadState.idle;
  LoadState _timelineState = LoadState.idle;
  String _homeError = '';
  String _timelineError = '';

  List<EventModel> get todayEvents => _todayEvents;
  List<SearchResultModel> get timelineResults => _timelineResults;
  LoadState get homeState => _homeState;
  LoadState get timelineState => _timelineState;
  String get homeError => _homeError;
  String get timelineError => _timelineError;

  Future<void> fetchTodayEvents() async {
    _homeState = LoadState.loading;
    _homeError = '';
    notifyListeners();
    try {
      final now = DateTime.now();
      _todayEvents = await _service.fetchOnThisDay(now.month, now.day);
      _homeState = LoadState.loaded;
    } catch (e) {
      _homeError = 'Failed to load today\'s events. Check your connection.';
      _homeState = LoadState.error;
    }
    notifyListeners();
  }

  Future<void> fetchTimeline(String year) async {
    _timelineState = LoadState.loading;
    _timelineError = '';
    notifyListeners();
    try {
      _timelineResults = await _service.searchArticles(year);
      _timelineState = LoadState.loaded;
    } catch (e) {
      _timelineError = 'Failed to load timeline. Check your connection.';
      _timelineState = LoadState.error;
    }
    notifyListeners();
  }
}
