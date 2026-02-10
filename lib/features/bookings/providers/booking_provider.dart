import 'package:flutter/material.dart';

import '../../../core/services/mock_api_service.dart';
import '../models/booking.dart';

/// Provider for bookings and payments management.
class BookingProvider extends ChangeNotifier {
  final MockApiService _api = MockApiService();

  List<Booking> _bookings = [];
  List<WithdrawalRequest> _withdrawals = [];
  RevenueStats? _revenueStats;
  bool _isLoading = false;
  String? _error;

  List<Booking> get bookings => _bookings;
  List<WithdrawalRequest> get withdrawals => _withdrawals;
  RevenueStats? get revenueStats => _revenueStats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get bookingCount => _bookings.length;
  int get pendingWithdrawalCount =>
      _withdrawals.where((w) => w.status == 'pending').length;

  /// Fetch all booking-related data.
  Future<void> fetchAll() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _api.getBookings(),
        _api.getRevenueStats(),
        _api.getWithdrawalRequests(),
      ]);

      _bookings = (results[0] as List<Map<String, dynamic>>)
          .map((e) => Booking.fromJson(e))
          .toList();
      _revenueStats = RevenueStats.fromJson(results[1] as Map<String, dynamic>);
      _withdrawals = (results[2] as List<Map<String, dynamic>>)
          .map((e) => WithdrawalRequest.fromJson(e))
          .toList();
    } catch (e) {
      _error = 'Failed to load bookings data';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Approve a withdrawal request.
  Future<void> approveWithdrawal(String id) async {
    await _api.updateWithdrawalStatus(id, 'approved');
    final index = _withdrawals.indexWhere((w) => w.id == id);
    if (index != -1) {
      _withdrawals[index].status = 'approved';
      notifyListeners();
    }
  }

  /// Reject a withdrawal request.
  Future<void> rejectWithdrawal(String id) async {
    await _api.updateWithdrawalStatus(id, 'rejected');
    final index = _withdrawals.indexWhere((w) => w.id == id);
    if (index != -1) {
      _withdrawals[index].status = 'rejected';
      notifyListeners();
    }
  }
}
