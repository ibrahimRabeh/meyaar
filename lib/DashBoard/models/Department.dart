import 'package:meyar/DashBoard/models/Employee.dart';

class Department {
  final int id;
  final String name;
  final double averageScore;
  final List<Employee> employees;

  Department({
    required this.id,
    required this.name,
    required this.averageScore,
    required this.employees,
  });
}
