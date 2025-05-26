class Reservation {
  final int? id;
  final int userId;
  final DateTime date;
  final String timeSlot;
  final int numberOfGuests;
  final String customerName;
  final String customerPhone;
  final String? additionalNotes;
  final String status; // 'pending', 'confirmed', 'rejected'

  Reservation({
    this.id,
    required this.userId,
    required this.date,
    required this.timeSlot,
    required this.numberOfGuests,
    required this.customerName,
    required this.customerPhone,
    this.additionalNotes,
    this.status = 'pending',
  });

  // Crée une Reservation à partir d'un Map
  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      id: map['id'],
      userId: map['userId'] ?? 0,
      date: DateTime.parse(map['date']),
      timeSlot: map['timeSlot'] ?? '',
      numberOfGuests: map['numberOfGuests'] ?? 1,
      customerName: map['customerName'] ?? '',
      customerPhone: map['customerPhone'] ?? '',
      additionalNotes: map['additionalNotes'],
      status: map['status'] ?? 'pending',
    );
  }

  // Convertit une Reservation en Map
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'date': date.toIso8601String().split('T')[0], // Format YYYY-MM-DD
      'timeSlot': timeSlot,
      'numberOfGuests': numberOfGuests,
      'customerName': customerName,
      'customerPhone': customerPhone,
      if (additionalNotes != null) 'additionalNotes': additionalNotes,
      'status': status,
    };
  }

  // Crée une copie de Reservation avec des modifications
  Reservation copyWith({
    int? id,
    int? userId,
    DateTime? date,
    String? timeSlot,
    int? numberOfGuests,
    String? customerName,
    String? customerPhone,
    String? additionalNotes,
    String? status,
  }) {
    return Reservation(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      numberOfGuests: numberOfGuests ?? this.numberOfGuests,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      additionalNotes: additionalNotes ?? this.additionalNotes,
      status: status ?? this.status,
    );
  }
}

// Modèle pour les créneaux horaires disponibles
class TimeSlotAvailability {
  final String timeSlot;
  final int totalCapacity;
  final int availableSeats;
  final bool isAvailable;

  TimeSlotAvailability({
    required this.timeSlot,
    required this.totalCapacity,
    required this.availableSeats,
    required this.isAvailable,
  });

  factory TimeSlotAvailability.fromMap(Map<String, dynamic> map) {
    return TimeSlotAvailability(
      timeSlot: map['timeSlot'] ?? '',
      totalCapacity: map['totalCapacity'] ?? 0,
      availableSeats: map['availableSeats'] ?? 0,
      isAvailable: map['isAvailable'] ?? false,
    );
  }
}
