import 'package:flutter/material.dart';
import '../models/reservation.dart';
import '../services/reservation_service.dart';

class ReservationProvider extends ChangeNotifier {
  List<Reservation> _userReservations = [];
  List<Reservation> _dailyReservations = [];
  bool _isLoading = false;

  List<Reservation> get userReservations => _userReservations;
  List<Reservation> get dailyReservations => _dailyReservations;
  bool get isLoading => _isLoading;
  // Récupérer les réservations de l'utilisateur
  Future<void> fetchUserReservations() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Récupérer les réservations via le service API
      final reservations = await ReservationService.getUserReservations();
      _userReservations = reservations;
    } catch (e) {
      print('Erreur lors de la récupération des réservations: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  // Créer une nouvelle réservation
  Future<Map<String, dynamic>> createReservation(Reservation reservation) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Créer la réservation via le service API
      final result = await ReservationService.createReservation(reservation);
      
      if (result['success'] && result['reservation'] != null) {
        _userReservations.add(result['reservation']);
      }
      
      return result;
    } catch (e) {
      print('Erreur lors de la création de la réservation: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  // Annuler une réservation
  Future<Map<String, dynamic>> cancelReservation(int reservationId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Annuler la réservation via le service API
      final result = await ReservationService.cancelReservation(reservationId);
      
      if (result['success']) {
        _userReservations.removeWhere((r) => r.id == reservationId);
      }
      
      return result;
    } catch (e) {
      print('Erreur lors de l\'annulation de la réservation: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  // Récupérer les réservations pour une date spécifique (admin/host uniquement)
  Future<void> fetchReservationsByDate(DateTime date) async {
    _isLoading = true;
    notifyListeners();

    try {
      final reservations = await ReservationService.getReservationsByDate(date);
      _dailyReservations = reservations;
    } catch (e) {
      print('Erreur lors de la récupération des réservations par date: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Mettre à jour le statut d'une réservation (admin/host uniquement)
  Future<Map<String, dynamic>> updateReservationStatus(int reservationId, String newStatus) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await ReservationService.updateReservationStatus(reservationId, newStatus);
      
      if (result['success']) {
        // Mettre à jour la réservation dans les listes locales
        final dailyIndex = _dailyReservations.indexWhere((r) => r.id == reservationId);
        if (dailyIndex != -1) {
          _dailyReservations[dailyIndex] = _dailyReservations[dailyIndex].copyWith(status: newStatus);
        }
        
        final userIndex = _userReservations.indexWhere((r) => r.id == reservationId);
        if (userIndex != -1) {
          _userReservations[userIndex] = _userReservations[userIndex].copyWith(status: newStatus);
        }
      }
      
      return result;
    } catch (e) {
      print('Erreur lors de la mise à jour du statut: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
