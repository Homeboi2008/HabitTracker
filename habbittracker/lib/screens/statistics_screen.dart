import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/habit_viewmodel.dart';
import '../viewmodels/quote_viewmodel.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => QuoteViewModel()..loadQuote()),
        ],
        child: Consumer2<HabitViewModel, QuoteViewModel>(
          builder: (context, habitViewModel, quoteViewModel, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Общая статистика:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (habitViewModel.habits.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text(
                          'Нет привычек для отображения статистики',
                          style: TextStyle(fontSize: 16, color: Color(0xFF757575)),
                        ),
                      ),
                    )
                  else
                    ...habitViewModel.habits.map((habit) => Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: StatisticItem(
                            habitName: habit.title,
                            completedDays: habit.completedDays,
                            targetDays: habit.targetDays,
                          ),
                        )),
                  const SizedBox(height: 32),
                  const Divider(
                    thickness: 1,
                    color: Color(0xFFE0E0E0),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Мотивация:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildQuoteSection(quoteViewModel),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: quoteViewModel.isLoading
                          ? null
                          : () => quoteViewModel.loadQuote(),
                      icon: quoteViewModel.isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.refresh),
                      label: Text(quoteViewModel.isLoading ? 'Загрузка...' : 'Обновить цитату'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildQuoteSection(QuoteViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (viewModel.error != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEBEE),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.red.shade300,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 32),
            const SizedBox(height: 8),
            Text(
              viewModel.error!,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (viewModel.quote == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
        child: const Text(
          '"Путь в тысячу миль начинается с одного шага"',
          style: TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
            color: Color(0xFF212121),
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            '"${viewModel.quote!.content}"',
            style: const TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Color(0xFF212121),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '— ${viewModel.quote!.author}',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF757575),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class StatisticItem extends StatelessWidget {
  final String habitName;
  final int completedDays;
  final int targetDays;

  const StatisticItem({
    super.key,
    required this.habitName,
    required this.completedDays,
    required this.targetDays,
  });

  double get _progress => targetDays > 0 ? completedDays / targetDays : 0.0;
  int get _percentage => (_progress * 100).round();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          habitName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: _progress,
            minHeight: 20,
            backgroundColor: const Color(0xFFE0E0E0),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$_percentage% ($completedDays/$targetDays)',
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF757575),
          ),
        ),
      ],
    );
  }
}
