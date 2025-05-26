class User {
  final int id;
  final String email;
  final String firstname;
  final String lastname;
  final String? phone;
  final String? address;
  final String role; // 'user', 'admin'

  User({
    required this.id,
    required this.email,
    required this.firstname,
    required this.lastname,
    this.phone,
    this.address,
    this.role = 'user',
  });

  // Getter pour le nom complet
  String get fullName => '$firstname $lastname';

  // Crée un User à partir d'un Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? 0,
      email: map['email'] ?? '',
      firstname: map['firstname'] ?? '',
      lastname: map['lastname'] ?? '',
      phone: map['phone'],
      address: map['address'],
      role: map['role'] ?? 'user',
    );
  }

  // Convertit un User en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
      'phone': phone,
      'address': address,
      'role': role,
    };
  }

  // Crée une copie de User avec des modifications
  User copyWith({
    int? id,
    String? email,
    String? firstname,
    String? lastname,
    String? phone,
    String? address,
    String? role,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      role: role ?? this.role,
    );
  }
}
