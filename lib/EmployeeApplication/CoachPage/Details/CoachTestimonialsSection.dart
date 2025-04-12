import 'package:flutter/material.dart';
import 'package:meyar/util/Colors.dart';

class CoachTestimonialsSection extends StatelessWidget {
  final List<Map<String, dynamic>> testimonials;

  const CoachTestimonialsSection({Key? key, required this.testimonials})
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
