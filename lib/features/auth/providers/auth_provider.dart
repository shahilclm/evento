import 'package:flutter/material.dart';

import '../../../core/services/mock_api_service.dart';
import '../models/admin_user.dart';

/// Provider for authentication state and actions.
class AuthProvider extends ChangeNotifier {
  final MockApiService _api = MockApiService();

  AdminUser? _user;
  bool _isLoading = false;
  String? _errorMessage;

  // ── Getters ──
  AdminUser? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get errorMessage => _errorMessage;

  /// Validate email format.
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// Validate password.
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Login with email and password.
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _api.login(email.trim(), password);

      if (response['success'] == true) {
        _user = AdminUser.fromJson(response['data']);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] as String?;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Network error. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout the current admin.
  void logout() {
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear error message.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
