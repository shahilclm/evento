/// Booking model.
class Booking {
  final String id;
  final String eventTitle;
  final String userName;
  final double amount;
  final String paymentStatus;
  final String bookingDate;
  final String eventDate;
  final int ticketCount;

  const Booking({
    required this.id,
    required this.eventTitle,
    required this.userName,
    required this.amount,
    required this.paymentStatus,
    required this.bookingDate,
    required this.eventDate,
    required this.ticketCount,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      eventTitle: json['eventTitle'] as String,
      userName: json['userName'] as String,
      amount: (json['amount'] as num).toDouble(),
      paymentStatus: json['paymentStatus'] as String,
      bookingDate: json['bookingDate'] as String,
      eventDate:
          json['eventDate'] as String? ?? '2026-03-20', // Default for safety
      ticketCount: json['ticketCount'] as int,
    );
  }
}

/// Withdrawal request model.
class WithdrawalRequest {
  final String id;
  final String organizerName;
  final double amount;
  String status; // mutable for local UI updates
  final String requestDate;
  final String bankAccount;

  WithdrawalRequest({
    required this.id,
    required this.organizerName,
    required this.amount,
    required this.status,
    required this.requestDate,
    required this.bankAccount,
  });

  factory WithdrawalRequest.fromJson(Map<String, dynamic> json) {
    return WithdrawalRequest(
      id: json['id'] as String,
      organizerName: json['organizerName'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
      requestDate: json['requestDate'] as String,
      bankAccount: json['bankAccount'] as String,
    );
  }
}

/// Revenue stats model.
class RevenueStats {
  final double totalRevenue;
  final double thisMonthRevenue;
  final double totalCommission;
  final double pendingPayouts;
  final String revenueTrend;
  final String commissionTrend;

  const RevenueStats({
    required this.totalRevenue,
    required this.thisMonthRevenue,
    required this.totalCommission,
    required this.pendingPayouts,
    required this.revenueTrend,
    required this.commissionTrend,
  });

  factory RevenueStats.fromJson(Map<String, dynamic> json) {
    return RevenueStats(
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      thisMonthRevenue: (json['thisMonthRevenue'] as num).toDouble(),
      totalCommission: (json['totalCommission'] as num).toDouble(),
      pendingPayouts: (json['pendingPayouts'] as num).toDouble(),
      revenueTrend: json['revenueTrend'] as String,
      commissionTrend: json['commissionTrend'] as String,
    );
  }
}
