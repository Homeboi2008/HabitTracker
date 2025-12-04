import 'package:flutter/foundation.dart';
import '../models/habit.dart';
import '../repositories/habit_repository.dart';

class HabitViewModel extends ChangeNotifier {
  final HabitRepository _repository = HabitRepository();
  List<Habit> _habits = [];
  bool _isLoading = false;

  List<Habit> get habits => _habits;
  bool get isLoading => _isLoading;

  HabitViewModel() {
    loadHabits();
  }

  Future<void> loadHabits() async {
    _isLoading = true;
    notifyListeners();

    try {
      _habits = await _repository.loadHabits();
      
      final isInitialized = await _repository.isInitialized();
      if (!isInitialized && _habits.isEmpty) {
        _habits = _getDefaultHabits();
        for (final habit in _habits) {
          await _repository.addHabit(habit);
        }
      }
    } catch (e) {
      final isInitialized = await _repository.isInitialized();
      if (!isInitialized) {
        _habits = _getDefaultHabits();
        for (final habit in _habits) {
          await _repository.addHabit(habit);
        }
      } else {
        _habits = [];
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  List<Habit> _getDefaultHabits() {
    return [
      Habit(
        id: '1',
        title: 'Читать 30 минут',
        description: 'Описание: чтение книг',
        completedDays: 15,
        targetDays: 30,
        isCompleted: false,
      ),
      Habit(
        id: '2',
        title: 'Пить воду (8 стаканов)',
        description: 'Описание: здоровье',
        completedDays: 20,
        targetDays: 30,
        isCompleted: true,
      ),
      Habit(
        id: '3',
        title: 'Зарядка утром',
        description: 'Описание: спорт',
        completedDays: 5,
        targetDays: 30,
        isCompleted: false,
      ),
    ];
  }

  Future<void> addHabit(String title, String description) async {
    final habit = Habit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
    );
    _habits.add(habit);
    notifyListeners();
    try {
      await _repository.addHabit(habit);
    } catch (e) {
      _habits.remove(habit);
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteHabit(String id) async {
    final habit = _habits.firstWhere((h) => h.id == id);
    _habits.removeWhere((habit) => habit.id == id);
    notifyListeners();
    try {
      await _repository.deleteHabit(id);
    } catch (e) {
      _habits.add(habit);
      notifyListeners();
      rethrow;
    }
  }

  Future<void> toggleHabit(String id) async {
    final habit = _habits.firstWhere((h) => h.id == id);
    final oldCompleted = habit.isCompleted;
    final oldDays = habit.completedDays;
    
    habit.isCompleted = !habit.isCompleted;
    if (habit.isCompleted) {
      habit.completedDays++;
    } else {
      habit.completedDays = habit.completedDays > 0 ? habit.completedDays - 1 : 0;
    }
    notifyListeners();
    
    try {
      await _repository.updateHabit(habit);
    } catch (e) {
      habit.isCompleted = oldCompleted;
      habit.completedDays = oldDays;
      notifyListeners();
      rethrow;
    }
  }
}
