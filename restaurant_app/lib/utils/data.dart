import '../models/menu_item.dart';

class MenuData {
  static final List<String> categories = [
    'Entrées',
    'Plats',
    'Desserts',
    'Boissons',
    'Menus enfants',
    'Suggestions du chef',
  ];

  static final Map<String, List<MenuItem>> menu = {
    'Entrées': [
      MenuItem(
        name: 'Salade César',
        description: 'Salade, poulet grillé, parmesan, croûtons.',
        price: '8.50 €',
        image: 'assets/images/salade.jpg',
      ),
      MenuItem(
        name: 'Soupe de légumes',
        description: 'Soupe maison aux légumes bio.',
        price: '6.00 €',
        image: 'assets/images/soupe.jpg',
      ),
      MenuItem(
        name: 'Salade de fruits',
        description: 'Salade aux fruits bio.',
        price: '9.00 €',
        image: 'assets/images/fruits.jpg',
      ),
    ],
    'Plats': [
      MenuItem(
        name: 'Burger maison',
        description: 'Steak, cheddar, salade, frites maison.',
        price: '12.90 €',
        image: 'assets/images/burger.jpg',
      ),
      MenuItem(
        name: 'Pâtes au pesto',
        description: 'Pâtes fraîches au pesto basilic maison.',
        price: '11.00 €',
        image: 'assets/images/pates.jpg',
      ),
      MenuItem(
        name: 'Poulet rôti',
        description: 'Poulet fermier accompagné de légumes grillés.',
        price: '13.50 €',
        image: 'assets/images/poulet.jpg',
      ),
      MenuItem(
        name: 'Steak frites',
        description: 'Pièce de bœuf grillée, servie avec des frites.',
        price: '14.90 €',
        image: 'assets/images/steak.jpg',
      ),
      MenuItem(
        name: 'Curry de légumes',
        description: 'Plat végétarien au lait de coco et riz basmati.',
        price: '10.90 €',
        image: 'assets/images/curry.jpg',
      ),
      MenuItem(
        name: 'Lasagnes maison',
        description: 'Bolognaise, béchamel et fromage fondant.',
        price: '12.50 €',
        image: 'assets/images/lasagnes.jpg',
      ),
      MenuItem(
        name: 'Poisson grillé',
        description: 'Filet de dorade grillé, servi avec du riz.',
        price: '13.20 €',
        image: 'assets/images/poisson.jpg',
      ),
      MenuItem(
        name: 'Risotto aux champignons',
        description: 'Crémeux et parfumé aux champignons de saison.',
        price: '12.80 €',
        image: 'assets/images/risotto.jpg',
      ),
      MenuItem(
        name: 'Tartiflette savoyarde',
        description: 'Pommes de terre, lardons, reblochon fondu.',
        price: '13.90 €',
        image: 'assets/images/tartiflette.jpg',
      ),
    ],
    'Desserts': [
      MenuItem(
        name: 'Tiramisu',
        description: 'Dessert italien au café et mascarpone.',
        price: '5.50 €',
        image: 'assets/images/tiramisu.jpg',
      ),
      MenuItem(
        name: 'Fondant au chocolat',
        description: 'Servi chaud avec une boule de vanille.',
        price: '6.20 €',
        image: 'assets/images/fondant.jpg',
      ),
    ],
    'Boissons': [
      MenuItem(
        name: 'Chocolat chaud',
        description: 'Chocolat chaud avec une touche de vanille.',
        price: '3.50 €',
        image: 'assets/images/chocolat_chaud.jpg',
      ),
    ],
    'Menus enfants': [],
    'Suggestions du chef': [],
  };
}
