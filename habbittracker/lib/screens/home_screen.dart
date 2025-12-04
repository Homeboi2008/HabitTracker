import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои Привычки'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: null,
            tooltip: 'Статистика',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: const [
                HabitCard(
                  title: 'Читать 30 минут',
                  description: 'Описание: чтение книг',
                  completedDays: 15,
                  targetDays: 30,
                  isCompleted: false,
                ),
                SizedBox(height: 12),
                HabitCard(
                  title: 'Пить воду (8 стаканов)',
                  description: 'Описание: здоровье',
                  completedDays: 20,
                  targetDays: 30,
                  isCompleted: true,
                ),
                SizedBox(height: 12),
                HabitCard(
                  title: 'Зарядка утром',
                  description: 'Описание: спорт',
                  completedDays: 5,
                  targetDays: 30,
                  isCompleted: false,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.add),
              label: const Text('Добавить привычку'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HabitCard extends StatelessWidget {
  final String title;
  final String description;
  final int completedDays;
  final int targetDays;
  final bool isCompleted;

  const HabitCard({
    super.key,
    required this.title,
    required this.description,
    required this.completedDays,
    required this.targetDays,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: isCompleted,
                  onChanged: null,
                  activeColor: const Color(0xFF4CAF50),
                ),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: null,
                  color: Colors.red,
                  tooltip: 'Удалить',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF757575),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$completedDays/$targetDays дней',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF2196F3),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

