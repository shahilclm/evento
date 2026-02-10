/// App user model (end-user, not admin).
class AppUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  String status; // mutable for local UI updates
  final int bookingsCount;
  final String joinedDate;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.status,
    required this.bookingsCount,
    required this.joinedDate,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      status: json['status'] as String,
      bookingsCount: json['bookingsCount'] as int,
      joinedDate: json['joinedDate'] as String,
    );
  }
}

/// User booking history item.
class UserBooking {
  final String id;
  final String eventTitle;
  final double amount;
  final String status;
  final String date;

  const UserBooking({
    required this.id,
    required this.eventTitle,
    required this.amount,
    required this.status,
    required this.date,
  });

  factory UserBooking.fromJson(Map<String, dynamic> json) {
    return UserBooking(
      id: json['id'] as String,
      eventTitle: json['eventTitle'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
      date: json['date'] as String,
    );
  }
}
