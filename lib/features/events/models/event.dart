/// Event model.
class Event {
  final String id;
  final String title;
  final String organizerName;
  final String date;
  final String venue;
  String status; // mutable for local UI updates
  final double ticketPrice;
  final int bookingsCount;
  final String category;
  final String description;

  Event({
    required this.id,
    required this.title,
    required this.organizerName,
    required this.date,
    required this.venue,
    required this.status,
    required this.ticketPrice,
    required this.bookingsCount,
    required this.category,
    required this.description,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      title: json['title'] as String,
      organizerName: json['organizerName'] as String,
      date: json['date'] as String,
      venue: json['venue'] as String,
      status: json['status'] as String,
      ticketPrice: (json['ticketPrice'] as num).toDouble(),
      bookingsCount: json['bookingsCount'] as int,
      category: json['category'] as String,
      description: json['description'] as String,
    );
  }
}
