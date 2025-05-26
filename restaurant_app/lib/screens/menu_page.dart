import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/data.dart';
import '../widgets/category_selector.dart';
import '../widgets/dish_card.dart';
import '../widgets/auth_button.dart';
import '../models/menu_item.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key, required this.title});
  final String title;

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String selectedCategory = MenuData.categories.first;

  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          widget.title,
          style: AppStyles.appBarTitle,
        ),
        elevation: 4,
        actions: const [
          AuthButton(),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sélecteur de catégories
          CategorySelector(
            categories: MenuData.categories,
            selectedCategory: selectedCategory,
            onCategorySelected: selectCategory,
          ),
          const SizedBox(height: 10),
          // Liste des plats selon la catégorie sélectionnée
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, AppColors.background],
                ),
              ),
              child: MenuData.menu[selectedCategory]!.isEmpty
                ? _buildEmptyCategory()
                : _buildDishList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCategory() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 70,
            color: Colors.amber[300],
          ),
          const SizedBox(height: 20),
          Text(
            AppText.emptyCategory,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            AppText.comingSoon,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDishList() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: MenuData.menu[selectedCategory]!.length,
      itemBuilder: (context, index) {
        final MenuItem dish = MenuData.menu[selectedCategory]![index];
        return DishCard(dish: dish);
      },
    );
  }
}
