class Task {
  final String id;
  final String title;
  final String details;
  final String instructions;
  final String category;

  const Task({
    required this.id,
    required this.title,
    required this.details,
    required this.instructions,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'details': details,
      'instructions': instructions,
      'category': category,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      details: json['details'],
      instructions: json['instructions'],
      category: json['category'],
    );
  }
}
