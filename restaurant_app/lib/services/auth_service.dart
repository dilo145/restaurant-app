import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {  // URL de base à adapter selon votre configuration de serveur
  // static const String baseUrl = 'http://localhost:8000/api'; // Pour le web
  static const String baseUrl = 'http://localhost:8000/api'; // Pour l'émulateur Android
  static const String tokenKey = 'auth_token';

  // Obtenir le token stocké
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  // Stocker le token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  // Supprimer le token
  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  // Vérifier si l'utilisateur est connecté
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
  
  // Décoder le token JWT pour extraire les informations utilisateur
  static Map<String, dynamic>? decodeToken(String token) {
    try {
      // Un token JWT est composé de trois parties séparées par des points
      final parts = token.split('.');
      if (parts.length != 3) {
        print('Format de token invalide');
        return null;
      }
      
      // La deuxième partie contient les informations (payload)
      String payload = parts[1];
      
      // Ajouter des '=' pour compléter la base64 si nécessaire
      while (payload.length % 4 != 0) {
        payload += '=';
      }
      
      // Remplacer les caractères spéciaux pour la base64Url
      payload = payload.replaceAll('-', '+').replaceAll('_', '/');
      
      // Décoder la chaîne base64
      final decoded = utf8.decode(base64Url.decode(payload));
      final payloadMap = jsonDecode(decoded);
      
      print('Payload décodé: $payloadMap');
      return payloadMap;
    } catch (e) {
      print('Erreur lors du décodage du token: $e');
      return null;
    }
  }
  // Connexion
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('Tentative de connexion avec email: $email');
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('Réponse reçue avec statut: ${response.statusCode}');
      print('Contenu de la réponse: ${response.body}');

      // Vérifier si la réponse est vide
      if (response.body.isEmpty) {
        print('Erreur: Réponse vide du serveur');
        return {
          'success': false,
          'message': 'Réponse vide du serveur',
        };
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Vérifier et sauvegarder le token JWT
        if (data['token'] == null) {
          print('Erreur: Token manquant dans la réponse');
          return {
            'success': false,
            'message': 'Format de réponse invalide: token manquant',
          };
        }
        
        final token = data['token'];
        await saveToken(token);
        
        // Extraire les informations utilisateur du token JWT
        final payload = decodeToken(token);
        
        if (payload != null) {
          // Créer un utilisateur à partir des informations du token
          try {
            final user = User(
              id: payload['id'] ?? 0,
              email: payload['email'] ?? email,
              firstname: payload['firstname'] ?? 'Utilisateur',
              lastname: payload['lastname'] ?? '',
              phone: payload['phone'],
              address: payload['address'],
              role: payload['role'] ?? 'user',
            );
            
            return {
              'success': true,
              'user': user,
              'message': 'Connexion réussie',
            };
          } catch (e) {
            print('Erreur lors de la création de l\'utilisateur à partir du token: $e');
          }
        }
        
        // Fallback si le décodage du token a échoué
        final user = User(
          id: 0,
          email: email,
          firstname: 'Utilisateur',
          lastname: '',
          role: 'user',
        );
        
        return {
          'success': true,
          'user': user,
          'message': 'Connexion réussie',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Erreur de connexion: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Exception lors de la connexion: $e');
      return {
        'success': false,
        'message': 'Erreur de connexion: $e',
      };
    }
  }

  // Inscription
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String firstname,
    required String lastname,
    String? phone,
  }) async {
    try {
      final body = {
        'email': email,
        'password': password,
        'firstname': firstname,
        'lastname': lastname,
      };

      if (phone != null && phone.isNotEmpty) {
        body['phone'] = phone;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'] ?? 'Inscription réussie',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Erreur lors de l\'inscription',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur lors de l\'inscription: $e',
      };
    }
  }
  // Obtenir le profil utilisateur
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = await getToken();
      if (token == null) {
        print('Token non trouvé lors de la récupération du profil');
        return {
          'success': false,
          'message': 'Token non trouvé',
        };
      }

      print('Token trouvé, extraction des informations utilisateur');
      
      // Extraire les informations utilisateur du token JWT
      final payload = decodeToken(token);
      
      if (payload != null) {
        try {
          // Créer un utilisateur à partir des informations du token
          final user = User(
            id: payload['id'] ?? 0,
            email: payload['email'] ?? 'utilisateur@exemple.com',
            firstname: payload['firstname'] ?? 'Utilisateur',
            lastname: payload['lastname'] ?? 'Connecté',
            phone: payload['phone'],
            // l'adresse n'est pas incluse dans le token, donc on utilise une valeur par défaut
            role: payload['role'] ?? 'user',
          );
          
          return {
            'success': true,
            'user': user,
          };
        } catch (e) {
          print('Erreur lors de la création de l\'objet User depuis le token: $e');
          return {
            'success': false,
            'message': 'Erreur lors du traitement des données utilisateur: $e',
          };
        }
      } else {
        print('Erreur: Impossible de décoder le token');
        return {
          'success': false,
          'message': 'Impossible de décoder le token',
        };
      }
    } catch (e) {
      print('Exception lors de la récupération du profil: $e');
      return {
        'success': false,
        'message': 'Erreur lors de la récupération du profil: $e',
      };
    }
  }
  // Vérifier l'authentification et récupérer le profil utilisateur au démarrage
  static Future<User?> getCurrentUser() async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        return null;
      }
      
      // Extraire les informations utilisateur du token JWT
      final payload = decodeToken(token);
      
      if (payload != null) {
        // Créer un utilisateur à partir des informations du token
        return User(
          id: payload['id'] ?? 0,
          email: payload['email'] ?? 'utilisateur@exemple.com',
          firstname: payload['firstname'] ?? 'Utilisateur',
          lastname: payload['lastname'] ?? 'Connecté',
          phone: payload['phone'],
          address: payload['address'],
          role: payload['role'] ?? 'user',
        );
      }
      
      return null;
    } catch (e) {
      print('Erreur lors de la récupération de l\'utilisateur courant: $e');
      return null;
    }
  }

  // Déconnexion
  static Future<Map<String, dynamic>> logout() async {
    try {
      final token = await getToken();
      if (token != null) {
        await http.post(
          Uri.parse('$baseUrl/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }

      await removeToken();
      
      return {
        'success': true,
        'message': 'Déconnexion réussie',
      };
    } catch (e) {
      await removeToken(); // Supprimer le token même en cas d'erreur
      return {
        'success': true,
        'message': 'Déconnexion réussie',
      };
    }
  }
}
