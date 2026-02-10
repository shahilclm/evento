import 'package:flutter/material.dart';

import '../../../core/services/mock_api_service.dart';
import '../models/event.dart';

/// Provider for event management with tab filtering.
class EventProvider extends ChangeNotifier {
  final MockApiService _api = MockApiService();

  List<Event> _events = [];
  bool _isLoading = false;
  String? _error;
  int _selectedTabIndex = 0;

  List<Event> get allEvents => _events;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get selectedTabIndex => _selectedTabIndex;

  /// Events filtered by the selected tab.
  List<Event> get filteredEvents {
    switch (_selectedTabIndex) {
      case 0:
        return _events.where((e) => e.status == 'pending').toList();
      case 1:
        return _events.where((e) => e.status == 'approved').toList();
      case 2:
        return _events.where((e) => e.status == 'active').toList();
      default:
        return _events;
    }
  }

  /// Count getters for tab badges.
  int get pendingCount => _events.where((e) => e.status == 'pending').length;
  int get approvedCount => _events.where((e) => e.status == 'approved').length;
  int get activeCount => _events.where((e) => e.status == 'active').length;

  /// Change the selected tab.
  void setTabIndex(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  /// Fetch events from mock API.
  Future<void> fetchEvents() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _api.getEvents();
      _events = data.map((e) => Event.fromJson(e)).toList();
    } catch (e) {
      _error = 'Failed to load events';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Approve an event.
  Future<void> approveEvent(String id) async {
    await _api.updateEventStatus(id, 'approved');
    final index = _events.indexWhere((e) => e.id == id);
    if (index != -1) {
      _events[index].status = 'approved';
      notifyListeners();
    }
  }

  /// Reject an event.
  Future<void> rejectEvent(String id) async {
    await _api.updateEventStatus(id, 'rejected');
    final index = _events.indexWhere((e) => e.id == id);
    if (index != -1) {
      _events[index].status = 'rejected';
      notifyListeners();
    }
  }

  /// Update event status.
  Future<void> updateEventStatus(String id, String status) async {
    await _api.updateEventStatus(id, status);
    final index = _events.indexWhere((e) => e.id == id);
    if (index != -1) {
      _events[index].status = status;
      notifyListeners();
    }
  }
}
