// pages/coach_details_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meyar/EmployeeApplication/CoachPage/CoachCredentials.dart';
import 'package:meyar/EmployeeApplication/CoachPage/Details/CoachDetailSection.dart';
import 'package:meyar/EmployeeApplication/CoachPage/CoachExpertiseSection.dart';
import 'package:meyar/EmployeeApplication/CoachPage/Details/CoachTestimonialsSection.dart';

import 'package:meyar/util/Colors.dart';
import 'package:meyar/EmployeeApplication/CoachPage/Details/Packages.dart';
import 'package:meyar/models/coache.dart';
import 'package:meyar/util/booking_calendar_modal.dart';
import 'package:meyar/util/CoachDetailHeader.dart';

class CoachDetailsPage extends StatefulWidget {
  final Coach coach;

  const CoachDetailsPage({Key? key, required this.coach}) : super(key: key);

  @override
  State<CoachDetailsPage> createState() => _CoachDetailsPageState();
}

class _CoachDetailsPageState extends State<CoachDetailsPage> {
  bool showBookingCalendar = false;
  Map<String, dynamic>? selectedSession;
  DateTime? selectedDay;
  DateTime focusedDay = DateTime.now();
  String? selectedTimeSlot;

  void _showBookingCalendar(Map<String, dynamic> session) {
    setState(() {
      showBookingCalendar = true;
      selectedSession = session;
    });
  }

  void _handleDaySelected(DateTime selected, DateTime focused) {
    setState(() {
      selectedDay = selected;
      focusedDay = focused;
      selectedTimeSlot = null;
    });
  }

  void _handleTimeSlotSelected(String? timeSlot) {
    setState(() {
      selectedTimeSlot = timeSlot;
    });
  }

  void _handleBookingConfirmed() {
    if (selectedDay != null && selectedTimeSlot != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Booking confirmed for ${DateFormat('MMM d, y').format(selectedDay!)} at $selectedTimeSlot',
          ),
          backgroundColor: AppColors.successColor,
        ),
      );
      setState(() {
        showBookingCalendar = false;
        selectedSession = null;
        selectedDay = null;
        selectedTimeSlot = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              CoachDetailHeader(coach: widget.coach),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CoachDetailSection(
                        title: 'About',
                        child: Text(
                          widget.coach.detailedDescription,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      CoachDetailSection(
                        title: 'Areas of Expertise',
                        child: CoachExpertiseSection(
                          expertise: widget.coach.expertise,
                        ),
                      ),
                      const SizedBox(height: 24),
                      CoachDetailSection(
                        title: 'Credentials',
                        child: CoachCredentials(
                          credentials: widget.coach.credentials,
                        ),
                      ),
                      const SizedBox(height: 24),
                      CoachDetailSection(
                        title: 'Coaching Packages',
                        child: PackagesSection(
                          sessionTypes: widget.coach.sessionTypes,
                          onBookSession: _showBookingCalendar,
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (widget.coach.testimonials.isNotEmpty)
                        CoachDetailSection(
                          title: 'Client Testimonials',
                          child: CoachTestimonialsSection(
                            testimonials: widget.coach.testimonials,
                          ),
                        ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (showBookingCalendar)
            BookingCalendarModal(
              coach: widget.coach,
              selectedSession: selectedSession!,
              selectedDay: selectedDay,
              focusedDay: focusedDay,
              selectedTimeSlot: selectedTimeSlot,
              onDaySelected: _handleDaySelected,
              onTimeSlotSelected: _handleTimeSlotSelected,
              onClose: () {
                setState(() {
                  showBookingCalendar = false;
                  selectedSession = null;
                  selectedDay = null;
                  selectedTimeSlot = null;
                });
              },
              onConfirm: _handleBookingConfirmed,
            ),
        ],
      ),
    );
  }
}
