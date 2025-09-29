import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'course_lessons_screen.dart';
import '../models/course.dart';
import 'profile_screen.dart';


class CoursesCatalogScreen extends StatefulWidget {
  const CoursesCatalogScreen({super.key});

  @override
  State<CoursesCatalogScreen> createState() => _CoursesCatalogScreenState();
}

class _CoursesCatalogScreenState extends State<CoursesCatalogScreen> {
  int _selectedTabIndex = 0;

  final List<Course> courses = [
    Course(
      id: 1,
      title: "Pick a card",
      subtitle: "Talk for 1 minute about any topic. We’ve got 40 cards with different topics that other candidates have encountered in real interviews. Practice until you feel confident showing your fluency.",
      tags: ["Начальный", "Продажи"],
      category: "Category 1",
      lessonsCount: 12,
      progress: 0.3, // 30% прогресс - курс начат
      lessons: [
        Lesson(id: 1, title: "Mystery Card 1", tags: ["Теория"], isCompleted: true, isLocked: false, part: "Part 1"),
        Lesson(id: 2, title: "Mystery Card 2", tags: ["Психология"], isCompleted: true, isLocked: false, part: "Part 1"),
        Lesson(id: 3, title: "Mystery Card 3", tags: ["Практика"], isCompleted: false, isLocked: false, part: "Part 1"),
        Lesson(id: 4, title: "Mystery Card 4", tags: ["Практика"], isCompleted: false, isLocked: false, part: "Part 2"),
      ],
    ),
    Course(
      id: 2,
      title: "Role-play scenario",
      subtitle: "Recruiters use role-play to test how you handle customer problems. They take on the role of an angry or frustrated customer, while you step into the role of a waiter, receptionist, or shop assistant. No matter what situation they come up with, practicing these scenarios will ensure you're ready for anything.",
      tags: ["Средний", "Психология", "Продажи"],
      category: "Category 1",
      lessonsCount: 8,
      progress: 0.0, // не начат
      lessons: [
        Lesson(id: 1, title: "Guest waits 40 minutes for pizza due to forgotten order", tags: ["Теория"], isCompleted: false, isLocked: false, part: "Part 1"),
        Lesson(id: 2, title: "The guest ordered seafood pasta, but the waiter brought carbonara instead", tags: ["Техника"], isCompleted: false, isLocked: false, part: "Part 1"),
        Lesson(id: 3, title: "Guest finds a hair in their food and calls the waiter over to complain", tags: ["Практика"], isCompleted: false, isLocked: false, part: "Part 2"),
      ],
    ),
    Course(
      id: 3,
      title: "Role-play scenario for cabin crew",
      subtitle: "Experience solving real passenger problems before your interview with our Cabin Crew solutions for 50 onboard challenges. Practice and be ready for anything.",
      tags: ["Начальный", "Телефония"],
      category: "Category 1",
      lessonsCount: 15,
      progress: 0.8, // 80% прогресс
      lessons: [
        Lesson(id: 1, title: "Higher price at checkout", tags: ["Подготовка"], isCompleted: true, isLocked: false, part: "Part 1"),
        Lesson(id: 2, title: "Extremely long wait for fitting room", tags: ["Скрипты"], isCompleted: true, isLocked: false, part: "Part 1"),
        Lesson(id: 3, title: "Customer wants to return an item without a receipt", tags: ["Техника"], isCompleted: false, isLocked: false, part: "Part 2"),
      ],
    ),
    Course(
      id: 4,
      title: "Group activity",
      subtitle: "Meet your virtual teammates. Solve group exercises from real interviews with virtual teammates in a simple chat. You’ll practice expressing your opinion, offering solutions, agreeing or disagreeing with others, prioritizing, and much more.",
      tags: ["Продвинутый", "Презентации"],
      category: "Category 1",
      lessonsCount: 10,
      progress: 0.0, // не начат
      lessons: [
        Lesson(id: 1, title: "A hotel guest checks in and discovers that in-room Wi-Fi requires payment", tags: ["Структура"], isCompleted: false, isLocked: false, part: "Part 1"),
        Lesson(id: 2, title: "A hotel guest booked a room with a sea view but upon check-in discovers their room overlooks the parking lot.", tags: ["Дизайн"], isCompleted: false, isLocked: false, part: "Part 1"),
        Lesson(id: 3, title: "Guest arrives at the hotel to check in but becomes frustrated when asked to leave a deposit", tags: ["Практика"], isCompleted: false, isLocked: false, part: "Part 2"),
      ],
    ),
    Course(
      id: 5,
      title: "English test",
      subtitle: "Speak Flight Attendant English. The more fluently you speak, the higher your chances of getting hired. Don’t stress—check if your current level is enough for flying duties and focus on what needs improvement.",
      tags: ["Продвинутый", "Переговоры", "Лидерство"],
      category: "Category 2",
      lessonsCount: 6,
      progress: 0.5, // 50% прогресс
      lessons: [
        Lesson(id: 1, title: "Подготовка к переговорам", tags: ["Подготовка"], isCompleted: true, isLocked: false, part: "Part 1"),
        Lesson(id: 2, title: "Тактики переговоров", tags: ["Тактика"], isCompleted: false, isLocked: false, part: "Part 1"),
        Lesson(id: 3, title: "Win-Win решения", tags: ["Стратегия"], isCompleted: false, isLocked: false, part: "Part 2"),
      ],
    ),
    Course(
      id: 6,
      title: "Final interview",
      subtitle: "Find out what recruiters have actually asked candidates and learn how to respond to stand out and get hired.",
      tags: ["Средний", "Психология"],
      category: "Category 2",
      lessonsCount: 9,
      progress: 0.0, // не начат
      lessons: [
        Lesson(id: 1, title: "Типы покупателей", tags: ["Типология"], isCompleted: false, isLocked: false, part: "Part 1"),
        Lesson(id: 2, title: "Мотивация к покупке", tags: ["Мотивация"], isCompleted: false, isLocked: false, part: "Part 1"),
        Lesson(id: 3, title: "Эмоциональные триггеры", tags: ["Эмоции"], isCompleted: false, isLocked: false, part: "Part 2"),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final categories = courses.map((course) => course.category).toSet().toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildTopBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'All courses',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              ...categories.map((category) => _buildCategorySection(category)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  PreferredSizeWidget _buildTopBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // SVG логотип
          SvgPicture.asset(
            'assets/images/logo.svg',
            height: 32,
            width: 120,
          ),
          Row(
            children: [
              // Очки
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.yellow[300],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  '323',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Premium кнопка
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.purple[600],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'premium',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Профиль
              // Профиль
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      // Навигация на страницу профиля
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.person_outline,
                      color: Colors.black87,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(String category) {
    final categoryCourses = courses.where((course) => course.category == category).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: categoryCourses.length,
          itemBuilder: (context, index) {
            return _buildCourseCard(categoryCourses[index]);
          },
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildCourseCard(Course course) {
    return GestureDetector(
      onTap: () {
        // Переход на страницу списка уроков с передачей конкретного курса
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseLessonsScreen(course: course),
          ),
        ).then((_) {
          // Обновляем состояние после возвращения с урока
          setState(() {
            // Здесь можно обновить прогресс курса
          });
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: course.isStarted ? Colors.blue[100] : Colors.grey[200], // синий если начат, серый если нет
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: course.isStarted ? Colors.blue[200]! : Colors.grey[300]!, // синяя или серая граница
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Иконка или прогресс-бар
            _buildCourseIcon(course),
            const SizedBox(height: 12),
            // Заголовок
            Text(
              course.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            // Количество уроков (вместо подзаголовка)
            Text(
              '${course.lessonsCount} lessons',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                height: 1.3,
              ),
            ),
            const Spacer(), // Занимает оставшееся место
            // Теги
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: course.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getTagColor(tag),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: _getTagTextColor(tag),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseIcon(Course course) {
    if (course.isStarted) {
      // Показываем круговой прогресс-бар
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: SizedBox(
            width: 38, // такой же размер как у контейнера с иконкой
            height: 38,
            child: CircularProgressIndicator(
              value: course.progress,
              strokeWidth: 6,
              backgroundColor: Colors.grey[100],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
            ),
          ),
        ),
      );
    } else {
      // Показываем обычную иконку play
      return Container(
        width: 40, // такой же размер как у прогресс-бара
        height: 40,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.play_arrow,
          color: Colors.white,
          size: 24,
        ),
      );
    }
  }

  Color _getTagColor(String tag) {
    switch (tag) {
      case "Начальный":
        return Colors.green[200]!;
      case "Средний":
        return Colors.yellow[200]!;
      case "Продвинутый":
        return Colors.red[200]!;
      case "Продажи":
        return Colors.blue[200]!;
      case "Психология":
        return Colors.purple[200]!;
      case "Телефония":
        return Colors.orange[200]!;
      case "Презентации":
        return Colors.pink[200]!;
      case "Переговоры":
        return Colors.indigo[200]!;
      case "Лидерство":
        return Colors.teal[200]!;
      default:
        return Colors.grey[200]!;
    }
  }

  Color _getTagTextColor(String tag) {
    switch (tag) {
      case "Начальный":
        return Colors.green[800]!;
      case "Средний":
        return Colors.yellow[800]!;
      case "Продвинутый":
        return Colors.red[800]!;
      case "Продажи":
        return Colors.blue[800]!;
      case "Психология":
        return Colors.purple[800]!;
      case "Телефония":
        return Colors.orange[800]!;
      case "Презентации":
        return Colors.pink[800]!;
      case "Переговоры":
        return Colors.indigo[800]!;
      case "Лидерство":
        return Colors.teal[800]!;
      default:
        return Colors.grey[800]!;
    }
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedTabIndex,
      onTap: (index) => setState(() => _selectedTabIndex = index),
      selectedItemColor: Colors.blue[600],
      unselectedItemColor: Colors.grey[400],
      selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.book_outlined),
          label: 'courses',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.check_box_outlined),
          label: 'practice',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_outline),
          label: 'hints',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.auto_awesome_outlined),
          label: 'special',
        ),
      ],
    );
  }
}