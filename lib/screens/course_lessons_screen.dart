import 'package:flutter/material.dart';
import 'lesson_chat_screen.dart';
import '../models/course.dart';

class CourseLessonsScreen extends StatefulWidget {
  final Course course;

  const CourseLessonsScreen({super.key, required this.course});

  @override
  State<CourseLessonsScreen> createState() => _CourseLessonsScreenState();
}

class _CourseLessonsScreenState extends State<CourseLessonsScreen> {
  @override
  Widget build(BuildContext context) {
    // Группируем уроки по частям
    Map<String, List<Lesson>> lessonsByParts = {};
    for (var lesson in widget.course.lessons) {
      if (!lessonsByParts.containsKey(lesson.part)) {
        lessonsByParts[lesson.part] = [];
      }
      lessonsByParts[lesson.part]!.add(lesson);
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Части курса (убрали прогресс-бар)
              ...lessonsByParts.entries.map((entry) {
                return _buildPartSection(entry.key, entry.value);
              }),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        widget.course.title,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPartSection(String partName, List<Lesson> partLessons) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок части
        Text(
          partName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),

        // Уроки
        ...partLessons.map((lesson) => _buildLessonCard(lesson)),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildLessonCard(Lesson lesson) {
    final bool isAccessible = !lesson.isLocked;

    return GestureDetector(
      onTap: isAccessible ? () => _openLesson(lesson) : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: lesson.isCompleted ? Colors.green[100] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: lesson.isCompleted
                ? Colors.green[200]!
                : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Левая часть: название и теги
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Название урока (убрали галочку)
                  Text(
                    lesson.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isAccessible ? Colors.black87 : Colors.grey,
                    ),
                    maxLines: 2, // максимум 2 строки
                    overflow: TextOverflow.ellipsis, // обрезаем если не помещается
                  ),
                  const SizedBox(height: 12),

                  // Теги
                  Wrap( // Wrap позволяет тегам переноситься на новую строку
                    spacing: 8,
                    runSpacing: 4,
                    children: lesson.tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getTagColor(tag),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12), // отступ между контентом и иконкой

            // Правая часть: иконка видео или галочка
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: lesson.isCompleted ? Colors.green[600] : Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                lesson.isCompleted ? Icons.check : Icons.play_arrow,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTagColor(String tag) {
    switch (tag) {
      case "Теория":
        return Colors.blue[600]!;
      case "Практика":
        return Colors.green[600]!;
      case "Психология":
        return Colors.purple[600]!;
      case "Техника":
        return Colors.orange[600]!;
      case "Подготовка":
        return Colors.indigo[600]!;
      case "Скрипты":
        return Colors.teal[600]!;
      case "Структура":
        return Colors.red[600]!;
      case "Дизайн":
        return Colors.pink[600]!;
      case "Тактика":
        return Colors.brown[600]!;
      case "Стратегия":
        return Colors.deepOrange[600]!;
      case "Типология":
        return Colors.cyan[600]!;
      case "Мотивация":
        return Colors.lime[600]!;
      case "Эмоции":
        return Colors.amber[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  void _openLesson(Lesson lesson) {
    // Переход на экран урока
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonDetailScreen(
          characterName: lesson.title,
          audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
          lessonText: 'изучите материал и выполните практическое задание.',
        ),
      ),
    ).then((_) {
      // Можно обновить прогресс после возвращения с урока
      setState(() {
        // Здесь можно пометить урок как пройденный
        // lesson.isCompleted = true;
        // и пересчитать прогресс курса
      });
    });
  }
}