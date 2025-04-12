import 'package:flutter/material.dart';
import 'package:meyar/util/Colors.dart';

class CoachCredentials extends StatelessWidget {
  final List<String> credentials;

  const CoachCredentials({Key? key, required this.credentials})
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
