// pages/coach_details_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meyar/Colors.dart';
import 'package:meyar/models/coache.dart';
import 'package:meyar/widget/booking_calendar_modal.dart';
import 'package:meyar/widget/coach_detail_sections.dart';

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
                      DetailSection(
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
                      DetailSection(
                        title: 'Areas of Expertise',
                        child: ExpertiseSection(
                          expertise: widget.coach.expertise,
                        ),
                      ),
                      const SizedBox(height: 24),
                      DetailSection(
                        title: 'Credentials',
                        child: CredentialsSection(
                          credentials: widget.coach.credentials,
                        ),
                      ),
                      const SizedBox(height: 24),
                      DetailSection(
                        title: 'Coaching Packages',
                        child: PackagesSection(
                          sessionTypes: widget.coach.sessionTypes,
                          onBookSession: _showBookingCalendar,
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (widget.coach.testimonials.isNotEmpty)
                        DetailSection(
                          title: 'Client Testimonials',
                          child: TestimonialsSection(
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

class CredentialsSection extends StatelessWidget {
  final List<String> credentials;

  const CredentialsSection({Key? key, required this.credentials})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: credentials.map((credential) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: AppColors.successColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  credential,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class PackagesSection extends StatelessWidget {
  final List<Map<String, dynamic>> sessionTypes;
  final Function(Map<String, dynamic>) onBookSession;

  const PackagesSection({
    Key? key,
    required this.sessionTypes,
    required this.onBookSession,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 768; // Breakpoint for desktop

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDesktop ? 2 : 1,
            childAspectRatio: isDesktop
                ? 3
                : 1.8, // Adjust these values based on your content
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: sessionTypes.length,
          itemBuilder: (context, index) {
            final session = sessionTypes[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            session['type'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Text(
                          '${session['currency']} ${session['price']}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Duration: ${session['duration']}',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        session['description'],
                        style: TextStyle(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => onBookSession(session),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Book Now',
                            style: TextStyle(color: AppColors.backgroundColor)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class TestimonialsSection extends StatelessWidget {
  final List<Map<String, dynamic>> testimonials;

  const TestimonialsSection({Key? key, required this.testimonials})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: testimonials.map((testimonial) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          testimonial['client'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${testimonial['role']} at ${testimonial['company']}',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: AppColors.accentColor,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          testimonial['rating'].toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  testimonial['text'],
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
