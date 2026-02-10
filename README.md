# Evento — Event Management Admin Dashboard

A professional Flutter Admin Dashboard UI for an Event Management system, built with **Clean Architecture**, **Provider** for state management, and a **mock REST API** service.

## Screenshots

> Run the app and navigate through each module to see the full UI.

## Features

| Module | Description |
|--------|-------------|
| **Admin Login** | Email & password validation, demo credentials hint |
| **Dashboard** | Summary cards (users, organizers, events, bookings, revenue) + recent activity feed |
| **Organizer Management** | Searchable list with approve, reject, block/unblock actions |
| **Event Management** | Tabbed view (Pending / Approved / Active) with event cards and actions |
| **Bookings & Payments** | Booking list, revenue summary, withdrawal request approvals |
| **User Management** | Searchable user list, block/unblock, booking history dialog |
| **Settings** | Commission slider, auto-approve toggles, maintenance mode |

## Architecture

```
lib/
├── core/
│   ├── constants/       # Colors, app constants
│   ├── theme/           # Material dark theme
│   ├── services/        # Mock API service
│   └── widgets/         # Reusable widgets
└── features/
    ├── auth/            # Login screen, auth provider
    ├── dashboard/       # Overview screen, dashboard provider
    ├── organizers/      # Organizer management
    ├── events/          # Event management (tabbed)
    ├── bookings/        # Bookings & payments
    ├── users/           # User management
    ├── settings/        # Admin settings
    └── admin_shell/     # Sidebar navigation shell
```

Each feature follows:
```
feature_name/
├── models/      # Data classes
├── providers/   # ChangeNotifier providers
└── screens/     # UI widgets
```

## Tech Stack

- **Flutter** (stable channel)
- **Dart**
- **Provider** — state management
- **http** — REST API integration (mock)
- **Google Fonts** — Inter font family
- **intl** — number & date formatting

## Getting Started

### Prerequisites
- Flutter SDK (stable)
- Dart SDK

### Setup

```bash
# Clone the repository
git clone <repo-url>
cd evento

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Demo Credentials
| Field    | Value              |
|----------|--------------------|
| Email    | admin@evento.com   |
| Password | admin123           |

## Mock API

All data is served via `MockApiService` (`lib/core/services/mock_api_service.dart`) with an 800ms simulated network delay. No real backend is required.

## Key Design Decisions

- **Dark theme** with premium color palette and glassmorphic-style cards
- **Responsive layout** — sidebar on desktop, bottom nav on mobile
- **Loading / Error / Empty states** on every data screen
- **Confirmation dialogs** for destructive actions (block, reject, cancel)
- **Animated login** with fade + slide transitions

## License

MIT
