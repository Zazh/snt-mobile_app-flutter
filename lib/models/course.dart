// Модель курса
class Course {
  final int id;
  final String title;
  final String subtitle;
  final List<String> tags;
  final String category;
  final int lessonsCount;
  final double progress; // прогресс курса от 0.0 до 1.0
  final List<Lesson> lessons; // список уроков курса

  Course({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.tags,
    required this.category,
    required this.lessonsCount,
    this.progress = 0.0,
    this.lessons = const [],
  });

  // Проверяем, начат ли курс
  bool get isStarted => progress > 0.0;
}

// Модель урока
class Lesson {
  final int id;
  final String title;
  final List<String> tags;
  final bool isCompleted;
  final bool isLocked;
  final String part;

  Lesson({
    required this.id,
    required this.title,
    required this.tags,
    required this.isCompleted,
    required this.isLocked,
    required this.part,
  });
}