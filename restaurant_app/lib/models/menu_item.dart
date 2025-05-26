class MenuItem {
  final String name;
  final String description;
  final String price;
  final String image;

  const MenuItem({
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  // Crée un MenuItem à partir d'un Map
  factory MenuItem.fromMap(Map<String, String> map) {
    return MenuItem(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: map['price'] ?? '',
      image: map['image'] ?? '',
    );
  }

  // Convertit un MenuItem en Map
  Map<String, String> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'image': image,
    };
  }
}
