import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoggedIn = false;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _checkAuthStatus();
  }

  // Vérifier le statut d'authentification au démarrage
  Future<void> _checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await AuthService.getToken();
      if (token != null) {
        final result = await AuthService.getProfile();
        if (result['success']) {
          _user = result['user'];
          _isLoggedIn = true;
        }
      }
    } catch (e) {
      print('Erreur lors de la vérification du statut d\'authentification: $e');
    }

    _isLoading = false;
    notifyListeners();
  }  // Connexion
  Future<Map<String, dynamic>> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      print('AuthProvider: tentative de connexion avec email: $email');
      final result = await AuthService.login(email, password);
      
      print('AuthProvider: résultat de connexion reçu: $result');
      
      if (result['success']) {
        if (result['user'] != null) {
          _user = result['user'];
          _isLoggedIn = true;
          print('AuthProvider: utilisateur connecté avec succès: ${_user?.email}');
        } else {
          // Si login a réussi mais que l'utilisateur est null, c'est une erreur
          print('Erreur: Login réussi mais utilisateur null');
          return {
            'success': false,
            'message': 'Erreur de connexion: Données utilisateur manquantes',
          };
        }
      }
      
      return result;
    } catch (e) {
      print('Exception dans le provider login: $e');
      return {
        'success': false,
        'message': 'Erreur lors de la connexion: $e',
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Déconnexion
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await AuthService.logout();
      _user = null;
      _isLoggedIn = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }  // Inscription
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String firstname,
    required String lastname,
    String? phone,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await AuthService.register(
        email: email,
        password: password,
        firstname: firstname,
        lastname: lastname,
        phone: phone,
      );
      
      if (result['success']) {
        // L'inscription ne connecte pas automatiquement l'utilisateur
        // il doit se connecter après l'inscription
        _isLoggedIn = false;
      }
      
      return result;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Rafraîchir les informations utilisateur depuis le token
  Future<void> refreshUserFromToken() async {
    if (!_isLoggedIn) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final result = await AuthService.getProfile();
      if (result['success'] && result['user'] != null) {
        _user = result['user'];
        print('Informations utilisateur rafraîchies depuis le token: ${_user?.email}');
      }
    } catch (e) {
      print('Erreur lors du rafraîchissement des informations utilisateur: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
