import 'package:flutter/material.dart';

import '../../../core/services/mock_api_service.dart';
import '../models/dashboard_stats.dart';

/// Provider for dashboard statistics.
class DashboardProvider extends ChangeNotifier {
  final MockApiService _api = MockApiService();

  DashboardStats? _stats;
  bool _isLoading = false;
  String? _error;

  DashboardStats? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetch dashboard stats from mock API.
  Future<void> fetchStats() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _api.getDashboardStats();
      _stats = DashboardStats.fromJson(data);
    } catch (e) {
      _error = 'Failed to load dashboard data';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
