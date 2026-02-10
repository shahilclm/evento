import 'package:flutter/material.dart';
import '../../../core/services/mock_api_service.dart';
import '../models/admin_settings.dart';

/// Provider for admin settings management.
class SettingsProvider extends ChangeNotifier {
  final MockApiService _api = MockApiService();

  AdminSettings? _settings;
  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;
  bool _hasChanges = false;

  AdminSettings? get settings => _settings;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;
  bool get hasChanges => _hasChanges;

  /// Fetch settings from mock API.
  Future<void> fetchSettings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _api.getSettings();
      _settings = AdminSettings.fromJson(data);
    } catch (e) {
      _error = 'Failed to load settings';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update commission percentage.
  void setCommission(double value) {
    if (_settings == null) return;
    _settings!.commissionPercent = value;
    _hasChanges = true;
    notifyListeners();
  }

  /// Toggle auto-approve events.
  void setAutoApproveEvents(bool value) {
    if (_settings == null) return;
    _settings!.autoApproveEvents = value;
    _hasChanges = true;
    notifyListeners();
  }

  /// Toggle auto-approve organizers.
  void setAutoApproveOrganizers(bool value) {
    if (_settings == null) return;
    _settings!.autoApproveOrganizers = value;
    _hasChanges = true;
    notifyListeners();
  }

  /// Toggle maintenance mode.
  void setMaintenanceMode(bool value) {
    if (_settings == null) return;
    _settings!.maintenanceMode = value;
    _hasChanges = true;
    notifyListeners();
  }

  /// Update minimum withdrawal amount.
  void setMinWithdrawalAmount(double value) {
    if (_settings == null) return;
    _settings!.minWithdrawalAmount = value;
    _hasChanges = true;
    notifyListeners();
  }

  /// Update maximum ticket price.
  void setMaxTicketPrice(double value) {
    if (_settings == null) return;
    _settings!.maxTicketPrice = value;
    _hasChanges = true;
    notifyListeners();
  }

  /// Save settings to mock API.
  Future<bool> saveSettings() async {
    if (_settings == null) return false;

    _isSaving = true;
    notifyListeners();

    try {
      await _api.updateSettings(_settings!.toJson());
      _hasChanges = false;
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }
}
