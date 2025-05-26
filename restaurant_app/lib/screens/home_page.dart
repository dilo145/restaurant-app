import 'package:flutter/material.dart';
import '../utils/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          AppText.restaurantName,
          style: AppStyles.appBarTitle,
        ),
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.background, AppColors.primaryLight],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Image en-tête
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    image: const DecorationImage(
                      image: AssetImage('assets/images/lebourget.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Titre principal
                const Text(
                  AppText.welcomeTitle,
                  style: AppStyles.heading,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Sous-titre
                const Text(
                  AppText.tagline,
                  style: AppStyles.subheading,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                // Section d'information
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Column(
                    children: [
                      Text(
                        AppText.aboutTitle,
                        style: AppStyles.sectionTitle,
                      ),
                      SizedBox(height: 15),
                      Text(
                        AppText.aboutDescription,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 15),
                      Text(
                        AppText.hoursTitle,
                        style: AppStyles.sectionTitle,
                      ),
                      SizedBox(height: 8),
                      Text(
                        AppText.hoursText,
                        style: TextStyle(fontSize: 15, height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Bouton pour accéder au menu
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/menu');
                  },
                  style: AppStyles.primaryButton,
                  child: const Text(
                    AppText.viewMenuButton,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
