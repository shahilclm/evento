import 'package:flutter/material.dart';

/// Premium 4-color palette — light theme with gold accent.
///
/// 1. **Primary** — Gold `#FFCB74`
/// 2. **Dark** — Charcoal `#111111` / `#2F2F2F`
/// 3. **Light Surfaces** — Off-white `#F6F6F6` / White
/// 4. **Destructive** — Soft red for errors
class AppColors {
  AppColors._();

  // ── 1. Primary Accent (Gold) ──
  static const Color primary = Color(0xFFFFCB74);
  static const Color primaryLight = Color(0xFFFFD899);
  static const Color primaryDark = Color(0xFFE5B35E);

  // ── 2. Dark Tones (Charcoal) ──
  static const Color dark = Color(0xFF111111);
  static const Color darkGray = Color(0xFF2F2F2F);

  // ── 3. Light Surfaces ──
  static const Color background = Color(0xFFF6F6F6);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF0F0F0);
  static const Color card = Color(0xFFFFFFFF);
  static const Color sidebarBg = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE5E5E5);
  static const Color divider = Color(0xFFEEEEEE);

  // ── 4. Text Hierarchy ──
  static const Color textPrimary = Color(0xFF111111);
  static const Color textSecondary = Color(0xFF2F2F2F);
  static const Color textMuted = Color(0xFF999999);

  // ── 5. Destructive & Success ──
  static const Color destructive = Color(0xFFE54D4D);
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF1C40F);

  // ── Derived ──
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [surface, surfaceLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
