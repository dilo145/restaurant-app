import 'package:flutter/material.dart';
import '../utils/constants.dart';

class AuthButton extends StatelessWidget {
  final bool isLoggedIn;

  const AuthButton({
    super.key,
    this.isLoggedIn = false,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isLoggedIn ? Icons.account_circle : Icons.login,
        size: 28,
      ),
      onPressed: () {
        if (isLoggedIn) {
          // Si l'utilisateur est connecté, naviguer vers la page de profil
          Navigator.pushNamed(context, '/profile');
        } else {
          // Sinon, naviguer vers la page de connexion
          Navigator.pushNamed(context, '/login');
        }
      },
      tooltip: isLoggedIn ? 'Profil' : 'Connexion',
    );
  }
}
