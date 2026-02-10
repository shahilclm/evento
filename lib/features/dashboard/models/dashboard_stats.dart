/// Dashboard statistics model.
class DashboardStats {
  final int totalUsers;
  final int totalOrganizers;
  final int totalEvents;
  final int totalBookings;
  final double totalRevenue;
  final int pendingOrganizers;
  final int pendingEvents;
  final int pendingWithdrawals;
  final String usersTrend;
  final String organizersTrend;
  final String eventsTrend;
  final String bookingsTrend;
  final String revenueTrend;
  final List<ActivityItem> recentActivity;

  const DashboardStats({
    required this.totalUsers,
    required this.totalOrganizers,
    required this.totalEvents,
    required this.totalBookings,
    required this.totalRevenue,
    required this.pendingOrganizers,
    required this.pendingEvents,
    required this.pendingWithdrawals,
    required this.usersTrend,
    required this.organizersTrend,
    required this.eventsTrend,
    required this.bookingsTrend,
    required this.revenueTrend,
    required this.recentActivity,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalUsers: json['totalUsers'] as int,
      totalOrganizers: json['totalOrganizers'] as int,
      totalEvents: json['totalEvents'] as int,
      totalBookings: json['totalBookings'] as int,
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      pendingOrganizers: json['pendingOrganizers'] as int,
      pendingEvents: json['pendingEvents'] as int,
      pendingWithdrawals: json['pendingWithdrawals'] as int,
      usersTrend: json['usersTrend'] as String,
      organizersTrend: json['organizersTrend'] as String,
      eventsTrend: json['eventsTrend'] as String,
      bookingsTrend: json['bookingsTrend'] as String,
      revenueTrend: json['revenueTrend'] as String,
      recentActivity: (json['recentActivity'] as List)
          .map((e) => ActivityItem.fromJson(e))
          .toList(),
    );
  }
}

/// Recent activity item.
class ActivityItem {
  final String id;
  final String type;
  final String message;
  final String timestamp;

  const ActivityItem({
    required this.id,
    required this.type,
    required this.message,
    required this.timestamp,
  });

  factory ActivityItem.fromJson(Map<String, dynamic> json) {
    return ActivityItem(
      id: json['id'] as String,
      type: json['type'] as String,
      message: json['message'] as String,
      timestamp: json['timestamp'] as String,
    );
  }
}
