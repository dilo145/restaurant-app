import 'package:flutter/material.dart';

void main() {
  runApp(const RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Menu du Restaurant',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MenuPage(title: 'Menu du Restaurant'),
    );
  }
}

class MenuPage extends StatefulWidget {
  const MenuPage({super.key, required this.title});
  final String title;

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final List<String> categories = [
    'Entrées',
    'Plats',
    'Desserts',
    'Boissons',
    'Menus enfants',
    'Suggestions du chef',
  ];
  String selectedCategory = 'Entrées';

  final Map<String, List<Map<String, String>>> menu = {
    'Entrées': [
      {
        'name': 'Salade César',
        'description': 'Salade, poulet grillé, parmesan, croûtons.',
        'price': '8.50 €',
        'image': 'assets/images/salade.jpg',
      },
      {
        'name': 'Soupe de légumes',
        'description': 'Soupe maison aux légumes bio.',
        'price': '6.00 €',
        'image': 'assets/images/soupe.jpg',
      },
      {
        'name': 'Salade de fruits',
        'description': 'Salade aux fruits bio.',
        'price': '9.00 €',
        'image': 'assets/images/fruits.jpg',
      },
    ],
    'Plats': [
      {
        'name': 'Burger maison',
        'description': 'Steak, cheddar, salade, frites maison.',
        'price': '12.90 €',
        'image': 'assets/images/burger.jpg',
      },
      {
        'name': 'Pâtes au pesto',
        'description': 'Pâtes fraîches au pesto basilic maison.',
        'price': '11.00 €',
        'image': 'assets/images/pates.jpg',
      },
      {
        'name': 'Poulet rôti',
        'description': 'Poulet fermier accompagné de légumes grillés.',
        'price': '13.50 €',
        'image': 'assets/images/poulet.jpg',
      },
      {
        'name': 'Steak frites',
        'description': 'Pièce de bœuf grillée, servie avec des frites.',
        'price': '14.90 €',
        'image': 'assets/images/steak.jpg',
      },
      {
        'name': 'Curry de légumes',
        'description': 'Plat végétarien au lait de coco et riz basmati.',
        'price': '10.90 €',
        'image': 'assets/images/curry.jpg',
      },
      {
        'name': 'Lasagnes maison',
        'description': 'Bolognaise, béchamel et fromage fondant.',
        'price': '12.50 €',
        'image': 'assets/images/lasagnes.jpg',
      },
      {
        'name': 'Poisson grillé',
        'description': 'Filet de dorade grillé, servi avec du riz.',
        'price': '13.20 €',
        'image': 'assets/images/poisson.jpg',
      },
      {
        'name': 'Risotto aux champignons',
        'description': 'Crémeux et parfumé aux champignons de saison.',
        'price': '12.80 €',
        'image': 'assets/images/risotto.jpg',
      },
      {
        'name': 'Tartiflette savoyarde',
        'description': 'Pommes de terre, lardons, reblochon fondu.',
        'price': '13.90 €',
        'image': 'assets/images/tartiflette.jpg',
      },
    ],
    'Desserts': [
      {
        'name': 'Tiramisu',
        'description': 'Dessert italien au café et mascarpone.',
        'price': '5.50 €',
        'image': 'assets/images/tiramisu.jpg',
      },
      {
        'name': 'Fondant au chocolat',
        'description': 'Servi chaud avec une boule de vanille.',
        'price': '6.20 €',
        'image': 'assets/images/fondant.jpg',
      },
    ],
    'Boissons': [
      {
        'name': 'Chocolat chaud',
        'description': 'Chocolat chaud avec une touche de vanille.',
        'price': '3.50 €',
        'image': 'assets/images/chocolat_chaud.jpg',
      },
    ],
    'Menus enfants': [],
    'Suggestions du chef': [],
  };


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Catégories défilables horizontalement
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.teal : Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          // Liste des plats selon la catégorie sélectionnée
          Expanded(
            child: ListView.builder(
              itemCount: menu[selectedCategory]!.length,
              itemBuilder: (context, index) {
                final dish = menu[selectedCategory]![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                          child: Image.asset(
                            dish['image']!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dish['name']!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(dish['description']!),
                                const SizedBox(height: 5),
                                Text(
                                  dish['price']!,
                                  style: const TextStyle(
                                    color: Colors.teal,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
