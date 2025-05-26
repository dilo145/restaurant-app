import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isLoggedIn = authProvider.isLoggedIn;
    
    return IconButton(
      icon: Icon(
        isLoggedIn ? Icons.person : Icons.person_outline,
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
