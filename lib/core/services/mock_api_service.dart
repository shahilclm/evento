import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../constants/app_constants.dart';

/// Mock API service that simulates REST calls with dummy JSON responses.
///
/// All methods include a simulated network delay of [AppConstants.apiDelay].
class MockApiService {
  /// Simulate a network call with delay.
  Future<Map<String, dynamic>> _respond(Map<String, dynamic> data) async {
    await Future.delayed(AppConstants.apiDelay);
    // Simulate JSON serialization round-trip
    return jsonDecode(jsonEncode(data)) as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> _respondList(
    List<Map<String, dynamic>> data,
  ) async {
    await Future.delayed(AppConstants.apiDelay);
    return (jsonDecode(jsonEncode(data)) as List).cast<Map<String, dynamic>>();
  }

  // ─────────────────────────────────────────────
  //  AUTH
  // ─────────────────────────────────────────────

  Future<Map<String, dynamic>> login(String email, String password) async {
    await Future.delayed(AppConstants.apiDelay);
    if (email == AppConstants.adminEmail &&
        password == AppConstants.adminPassword) {
      return {
        'success': true,
        'data': {
          'id': 'admin_001',
          'name': 'Admin User',
          'email': email,
          'role': 'super_admin',
          'token': 'mock_jwt_token_xyz123',
          'avatar': null,
        },
      };
    }
    return {'success': false, 'message': 'Invalid email or password'};
  }

  // ─────────────────────────────────────────────
  //  DASHBOARD
  // ─────────────────────────────────────────────

  Future<Map<String, dynamic>> getDashboardStats() async {
    return _respond({
      'totalUsers': 12845,
      'totalOrganizers': 342,
      'totalEvents': 1256,
      'totalBookings': 28750,
      'totalRevenue': 4528600.0,
      'pendingOrganizers': 18,
      'pendingEvents': 24,
      'pendingWithdrawals': 7,
      'usersTrend': '+12.5%',
      'organizersTrend': '+8.3%',
      'eventsTrend': '+15.2%',
      'bookingsTrend': '+22.1%',
      'revenueTrend': '+18.7%',
      'recentActivity': [
        {
          'id': 'act_001',
          'type': 'organizer_signup',
          'message': 'New organizer "EventPro Inc." registered',
          'timestamp': '2026-02-10T21:30:00Z',
        },
        {
          'id': 'act_002',
          'type': 'event_created',
          'message': 'Event "Tech Summit 2026" submitted for approval',
          'timestamp': '2026-02-10T21:15:00Z',
        },
        {
          'id': 'act_003',
          'type': 'booking',
          'message': '15 new bookings for "Music Festival Kerala"',
          'timestamp': '2026-02-10T20:45:00Z',
        },
        {
          'id': 'act_004',
          'type': 'withdrawal',
          'message': 'Withdrawal request ₹45,000 from "DJ Events"',
          'timestamp': '2026-02-10T20:30:00Z',
        },
        {
          'id': 'act_005',
          'type': 'user_report',
          'message': 'User reported issue with booking #BK2841',
          'timestamp': '2026-02-10T20:00:00Z',
        },
        {
          'id': 'act_006',
          'type': 'event_completed',
          'message': '"Startup Meetup Kochi" event completed successfully',
          'timestamp': '2026-02-10T19:30:00Z',
        },
      ],
    });
  }

  // ─────────────────────────────────────────────
  //  ORGANIZERS
  // ─────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getOrganizers() async {
    return _respondList([
      {
        'id': 'org_001',
        'name': 'EventPro Inc.',
        'email': 'info@eventpro.com',
        'phone': '+91 98765 43210',
        'status': 'pending',
        'eventsCount': 0,
        'totalRevenue': 0.0,
        'joinedDate': '2026-02-10',
      },
      {
        'id': 'org_002',
        'name': 'Star Productions',
        'email': 'contact@starproductions.in',
        'phone': '+91 87654 32109',
        'status': 'approved',
        'eventsCount': 23,
        'totalRevenue': 856000.0,
        'joinedDate': '2025-08-15',
      },
      {
        'id': 'org_003',
        'name': 'DJ Events Kerala',
        'email': 'djevents@mail.com',
        'phone': '+91 76543 21098',
        'status': 'approved',
        'eventsCount': 45,
        'totalRevenue': 1520000.0,
        'joinedDate': '2025-05-20',
      },
      {
        'id': 'org_004',
        'name': 'Cultural Hub',
        'email': 'hello@culturalhub.org',
        'phone': '+91 65432 10987',
        'status': 'blocked',
        'eventsCount': 12,
        'totalRevenue': 340000.0,
        'joinedDate': '2025-09-01',
      },
      {
        'id': 'org_005',
        'name': 'TechMeet Solutions',
        'email': 'support@techmeet.io',
        'phone': '+91 54321 09876',
        'status': 'pending',
        'eventsCount': 0,
        'totalRevenue': 0.0,
        'joinedDate': '2026-02-09',
      },
      {
        'id': 'org_006',
        'name': 'Vivid Weddings',
        'email': 'book@vividweddings.com',
        'phone': '+91 43210 98765',
        'status': 'approved',
        'eventsCount': 67,
        'totalRevenue': 2850000.0,
        'joinedDate': '2025-03-10',
      },
      {
        'id': 'org_007',
        'name': 'NightLife Entertainments',
        'email': 'info@nightlife.in',
        'phone': '+91 32109 87654',
        'status': 'rejected',
        'eventsCount': 0,
        'totalRevenue': 0.0,
        'joinedDate': '2026-01-25',
      },
    ]);
  }

  Future<Map<String, dynamic>> updateOrganizerStatus(
    String id,
    String status,
  ) async {
    return _respond({
      'success': true,
      'message': 'Organizer status updated to $status',
    });
  }

  // ─────────────────────────────────────────────
  //  EVENTS
  // ─────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getEvents() async {
    return _respondList([
      {
        'id': 'evt_001',
        'title': 'Tech Summit 2026',
        'organizerName': 'TechMeet Solutions',
        'date': '2026-03-15',
        'venue': 'Kochi Convention Center',
        'status': 'pending',
        'ticketPrice': 1500.0,
        'bookingsCount': 0,
        'category': 'Technology',
        'description': 'Annual technology summit featuring top speakers.',
      },
      {
        'id': 'evt_002',
        'title': 'Music Festival Kerala',
        'organizerName': 'DJ Events Kerala',
        'date': '2026-03-22',
        'venue': 'Marine Drive Ground, Kochi',
        'status': 'approved',
        'ticketPrice': 999.0,
        'bookingsCount': 450,
        'category': 'Music',
        'description': 'The biggest music festival in Kerala.',
      },
      {
        'id': 'evt_003',
        'title': 'Startup Meetup Kochi',
        'organizerName': 'EventPro Inc.',
        'date': '2026-02-28',
        'venue': 'SmartCity Kochi',
        'status': 'active',
        'ticketPrice': 500.0,
        'bookingsCount': 180,
        'category': 'Business',
        'description': 'Monthly startup networking event.',
      },
      {
        'id': 'evt_004',
        'title': 'Classical Dance Show',
        'organizerName': 'Cultural Hub',
        'date': '2026-04-05',
        'venue': 'Town Hall, Thrissur',
        'status': 'pending',
        'ticketPrice': 750.0,
        'bookingsCount': 0,
        'category': 'Cultural',
        'description': 'Traditional Bharatanatyam and Mohiniyattam.',
      },
      {
        'id': 'evt_005',
        'title': 'Food Carnival 2026',
        'organizerName': 'Star Productions',
        'date': '2026-05-10',
        'venue': 'Lulu Convention Center',
        'status': 'approved',
        'ticketPrice': 200.0,
        'bookingsCount': 820,
        'category': 'Food',
        'description': 'Multi-cuisine food carnival with 100+ stalls.',
      },
      {
        'id': 'evt_006',
        'title': 'Stand-Up Comedy Night',
        'organizerName': 'NightLife Entertainments',
        'date': '2026-03-08',
        'venue': 'Gokulam Convention Center',
        'status': 'active',
        'ticketPrice': 600.0,
        'bookingsCount': 320,
        'category': 'Comedy',
        'description': 'Comedy night featuring top comedians.',
      },
      {
        'id': 'evt_007',
        'title': 'Wedding Expo 2026',
        'organizerName': 'Vivid Weddings',
        'date': '2026-06-01',
        'venue': 'Le Méridien, Kochi',
        'status': 'pending',
        'ticketPrice': 0.0,
        'bookingsCount': 0,
        'category': 'Exhibition',
        'description': 'Grand wedding exhibition with top vendors.',
      },
      {
        'id': 'evt_008',
        'title': 'Marathon Kerala 2026',
        'organizerName': 'Star Productions',
        'date': '2026-04-20',
        'venue': 'Jawaharlal Nehru Stadium',
        'status': 'active',
        'ticketPrice': 350.0,
        'bookingsCount': 1250,
        'category': 'Sports',
        'description': 'Annual marathon event with 5K, 10K, and Half Marathon.',
      },
    ]);
  }

  Future<Map<String, dynamic>> updateEventStatus(
    String id,
    String status,
  ) async {
    return _respond({
      'success': true,
      'message': 'Event status updated to $status',
    });
  }

  // ─────────────────────────────────────────────
  //  BOOKINGS
  // ─────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getBookings() async {
    return _respondList([
      {
        'id': 'BK001',
        'eventTitle': 'Music Festival Kerala',
        'userName': 'Rahul Sharma',
        'amount': 999.0,
        'paymentStatus': 'completed',
        'bookingDate': '2026-02-08',
        'eventDate': '2026-03-22',
        'ticketCount': 1,
      },
      {
        'id': 'BK002',
        'eventTitle': 'Startup Meetup Kochi',
        'userName': 'Priya Menon',
        'amount': 1000.0,
        'paymentStatus': 'completed',
        'bookingDate': '2026-02-07',
        'eventDate': '2026-02-28',
        'ticketCount': 2,
      },
      {
        'id': 'BK003',
        'eventTitle': 'Food Carnival 2026',
        'userName': 'Arun Kumar',
        'amount': 800.0,
        'paymentStatus': 'pending',
        'bookingDate': '2026-02-10',
        'eventDate': '2026-05-10',
        'ticketCount': 4,
      },
      {
        'id': 'BK004',
        'eventTitle': 'Stand-Up Comedy Night',
        'userName': 'Deepa Nair',
        'amount': 1200.0,
        'paymentStatus': 'completed',
        'bookingDate': '2026-02-06',
        'eventDate': '2026-03-08',
        'ticketCount': 2,
      },
      {
        'id': 'BK005',
        'eventTitle': 'Marathon Kerala 2026',
        'userName': 'Vishnu Raj',
        'amount': 350.0,
        'paymentStatus': 'failed',
        'bookingDate': '2026-02-09',
        'eventDate': '2026-04-20',
        'ticketCount': 1,
      },
      {
        'id': 'BK006',
        'eventTitle': 'Music Festival Kerala',
        'userName': 'Sneha Das',
        'amount': 2997.0,
        'paymentStatus': 'completed',
        'bookingDate': '2026-02-05',
        'eventDate': '2026-03-22',
        'ticketCount': 3,
      },
      {
        'id': 'BK007',
        'eventTitle': 'Food Carnival 2026',
        'userName': 'Mohammed Faisal',
        'amount': 600.0,
        'paymentStatus': 'refunded',
        'bookingDate': '2026-02-04',
        'eventDate': '2026-05-10',
        'ticketCount': 3,
      },
    ]);
  }

  Future<Map<String, dynamic>> getRevenueStats() async {
    return _respond({
      'totalRevenue': 4528600.0,
      'thisMonthRevenue': 856200.0,
      'totalCommission': 452860.0,
      'pendingPayouts': 125400.0,
      'revenueTrend': '+18.7%',
      'commissionTrend': '+18.7%',
    });
  }

  Future<List<Map<String, dynamic>>> getWithdrawalRequests() async {
    return _respondList([
      {
        'id': 'wd_001',
        'organizerName': 'DJ Events Kerala',
        'amount': 45000.0,
        'status': 'pending',
        'requestDate': '2026-02-10',
        'bankAccount': '****4521',
      },
      {
        'id': 'wd_002',
        'organizerName': 'Star Productions',
        'amount': 78000.0,
        'status': 'pending',
        'requestDate': '2026-02-09',
        'bankAccount': '****8832',
      },
      {
        'id': 'wd_003',
        'organizerName': 'Vivid Weddings',
        'amount': 120000.0,
        'status': 'approved',
        'requestDate': '2026-02-07',
        'bankAccount': '****2290',
      },
      {
        'id': 'wd_004',
        'organizerName': 'EventPro Inc.',
        'amount': 32000.0,
        'status': 'rejected',
        'requestDate': '2026-02-05',
        'bankAccount': '****1156',
      },
    ]);
  }

  Future<Map<String, dynamic>> updateWithdrawalStatus(
    String id,
    String status,
  ) async {
    return _respond({'success': true, 'message': 'Withdrawal request $status'});
  }

  // ─────────────────────────────────────────────
  //  USERS
  // ─────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getUsers() async {
    return _respondList([
      {
        'id': 'usr_001',
        'name': 'Rahul Sharma',
        'email': 'rahul@mail.com',
        'phone': '+91 98765 00001',
        'status': 'active',
        'bookingsCount': 12,
        'joinedDate': '2025-06-15',
      },
      {
        'id': 'usr_002',
        'name': 'Priya Menon',
        'email': 'priya@mail.com',
        'phone': '+91 98765 00002',
        'status': 'active',
        'bookingsCount': 8,
        'joinedDate': '2025-07-20',
      },
      {
        'id': 'usr_003',
        'name': 'Arun Kumar',
        'email': 'arun@mail.com',
        'phone': '+91 98765 00003',
        'status': 'blocked',
        'bookingsCount': 3,
        'joinedDate': '2025-09-10',
      },
      {
        'id': 'usr_004',
        'name': 'Deepa Nair',
        'email': 'deepa@mail.com',
        'phone': '+91 98765 00004',
        'status': 'active',
        'bookingsCount': 21,
        'joinedDate': '2025-04-05',
      },
      {
        'id': 'usr_005',
        'name': 'Vishnu Raj',
        'email': 'vishnu@mail.com',
        'phone': '+91 98765 00005',
        'status': 'active',
        'bookingsCount': 5,
        'joinedDate': '2025-11-28',
      },
      {
        'id': 'usr_006',
        'name': 'Sneha Das',
        'email': 'sneha@mail.com',
        'phone': '+91 98765 00006',
        'status': 'active',
        'bookingsCount': 15,
        'joinedDate': '2025-05-12',
      },
      {
        'id': 'usr_007',
        'name': 'Mohammed Faisal',
        'email': 'faisal@mail.com',
        'phone': '+91 98765 00007',
        'status': 'blocked',
        'bookingsCount': 2,
        'joinedDate': '2025-12-01',
      },
      {
        'id': 'usr_008',
        'name': 'Anjali Thomas',
        'email': 'anjali@mail.com',
        'phone': '+91 98765 00008',
        'status': 'active',
        'bookingsCount': 34,
        'joinedDate': '2025-03-18',
      },
    ]);
  }

  Future<Map<String, dynamic>> updateUserStatus(
    String id,
    String status,
  ) async {
    return _respond({
      'success': true,
      'message': 'User status updated to $status',
    });
  }

  Future<List<Map<String, dynamic>>> getUserBookingHistory(
    String userId,
  ) async {
    return _respondList([
      {
        'id': 'BK101',
        'eventTitle': 'Music Festival Kerala',
        'amount': 999.0,
        'status': 'completed',
        'date': '2026-01-15',
      },
      {
        'id': 'BK102',
        'eventTitle': 'Startup Meetup Kochi',
        'amount': 500.0,
        'status': 'completed',
        'date': '2025-12-20',
      },
      {
        'id': 'BK103',
        'eventTitle': 'Food Carnival 2026',
        'amount': 200.0,
        'status': 'cancelled',
        'date': '2025-11-10',
      },
    ]);
  }

  // ─────────────────────────────────────────────
  //  SETTINGS
  // ─────────────────────────────────────────────

  Future<Map<String, dynamic>> getSettings() async {
    return _respond({
      'commissionPercent': 10.0,
      'autoApproveEvents': false,
      'autoApproveOrganizers': false,
      'maintenanceMode': false,
      'minWithdrawalAmount': 1000.0,
      'maxTicketPrice': 50000.0,
    });
  }

  Future<Map<String, dynamic>> updateSettings(
    Map<String, dynamic> settings,
  ) async {
    debugPrint('[MockAPI] Settings updated: $settings');
    return _respond({
      'success': true,
      'message': 'Settings updated successfully',
    });
  }
}
