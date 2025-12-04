import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_habit_screen.dart';
import 'statistics_screen.dart';
import '../viewmodels/habit_viewmodel.dart';

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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StatisticsScreen(),
                ),
              );
            },
            tooltip: 'Статистика',
          ),
        ],
      ),
      body: Consumer<HabitViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: viewModel.habits.isEmpty
                    ? const Center(
                        child: Text(
                          'Нет привычек. Добавьте первую!',
                          style: TextStyle(fontSize: 16, color: Color(0xFF757575)),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: viewModel.habits.length,
                        itemBuilder: (context, index) {
                          final habit = viewModel.habits[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: HabitCard(
                              habit: habit,
                              onToggle: () => viewModel.toggleHabit(habit.id),
                              onDelete: () => viewModel.deleteHabit(habit.id),
                            ),
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddHabitScreen(),
                      ),
                    );
                    if (result != null && result is Map) {
                      await viewModel.addHabit(result['title'], result['description']);
                    }
                  },
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
          );
        },
      ),
    );
  }
}

class HabitCard extends StatelessWidget {
  final dynamic habit;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onToggle,
    required this.onDelete,
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
                  value: habit.isCompleted,
                  onChanged: (_) => onToggle(),
                  activeColor: const Color(0xFF4CAF50),
                ),
                Expanded(
                  child: Text(
                    habit.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Удалить привычку?'),
                        content: Text('Вы уверены, что хотите удалить "${habit.title}"?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Отмена'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              onDelete();
                            },
                            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                  color: Colors.red,
                  tooltip: 'Удалить',
                ),
              ],
            ),
            if (habit.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                habit.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF757575),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              '${habit.completedDays}/${habit.targetDays} дней',
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
