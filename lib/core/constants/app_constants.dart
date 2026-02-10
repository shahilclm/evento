/// Application-wide constants.
class AppConstants {
  AppConstants._();

  // ── API ──
  static const String apiBaseUrl = 'https://api.evento.mock/v1';
  static const Duration apiDelay = Duration(milliseconds: 800);

  // ── Admin credentials (mock) ──
  static const String adminEmail = 'admin@evento.com';
  static const String adminPassword = 'admin123';

  // ── App info ──
  static const String appName = 'Evento Admin';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Event Management Dashboard';

  // ── Pagination ──
  static const int defaultPageSize = 20;

  // ── Validation ──
  static const int minPasswordLength = 6;
}
