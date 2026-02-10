/// Organizer model.
class Organizer {
  final String id;
  final String name;
  final String email;
  final String phone;
  String status; // mutable for local UI updates
  final int eventsCount;
  final double totalRevenue;
  final String joinedDate;

  Organizer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.status,
    required this.eventsCount,
    required this.totalRevenue,
    required this.joinedDate,
  });

  factory Organizer.fromJson(Map<String, dynamic> json) {
    return Organizer(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      status: json['status'] as String,
      eventsCount: json['eventsCount'] as int,
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      joinedDate: json['joinedDate'] as String,
    );
  }
}
