import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  /// Try to auto-login using persisted data.
  Future<bool> tryAutoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey('user_data')) return false;

      final userData =
          jsonDecode(prefs.getString('user_data')!) as Map<String, dynamic>;
      _user = AdminUser.fromJson(userData);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Persist user data to local storage.
  Future<void> _persistUser(AdminUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(user.toJson()));
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
        await _persistUser(_user!);
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
      _errorMessage = 'Login failed. Please restart the app and try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout the current admin.
  Future<void> logout() async {
    _user = null;
    _errorMessage = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    notifyListeners();
  }

  /// Clear error message.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
