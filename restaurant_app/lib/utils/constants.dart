import 'package:flutter/material.dart';

class AppColors {
  // Couleurs principales
  static final Color primary = Colors.amber[800]!;
  static final Color primaryLight = Colors.amber[100]!;
  static final Color background = Colors.amber[50]!;
  static const Color textBrown = Color(0xFF8B4513);
  static const Color textDarkBrown = Color(0xFF5C3317);

  // Couleurs d'accentuation
  static final Color accent = Colors.amber[400]!;
  static final Color cardBackground = Colors.white;
}

class AppStyles {
  // Styles pour les textes
  static const TextStyle appBarTitle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 22,
    color: Colors.white,
  );

  static const TextStyle heading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textBrown,
  );

  static const TextStyle subheading = TextStyle(
    fontSize: 18,
    fontStyle: FontStyle.italic,
    color: AppColors.textDarkBrown,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textBrown,
  );

  static const TextStyle dishName = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textBrown,
  );

  static const TextStyle dishDescription = TextStyle(
    fontSize: 14,
    height: 1.3,
  );

  // Styles pour les boutons
  static final ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    elevation: 5,
    shadowColor: AppColors.accent,
  );
}

class AppText {
  static const String restaurantName = 'Le Gourmet Français';
  static const String welcomeTitle = 'Bienvenue chez Le Gourmet Français';
  static const String tagline = 'Une expérience culinaire authentique';
  static const String aboutTitle = 'Notre Restaurant';
  static const String aboutDescription =
    'Le Gourmet Français vous propose une cuisine raffinée élaborée à partir de '
    'produits frais et locaux. Notre chef vous invite à découvrir des plats '
    'traditionnels revisités avec une touche de modernité.';
  static const String hoursTitle = 'Horaires d\'ouverture:';
  static const String hoursText =
    'Lundi - Vendredi: 11h30 - 14h30, 19h00 - 22h30\n'
    'Samedi - Dimanche: 11h30 - 23h00';
  static const String viewMenuButton = 'Découvrir notre Menu';
  static const String orderButton = 'Commander';
  static const String emptyCategory = 'Aucun plat disponible dans cette catégorie';
  static const String comingSoon = 'Revenez bientôt pour découvrir nos nouveautés';
}
