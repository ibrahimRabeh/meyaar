class Coach {
  final String id;
  final String name;
  final String title;
  final String category;
  final String subCategory;
  final String description;
  final String detailedDescription;
  final String image;
  final double rating;
  final int clientCount;
  final int yearsExperience;
  final List<String> expertise;
  final List<String> languages;
  final List<String> credentials;
  final Map<String, dynamic> location;
  final Map<String, dynamic> availability;
  final List<Map<String, dynamic>> sessionTypes;
  final List<Map<String, dynamic>> packages;
  final List<Map<String, dynamic>> testimonials;

  Coach({
    required this.id,
    required this.name,
    required this.title,
    required this.category,
    required this.subCategory,
    required this.description,
    required this.detailedDescription,
    required this.image,
    required this.rating,
    required this.clientCount,
    required this.yearsExperience,
    required this.expertise,
    required this.languages,
    required this.credentials,
    required this.location,
    required this.availability,
    required this.sessionTypes,
    required this.packages,
    required this.testimonials,
  });

  factory Coach.fromJson(Map<String, dynamic> json) {
    return Coach(
      id: json['id'],
      name: json['name'],
      title: json['title'],
      category: json['category'],
      subCategory: json['subCategory'],
      description: json['description'],
      detailedDescription: json['detailedDescription'],
      image: json['image'],
      rating: json['rating'].toDouble(),
      clientCount: json['clientCount'],
      yearsExperience: json['yearsExperience'],
      expertise: List<String>.from(json['expertise']),
      languages: List<String>.from(json['languages']),
      credentials: List<String>.from(json['credentials']),
      location: json['location'],
      availability: json['availability'],
      sessionTypes: List<Map<String, dynamic>>.from(json['sessionTypes']),
      packages: List<Map<String, dynamic>>.from(json['packages']),
      testimonials: List<Map<String, dynamic>>.from(json['testimonials']),
    );
  }
}
