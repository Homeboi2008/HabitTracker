class Habit {
  String id;
  String title;
  String description;
  int completedDays;
  int targetDays;
  bool isCompleted;

  Habit({
    required this.id,
    required this.title,
    this.description = '',
    this.completedDays = 0,
    this.targetDays = 30,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completedDays': completedDays,
      'targetDays': targetDays,
      'isCompleted': isCompleted,
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      completedDays: json['completedDays'] as int? ?? 0,
      targetDays: json['targetDays'] as int? ?? 30,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}
