import 'package:meyar/DashBoard/models/Department.dart';
import 'package:meyar/DashBoard/models/Employee.dart';

final List<Department> departmentsData = [
  Department(
    id: 1,
    name: "Engineering",
    averageScore: 85,
    employees: [
      Employee(
          id: 1, name: "Ahmad Al-Sayed", role: "Senior Developer", score: 92),
      Employee(
          id: 2, name: "Fatima Hassan", role: "Frontend Developer", score: 88),
      Employee(
          id: 3, name: "Omar Khalil", role: "Backend Developer", score: 85),
      Employee(
          id: 4, name: "Layla Ibrahim", role: "DevOps Engineer", score: 90),
    ],
  ),
  Department(
    id: 2,
    name: "Marketing",
    averageScore: 78,
    employees: [
      Employee(id: 5, name: "Noura Ali", role: "Marketing Manager", score: 80),
      Employee(
          id: 6,
          name: "Sara Ahmed",
          role: "Social Media Specialist",
          score: 75),
      Employee(id: 7, name: "Ali Hassan", role: "SEO Specialist", score: 82),
      Employee(id: 8, name: "Hassan Omar", role: "Content Creator", score: 78),
    ],
  ),
  Department(
    id: 3,
    name: "Sales",
    averageScore: 70,
    employees: [
      Employee(id: 9, name: "Khaled Ali", role: "Sales Manager", score: 72),
      Employee(id: 10, name: "Nada Hassan", role: "Sales Executive", score: 68),
      Employee(id: 11, name: "Sami Ahmed", role: "Sales Executive", score: 70),
      Employee(id: 12, name: "Lina Omar", role: "Sales Executive", score: 75),
    ],
  ),
  Department(
    id: 4,
    name: "Finance",
    averageScore: 82,
    employees: [
      Employee(id: 13, name: "Hassan Ali", role: "Finance Manager", score: 85),
      Employee(id: 14, name: "Noura Hassan", role: "Accountant", score: 80),
      Employee(
          id: 15, name: "Sara Ahmed", role: "Financial Analyst", score: 78),
      Employee(id: 16, name: "Ali Omar", role: "Auditor", score: 85),
    ],
  ),
];
