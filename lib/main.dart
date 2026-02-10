import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/bookings/providers/booking_provider.dart';
import 'features/dashboard/providers/dashboard_provider.dart';
import 'features/events/providers/event_provider.dart';
import 'features/organizers/providers/organizer_provider.dart';
import 'features/settings/providers/settings_provider.dart';
import 'features/users/providers/user_provider.dart';

void main() {
  runApp(const EventoAdminApp());
}

/// Root widget — registers all providers and sets the app theme.
class EventoAdminApp extends StatelessWidget {
  const EventoAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => OrganizerProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: MaterialApp(
        title: 'Evento Admin',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const LoginScreen(),
      ),
    );
  }
}
