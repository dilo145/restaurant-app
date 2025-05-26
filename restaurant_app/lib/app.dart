import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'screens/home_page.dart';
import 'screens/menu_page.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/profile_page.dart';
import 'screens/reservation_search_page.dart';
import 'screens/reservation_history_page.dart';
import 'screens/admin_reservations_page.dart';
import 'providers/auth_provider.dart';
import 'providers/reservation_provider.dart';
import 'models/user.dart';

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Le Gourmet Français',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', 'FR'),
        Locale('en', 'US'),
      ],
      locale: const Locale('fr', 'FR'),
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/menu': (context) => const MenuPage(title: 'Menu du Restaurant'),
        '/profile': (context) {
          final user = authProvider.user;
          if (user != null) {
            return ProfilePage(user: user);
          } else {
            // Si l'utilisateur n'est pas connecté, rediriger vers la page de connexion
            return const LoginPage();
          }
        },
        '/reservations/search': (context) => const ReservationSearchPage(),
        '/reservations/history': (context) => const ReservationHistoryPage(),
        '/admin/reservations': (context) {
          final user = authProvider.user;
          // Vérifier si l'utilisateur est connecté et a le rôle d'admin ou de host
          if (user != null && (user.role == 'admin' || user.role == 'host')) {
            return const AdminReservationsPage();
          } else {
            // Rediriger vers la page d'accueil si l'utilisateur n'est pas autorisé
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Accès non autorisé'),
                backgroundColor: Colors.red,
              ),
            );
            return const HomePage();
          }
        },
      },
      initialRoute: '/',
      // Rediriger l'utilisateur en fonction de son état d'authentification
      onGenerateRoute: (settings) {
        if ((settings.name == '/profile' || 
             settings.name == '/reservations/search' || 
             settings.name == '/reservations/history') && 
            !authProvider.isLoggedIn) {
          return MaterialPageRoute(builder: (context) => const LoginPage());
        }
        
        // Protection de la page d'administration
        if (settings.name == '/admin/reservations') {
          final user = authProvider.user;
          if (user == null || (user.role != 'admin' && user.role != 'host')) {
            return MaterialPageRoute(builder: (context) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Accès non autorisé'),
                  backgroundColor: Colors.red,
                ),
              );
              return const HomePage();
            });
          }
        }
        return null;
      },
    );
  }
}
