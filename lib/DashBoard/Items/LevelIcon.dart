import 'package:flutter/material.dart';

IconData getLevelIcon(String level) {
  switch (level.toLowerCase()) {
    case 'beginner':
      return Icons.star_border;
    case 'intermediate':
      return Icons.star_half;
    case 'advanced':
      return Icons.star;
    default:
      return Icons.help_outline;
  }
}
