import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/menu_page.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/profile_page.dart';
import 'models/user.dart';

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Le Gourmet Français',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/menu': (context) => const MenuPage(title: 'Menu du Restaurant'),
        '/profile': (context) => ProfilePage(
          user: User(
            id: '1',
            username: 'alexdupont',
            email: 'alex.dupont@email.com',
            fullName: 'Alex Dupont',
            phone: '+33 6 12 34 56 78',
            profileImagePath: 'assets/images/poulet.jpg',
            description: 'Passionné par la gastronomie française et les plats traditionnels. '
                'Je suis un client régulier du Gourmet Français et j\'adore découvrir de nouvelles saveurs.',
            role: 'client',
          ),
        ),
      },
      initialRoute: '/',
    );
  }
}
