class User {
  final String id;
  final String username;
  final String email;
  final String fullName;
  final String phone;
  final String? profileImagePath;
  final String? description;
  final String role; // 'client', 'admin', etc.

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    required this.phone,
    this.profileImagePath,
    this.description,
    this.role = 'client',
  });

  // Crée un User à partir d'un Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      phone: map['phone'] ?? '',
      profileImagePath: map['profileImagePath'],
      description: map['description'],
      role: map['role'] ?? 'client',
    );
  }

  // Convertit un User en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'profileImagePath': profileImagePath,
      'description': description,
      'role': role,
    };
  }

  // Crée une copie de User avec des modifications
  User copyWith({
    String? id,
    String? username,
    String? email,
    String? fullName,
    String? phone,
    String? profileImagePath,
    String? description,
    String? role,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      description: description ?? this.description,
      role: role ?? this.role,
    );
  }
}
