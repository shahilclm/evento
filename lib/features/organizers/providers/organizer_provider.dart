import 'package:flutter/material.dart';

import '../../../core/services/mock_api_service.dart';
import '../models/organizer.dart';

/// Provider for organizer management.
class OrganizerProvider extends ChangeNotifier {
  final MockApiService _api = MockApiService();

  List<Organizer> _organizers = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  List<Organizer> get organizers {
    if (_searchQuery.isEmpty) return _organizers;
    return _organizers
        .where(
          (o) =>
              o.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              o.email.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  /// Fetch organizers from mock API.
  Future<void> fetchOrganizers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _api.getOrganizers();
      _organizers = data.map((e) => Organizer.fromJson(e)).toList();
    } catch (e) {
      _error = 'Failed to load organizers';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update search query.
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Approve an organizer.
  Future<void> approveOrganizer(String id) async {
    await _api.updateOrganizerStatus(id, 'approved');
    final index = _organizers.indexWhere((o) => o.id == id);
    if (index != -1) {
      _organizers[index].status = 'approved';
      notifyListeners();
    }
  }

  /// Reject an organizer.
  Future<void> rejectOrganizer(String id) async {
    await _api.updateOrganizerStatus(id, 'rejected');
    final index = _organizers.indexWhere((o) => o.id == id);
    if (index != -1) {
      _organizers[index].status = 'rejected';
      notifyListeners();
    }
  }

  /// Block an organizer.
  Future<void> blockOrganizer(String id) async {
    await _api.updateOrganizerStatus(id, 'blocked');
    final index = _organizers.indexWhere((o) => o.id == id);
    if (index != -1) {
      _organizers[index].status = 'blocked';
      notifyListeners();
    }
  }

  /// Update organizer status.
  Future<void> updateOrganizerStatus(String id, String status) async {
    await _api.updateOrganizerStatus(id, status);
    final index = _organizers.indexWhere((o) => o.id == id);
    if (index != -1) {
      _organizers[index].status = status;
      notifyListeners();
    }
  }
}
