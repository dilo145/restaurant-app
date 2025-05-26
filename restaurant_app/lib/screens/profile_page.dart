import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({
    super.key,
    required this.user,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoggingOut = false;
  late User _currentUser;
  
  @override
  void initState() {
    super.initState();
    _currentUser = widget.user; 
    _refreshUserInfo();
  }
  
  // Rafraîchir les informations utilisateur depuis le token
  Future<void> _refreshUserInfo() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.refreshUserFromToken();
      
      // Mettre à jour l'utilisateur local si nécessaire
      if (mounted && authProvider.user != null) {
        setState(() {
          _currentUser = authProvider.user!;
        });
      }
    } catch (e) {
      print('Erreur lors du rafraîchissement des informations utilisateur: $e');
    }
  }

  void _logout() async {
    setState(() {
      _isLoggingOut = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final result = await authProvider.logout();
      
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la déconnexion: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Mon Profil', style: AppStyles.appBarTitle),
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fonction à venir : Modifier le profil')),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: AppColors.background,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: AppColors.primary),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        '${_currentUser.firstname[0]}${_currentUser.lastname[0]}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${_currentUser.firstname} ${_currentUser.lastname}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _currentUser.email,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
                ListTile(
                leading: Icon(Icons.home, color: AppColors.textBrown),
                title: const Text('Accueil'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/');
                },
              ),
              ListTile(
                leading: Icon(Icons.restaurant_menu, color: AppColors.textBrown),
                title: const Text('Menu du Restaurant'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/menu');
                },
              ),
              ListTile(
                leading: Icon(Icons.event_available, color: AppColors.textBrown),
                title: const Text('Réserver une table'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/reservations/search');
                },
              ),
              ListTile(
                leading: Icon(Icons.history, color: AppColors.textBrown),
                title: const Text('Mes réservations'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/reservations/history');
                },
              ),
              // Si l'utilisateur est admin ou host, afficher le lien vers l'administration des réservations
              if (_currentUser.role == 'admin' || _currentUser.role == 'host')
                ListTile(
                  leading: Icon(Icons.admin_panel_settings, color: AppColors.textBrown),
                  title: const Text('Gérer les réservations'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/admin/reservations');
                  },
                ),
              // Si l'utilisateur est admin ou host, afficher le lien vers l'administration des réservations
              if (_currentUser.role == 'admin' || _currentUser.role == 'host')
                ListTile(
                  leading: Icon(Icons.admin_panel_settings, color: AppColors.textBrown),
                  title: const Text('Gérer les réservations'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/admin/reservations');
                  },
                ),
              const Divider(),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red[400]),
                title: Text('Déconnexion', style: TextStyle(color: Colors.red[400])),
                onTap: _isLoggingOut ? null : () {
                  Navigator.pop(context);
                  _logout();
                },
                trailing: _isLoggingOut 
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : null,
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, AppColors.background],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Carte de profil
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Photo de profil
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            '${_currentUser.firstname[0]}${_currentUser.lastname[0]}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Nom
                        Text(
                          '${_currentUser.firstname} ${_currentUser.lastname}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textBrown,
                          ),
                        ),
                        const SizedBox(height: 5),
                        // Statut client
                        Text(
                          'Client Gourmet',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Informations de contact
                        const Divider(),
                        const SizedBox(height: 15),
                        buildInfoRow(Icons.phone, 'Téléphone', _currentUser.phone ?? 'Non renseigné'),
                        const SizedBox(height: 15),
                        buildInfoRow(Icons.email, 'Email', _currentUser.email),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // À propos
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'À Propos',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textBrown,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Bienvenue dans notre restaurant ! Profitez de nos délicieux plats et de notre service de qualité.',
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
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

  Widget buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildPreferenceItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
