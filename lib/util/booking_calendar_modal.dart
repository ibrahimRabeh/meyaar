// widgets/booking_calendar_modal.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:meyar/util/Colors.dart';
import 'package:meyar/models/coache.dart';

class BookingCalendarModal extends StatelessWidget {
  final Coach coach;
  final Map<String, dynamic> selectedSession;
  final DateTime? selectedDay;
  final DateTime focusedDay;
  final String? selectedTimeSlot;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(String?) onTimeSlotSelected;
  final VoidCallback onClose;
  final VoidCallback onConfirm;

  const BookingCalendarModal({
    Key? key,
    required this.coach,
    required this.selectedSession,
    required this.selectedDay,
    required this.focusedDay,
    required this.selectedTimeSlot,
    required this.onDaySelected,
    required this.onTimeSlotSelected,
    required this.onClose,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Container(
        color: Colors.black54,
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Prevent closing when clicking inside
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildCalendar(),
                  if (selectedDay != null) ...[
                    const SizedBox(height: 16),
                    _buildTimeSlots(),
                  ],
                  const SizedBox(height: 24),
                  _buildConfirmButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Book a Session',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: onClose,
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.now(),
      lastDay: DateTime.now().add(const Duration(days: 60)),
      focusedDay: focusedDay,
      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      onDaySelected: onDaySelected,
      calendarFormat: CalendarFormat.month,
      availableCalendarFormats: const {CalendarFormat.month: 'Month'},
      enabledDayPredicate: (day) {
        final weekday = DateFormat('EEEE').format(day);
        return coach.availability['weekdays'].contains(weekday);
      },
    );
  }

  Widget _buildTimeSlots() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Time Slots',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: coach.availability['timeSlots'].map<Widget>((timeSlot) {
            final isSelected = timeSlot == selectedTimeSlot;
            return ChoiceChip(
              label: Text(timeSlot),
              selected: isSelected,
              onSelected: (selected) =>
                  onTimeSlotSelected(selected ? timeSlot : null),
              selectedColor: AppColors.primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed:
            selectedDay != null && selectedTimeSlot != null ? onConfirm : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text('Confirm Booking'),
      ),
    );
  }
}
