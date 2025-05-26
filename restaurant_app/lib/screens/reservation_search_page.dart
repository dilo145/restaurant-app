import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/reservation.dart';
import '../services/reservation_service.dart';
import '../utils/constants.dart';
import '../widgets/auth_button.dart';
import 'reservation_form_page.dart';

class ReservationSearchPage extends StatefulWidget {
  const ReservationSearchPage({super.key});

  @override
  State<ReservationSearchPage> createState() => _ReservationSearchPageState();
}

class _ReservationSearchPageState extends State<ReservationSearchPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  bool _isLoading = false;
  List<TimeSlotAvailability> _availableTimeSlots = [];
  TimeSlotAvailability? _selectedTimeSlot;

  @override
  void initState() {
    super.initState();
    _loadAvailableTimeSlots();
  }
  Future<void> _loadAvailableTimeSlots() async {
    setState(() {
      _isLoading = true;
      _selectedTimeSlot = null;
    });

    try {
      // Utiliser le service pour récupér// er les disponibilités réelles
      final timeSlots = await ReservationService.getAvailableT// imeSlots(_selectedDa// y);
      
    //   setState(() {
    //     _availableTimeSlots = timeSlots;
    //     _isLoading = false;
    //   });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement des disponibilités: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      setState(() {
        _isLoading = false;
        _availableTimeSlots = [];
      });
    }
  }

  void _selectTimeSlot(TimeSlotAvailability timeSlot) {
    setState(() {
      _selectedTimeSlot = timeSlot;
    });
  }

  void _proceedToReservation() {
    if (_selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner un créneau horaire'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReservationFormPage(
          date: _selectedDay,
          timeSlot: _selectedTimeSlot!,
        ),
      ),
    ).then((_) {
      // Rafraîchir les disponibilités au retour du formulaire
      _loadAvailableTimeSlots();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Réserver une table', style: AppStyles.appBarTitle),
        elevation: 4,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: const [
          AuthButton(),
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
                  firstDay: DateTime.now(),
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
                    _loadAvailableTimeSlots();
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
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.event, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Text(
                    'Date sélectionnée: ${DateFormat('EEEE d MMMM yyyy').format(_selectedDay)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBrown,
                    ),
                  ),
                ],
              ),
            ),

            // Liste des créneaux horaires
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                  : _availableTimeSlots.isEmpty
                      ? const Center(
                          child: Text('Aucun créneau disponible pour cette date'),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _availableTimeSlots.length,
                          itemBuilder: (context, index) {
                            final timeSlot = _availableTimeSlots[index];
                            final isSelected = _selectedTimeSlot == timeSlot;

                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              elevation: isSelected ? 4 : 2,
                              color: isSelected
                                  ? AppColors.primary.withOpacity(0.1)
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: ListTile(
                                onTap: timeSlot.isAvailable
                                    ? () => _selectTimeSlot(timeSlot)
                                    : null,
                                leading: Icon(
                                  Icons.access_time,
                                  color: timeSlot.isAvailable
                                      ? AppColors.primary
                                      : Colors.grey,
                                ),
                                title: Text(
                                  '${timeSlot.timeSlot}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: timeSlot.isAvailable
                                        ? AppColors.textBrown
                                        : Colors.grey,
                                  ),
                                ),
                                subtitle: Text(
                                  timeSlot.isAvailable
                                      ? '${timeSlot.availableSeats} place${timeSlot.availableSeats > 1 ? 's' : ''} disponible${timeSlot.availableSeats > 1 ? 's' : ''}'
                                      : 'Complet',
                                  style: TextStyle(
                                    color: timeSlot.isAvailable
                                        ? timeSlot.availableSeats < 5
                                            ? Colors.orange
                                            : Colors.green
                                        : Colors.red,
                                  ),
                                ),
                                trailing: timeSlot.isAvailable
                                    ? isSelected
                                        ? Icon(Icons.check_circle,
                                            color: AppColors.primary)
                                        : Icon(Icons.radio_button_unchecked,
                                            color: Colors.grey.shade400)
                                    : null,
                              ),
                            );
                          },
                        ),
            ),

            // Bouton de réservation
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _selectedTimeSlot?.isAvailable == true
                    ? _proceedToReservation
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Continuer',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                    Icons.restaurant,
                    color: Colors.white,
                    size: 40,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Le Gourmet Français',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Restaurant de prestige',
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
              leading: Icon(Icons.event_available, color: AppColors.primary),
              title: const Text('Réserver une table'),
              selected: true,
              selectedColor: AppColors.primary,
              onTap: () {
                Navigator.pop(context);
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
