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
}

