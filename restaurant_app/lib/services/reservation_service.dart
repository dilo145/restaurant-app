import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/reservation.dart';
import 'auth_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';


class ReservationService {
  static const String baseUrl = AuthService.baseUrl;

  // Récupérer les créneaux disponibles pour une date donnée
//   static Future<List<TimeSlotAvailability>> getAvailableTimeSlots(DateTime date) async {
//     try {
//       final token = await AuthService.getToken();
//       if (token == null) {
//         throw Exception('Non authentifié');
//       }

//       final dateString = DateFormat('yyyy-MM-dd').format(date);
//     //   final response = await http.get(
//     //     Uri.parse('$baseUrl/reservations/availability/$dateString'),
//     //     headers: {
//     //       'Content-Type': 'application/json',
//     //       'Authorization': 'Bearer $token',
//     //     },
//     //   );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return (data['timeSlots'] as List)
//             .map((slot) => TimeSlotAvailability.fromMap(slot))
//             .toList();
//       } else {
//         print('Erreur API: ${response.body}');
//         // Utiliser la simulation en cas d'erreur API (pour le développement)
//         return await simulateAvailableTimeSlots(date);
//       }
//     } catch (e) {
//       print('Exception lors de la récupération des créneaux: $e');
//       // Utiliser la simulation en cas d'exception (pour le développement)
//       return await simulateAvailableTimeSlots(date);
//     }
//   }
  // Créer une nouvelle réservation
  static Future<Map<String, dynamic>> createReservation(Reservation reservation) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Non authentifié',
        };
      }
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      
      // Préparer les données sans userId (l'API utilise le token pour identifier l'utilisateur)
      final reservationData = {
        'date': reservation.date.toIso8601String().split('T')[0], // Format YYYY-MM-DD
        'timeSlot': reservation.timeSlot,
        'guest_count': reservation.numberOfGuests,
        'customerName': reservation.customerName,
        'customerPhone': reservation.customerPhone,
        'user_id': decodedToken['id'],
        if (reservation.additionalNotes != null) 'additionalNotes': reservation.additionalNotes,
      };

      print('Envoi des données de réservation: ${jsonEncode(reservationData)}');

      final response = await http.post(
        Uri.parse('$baseUrl/reservations'),
        headers: {
          'Content-Type': 'application/ld+json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/ld+json',
        },
        body: jsonEncode(reservationData),
      );      print('Statut de la réponse: ${response.statusCode}');
      print('Corps de la réponse: ${response.body}');
      print('Headers de la réponse: ${response.headers}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': 'Réservation créée avec succès',
          'reservation': Reservation.fromMap(data['reservation']),
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Erreur lors de la création de la réservation',
        };
      }
    } catch (e) {
      print('Exception lors de la création de la réservation: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  // Récupérer les réservations de l'utilisateur
  static Future<List<Reservation>> getUserReservations() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        throw Exception('Non authentifié');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/reservations/user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['reservations'] as List)
            .map((reservation) => Reservation.fromMap(reservation))
            .toList();
      } else {
        throw Exception('Erreur lors de la récupération des réservations');
      }
    } catch (e) {
      print('Exception lors de la récupération des réservations: $e');
      return []; // Retourner une liste vide en cas d'erreur
    }
  }

  // Annuler une réservation
  static Future<Map<String, dynamic>> cancelReservation(int reservationId) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Non authentifié',
        };
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/reservations/$reservationId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Réservation annulée avec succès',
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Erreur lors de l\'annulation de la réservation',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }
  
  // Récupérer les réservations pour une date spécifique (admin/host uniquement)
  static Future<List<Reservation>> getReservationsByDate(DateTime date) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        throw Exception('Non authentifié');
      }

      final dateString = DateFormat('yyyy-MM-dd').format(date);
      final response = await http.get(
        Uri.parse('$baseUrl/reservations/date/$dateString'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['reservations'] as List)
            .map((reservation) => Reservation.fromMap(reservation))
            .toList();
      } else {
        print('Erreur API: ${response.body}');
        // Utiliser la simulation en cas d'erreur API (pour le développement)
        return _simulateReservationsByDate(date);
      }
    } catch (e) {
      print('Exception lors de la récupération des réservations: $e');
      // Utiliser la simulation en cas d'exception (pour le développement)
      return _simulateReservationsByDate(date);
    }
  }
  
  // Changer le statut d'une réservation (admin/host uniquement)
  static Future<Map<String, dynamic>> updateReservationStatus(int reservationId, String newStatus) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Non authentifié',
        };
      }

      final response = await http.patch(
        Uri.parse('$baseUrl/reservations/$reservationId/status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'status': newStatus}),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Statut de la réservation mis à jour avec succès',
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Erreur lors de la mise à jour du statut',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }
  
  // Simuler les données de disponibilité (à utiliser en attendant l'API backend)
  static Future<List<TimeSlotAvailability>> simulateAvailableTimeSlots(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simuler un délai réseau
    
    // Créneaux standards du restaurant
    final List<String> slots = [
      '12:00', '12:30', '13:00', '13:30', 
      '19:00', '19:30', '20:00', '20:30', '21:00'
    ];
    
    // Générer des disponibilités aléatoires
    final random = DateTime.now().millisecond;
    final isWeekend = date.weekday == 6 || date.weekday == 7; // Samedi ou dimanche
    
    return slots.map((slot) {
      // Plus de places disponibles le weekend
      final totalCapacity = isWeekend ? 30 : 20;
      final bookedSeats = (random + int.parse(slot.replaceAll(':', ''))) % (totalCapacity + 1);
      final availableSeats = totalCapacity - bookedSeats;
      
      return TimeSlotAvailability(
        timeSlot: slot,
        totalCapacity: totalCapacity,
        availableSeats: availableSeats,
        isAvailable: availableSeats > 0,
      );
    }).toList();
  }
  
  // Simuler des réservations pour une date spécifique (pour le développement)
  static List<Reservation> _simulateReservationsByDate(DateTime date) {
    final random = DateTime.now().millisecond;
    final isWeekend = date.weekday == 6 || date.weekday == 7; // Samedi ou dimanche
    
    // Générer plus de réservations le weekend
    final reservationCount = isWeekend ? 10 : 5;
    
    // Créneaux standards du restaurant
    final List<String> slots = [
      '12:00', '12:30', '13:00', '13:30', 
      '19:00', '19:30', '20:00', '20:30', '21:00'
    ];
    
    List<Reservation> reservations = [];
    
    for (int i = 0; i < reservationCount; i++) {
      final slotIndex = (random + i) % slots.length;
      final guestCount = 1 + ((random + i * 3) % 8); // Entre 1 et 8 personnes
      
      final statuses = ['pending', 'confirmed', 'completed', 'cancelled'];
      final statusIndex = (random + i) % statuses.length;
      
      reservations.add(
        Reservation(
          id: 1000 + i,
          userId: 100 + i,
          date: date,
          timeSlot: slots[slotIndex],
          numberOfGuests: guestCount,
          customerName: 'Client ${100 + i}',
          customerPhone: '06${10000000 + (random + i * 7) % 90000000}',
          status: statuses[statusIndex],
          additionalNotes: (i % 3 == 0) ? 'Demande spéciale pour la réservation $i' : null,
        ),
      );
    }
    
    return reservations;
  }
}
