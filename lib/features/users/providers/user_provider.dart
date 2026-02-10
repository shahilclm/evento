import 'package:flutter/material.dart';

import '../../../core/services/mock_api_service.dart';
import '../models/app_user.dart';

/// Provider for user management.
class UserProvider extends ChangeNotifier {
  final MockApiService _api = MockApiService();

  List<AppUser> _users = [];
  List<UserBooking> _bookingHistory = [];
  bool _isLoading = false;
  bool _isLoadingHistory = false;
  String? _error;
  String _searchQuery = '';

  List<AppUser> get users {
    if (_searchQuery.isEmpty) return _users;
    return _users
        .where(
          (u) =>
              u.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              u.email.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  List<UserBooking> get bookingHistory => _bookingHistory;
  bool get isLoading => _isLoading;
  bool get isLoadingHistory => _isLoadingHistory;
  String? get error => _error;

  /// Fetch users from mock API.
  Future<void> fetchUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _api.getUsers();
      _users = data.map((e) => AppUser.fromJson(e)).toList();
    } catch (e) {
      _error = 'Failed to load users';
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

  /// Toggle user status between active and blocked.
  Future<void> toggleUserStatus(String id) async {
    final index = _users.indexWhere((u) => u.id == id);
    if (index != -1) {
      final newStatus = _users[index].status == 'blocked'
          ? 'active'
          : 'blocked';
      await _api.updateUserStatus(id, newStatus);
      _users[index].status = newStatus;
      notifyListeners();
    }
  }

  /// Update user status.
  Future<void> updateUserStatus(String id, String status) async {
    await _api.updateUserStatus(id, status);
    final index = _users.indexWhere((u) => u.id == id);
    if (index != -1) {
      _users[index].status = status;
      notifyListeners();
    }
  }

  /// Fetch booking history for a specific user.
  Future<void> fetchBookingHistory(String userId) async {
    _isLoadingHistory = true;
    notifyListeners();

    try {
      final data = await _api.getUserBookingHistory(userId);
      _bookingHistory = data.map((e) => UserBooking.fromJson(e)).toList();
    } catch (e) {
      _bookingHistory = [];
    } finally {
      _isLoadingHistory = false;
      notifyListeners();
    }
  }
}
