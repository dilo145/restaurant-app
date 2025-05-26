import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/reservation.dart';
import '../services/reservation_service.dart';
import '../utils/constants.dart';
import '../widgets/auth_button.dart';

class AdminReservationsPage extends StatefulWidget {
  const AdminReservationsPage({super.key});

  @override
  State<AdminReservationsPage> createState() => _AdminReservationsPageState();
}

class _AdminReservationsPageState extends State<AdminReservationsPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<Reservation> _reservations = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }
  Future<void> _loadReservations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Récupérer les réservations pour la date sélectionnée
      final reservations = await ReservationService.getReservationsByDate(_selectedDay);
      
      setState(() {
        _reservations = reservations;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement des réservations: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      setState(() {
        _isLoading = false;
      });
    }
  }
  Future<void> _updateReservationStatus(Reservation reservation, String newStatus) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getStatusActionText(newStatus)),
        content: Text('Êtes-vous sûr de vouloir ${_getStatusActionVerb(newStatus)} cette réservation ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Mettre à jour le statut via le service API
      final result = await ReservationService.updateReservationStatus(reservation.id!, newStatus);
      
      if (result['success'] == true) {
        await _loadReservations();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la mise à jour du statut: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getStatusActionText(String status) {
    switch (status) {
      case 'confirmed':
        return 'Confirmer la réservation';
      case 'rejected':
        return 'Refuser la réservation';
      case 'completed':
        return 'Marquer comme terminée';
      case 'cancelled':
        return 'Annuler la réservation';
      default:
        return 'Modifier le statut';
    }
  }

  String _getStatusActionVerb(String status) {
    switch (status) {
      case 'confirmed':
        return 'confirmer';
      case 'rejected':
        return 'refuser';
      case 'completed':
        return 'marquer comme terminée';
      case 'cancelled':
        return 'annuler';
      default:
        return 'modifier';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'En attente';
      case 'confirmed':
        return 'Confirmée';
      case 'rejected':
        return 'Refusée';
      case 'completed':
        return 'Terminée';
      case 'cancelled':
        return 'Annulée';
      default:
        return 'Inconnue';
    }
  }
  
  List<PopupMenuItem<String>> _buildStatusMenuItems(String currentStatus) {
    final items = <PopupMenuItem<String>>[];
    
    if (currentStatus != 'confirmed') {
      items.add(const PopupMenuItem(
        value: 'confirmed',
        child: Text('Confirmer'),
      ));
    }
    
    if (currentStatus != 'rejected') {
      items.add(const PopupMenuItem(
        value: 'rejected',
        child: Text('Refuser'),
      ));
    }
    
    if (currentStatus != 'completed' && 
        (currentStatus == 'confirmed' || currentStatus == 'pending')) {
      items.add(const PopupMenuItem(
        value: 'completed',
        child: Text('Marquer comme terminée'),
      ));
    }
    
    if (currentStatus != 'cancelled' && 
        (currentStatus == 'pending' || currentStatus == 'confirmed')) {
      items.add(const PopupMenuItem(
        value: 'cancelled',
        child: Text('Annuler'),
      ));
    }
    
    return items;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Gestion des réservations', style: AppStyles.appBarTitle),
        elevation: 4,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadReservations,
          ),
          const AuthButton(),
        ],
      ),
      drawer: _buildDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, AppColors.background],
          ),
        ),
        child: Column(
          children: [
            // Calendrier
            Card(
              margin: const EdgeInsets.all(8.0),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TableCalendar(
                  firstDay: DateTime.now().subtract(const Duration(days: 30)),
                  lastDay: DateTime.now().add(const Duration(days: 30)),
                  focusedDay: _focusedDay,
                  calendarFormat: CalendarFormat.week,
                  availableCalendarFormats: const {
                    CalendarFormat.week: 'Semaine',
                    CalendarFormat.month: 'Mois',
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    _loadReservations();
                  },
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    formatButtonDecoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    formatButtonTextStyle: TextStyle(color: AppColors.primary),
                    titleTextStyle: TextStyle(
                      color: AppColors.textBrown,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    markersMaxCount: 0,
                  ),
                ),
              ),
            ),

            // Date sélectionnée
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Text(
                'Réservations du ${DateFormat('EEEE d MMMM yyyy').format(_selectedDay)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBrown,
                ),
              ),
            ),

            // Liste des réservations
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                  : _reservations.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.event_busy,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Aucune réservation pour cette date',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _reservations.length,
                          itemBuilder: (context, index) {
                            final reservation = _reservations[index];
                            
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(reservation.status)
                                                .withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            _getStatusText(reservation.status),
                                            style: TextStyle(
                                              color: _getStatusColor(reservation.status),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        PopupMenuButton<String>(
                                          icon: const Icon(Icons.more_vert),
                                          onSelected: (status) {
                                            _updateReservationStatus(reservation, status);
                                          },
                                          itemBuilder: (context) {
                                            return _buildStatusMenuItems(reservation.status);
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Icon(Icons.access_time, color: AppColors.primary),
                                        const SizedBox(width: 8),
                                        Text(
                                          reservation.timeSlot,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.person, color: AppColors.primary),
                                        const SizedBox(width: 8),
                                        Text(
                                          reservation.customerName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.phone, color: AppColors.primary),
                                        const SizedBox(width: 8),
                                        Text(
                                          reservation.customerPhone,
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.people, color: AppColors.primary),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${reservation.numberOfGuests} personne${reservation.numberOfGuests > 1 ? 's' : ''}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (reservation.additionalNotes != null) ...[
                                      const SizedBox(height: 12),
                                      const Divider(),
                                      const SizedBox(height: 8),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(Icons.note, color: AppColors.primary),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'Notes: ${reservation.additionalNotes}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: AppColors.background,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primary),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.admin_panel_settings,
                    color: Colors.white,
                    size: 40,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Administration',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Gestion des réservations',
                    style: TextStyle(
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
            const Divider(),
            ListTile(
              leading: Icon(Icons.admin_panel_settings, color: AppColors.primary),
              title: const Text('Gestion des réservations'),
              selected: true,
              selectedColor: AppColors.primary,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: AppColors.textBrown),
              title: const Text('Mon Profil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ],
        ),
      ),
    );
  }
}
