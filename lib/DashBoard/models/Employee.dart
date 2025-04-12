import 'package:meyar/DashBoard/PopUp/employeepopup.dart';

class Employee {
  final int id;
  final String name;
  final String role;
  final double score;

  Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.score,
  });
}

final List<EmployeeData> employees = [
  EmployeeData(
    name: "Sarah Chen",
    role: "Frontend Developer",
    strengths: ["UI/UX expertise", "Fast learner", "Team collaboration"],
    weaknesses: ["Backend integration", "Time management"],
  ),
  EmployeeData(
    name: "Marcus Johnson",
    role: "Project Manager",
    strengths: [
      "Strategic planning",
      "Client communication",
      "Risk management"
    ],
    weaknesses: ["Technical depth", "Delegation"],
  ),
  EmployeeData(
    name: "Aisha Patel",
    role: "Data Analyst",
    strengths: [
      "Statistical analysis",
      "Data visualization",
      "Problem solving"
    ],
    weaknesses: ["Public speaking", "Documentation"],
  ),
  EmployeeData(
    name: "David Kim",
    role: "Backend Developer",
    strengths: [
      "System architecture",
      "Performance optimization",
      "Code quality"
    ],
    weaknesses: ["Frontend design", "Meeting deadlines"],
  ),
];
