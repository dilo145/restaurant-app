import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/menu_page.dart';

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
      routes: {
        '/': (context) => const HomePage(),
        '/menu': (context) => const MenuPage(title: 'Menu du Restaurant'),
      },
      initialRoute: '/',
    );
  }
}
