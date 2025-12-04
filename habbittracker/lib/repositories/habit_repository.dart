import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';

class HabitRepository {
  static const String _key = 'habits';

  Future<List<Habit>> loadHabits() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? habitsJson = prefs.getString(_key);
      
      if (habitsJson == null || habitsJson.isEmpty) {
        return [];
      }

      final List<dynamic> decoded = json.decode(habitsJson);
      return decoded.map((item) => Habit.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> isInitialized() async {
    final prefs = await SharedPreferences.getInstance();
    final String? habitsJson = prefs.getString(_key);
    return habitsJson != null && habitsJson.isNotEmpty;
  }

  Future<void> saveHabits(List<Habit> habits) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String habitsJson = json.encode(
        habits.map((habit) => habit.toJson()).toList(),
      );
      final success = await prefs.setString(_key, habitsJson);
      if (!success) {
        throw Exception('Не удалось сохранить данные');
      }
    } catch (e) {
      throw Exception('Ошибка при сохранении: $e');
    }
  }

  Future<void> addHabit(Habit habit) async {
    try {
      final habits = await loadHabits();
      habits.add(habit);
      await saveHabits(habits);
    } catch (e) {
      throw Exception('Ошибка при добавлении: $e');
    }
  }

  Future<void> deleteHabit(String id) async {
    try {
      final habits = await loadHabits();
      habits.removeWhere((habit) => habit.id == id);
      await saveHabits(habits);
    } catch (e) {
      throw Exception('Ошибка при удалении: $e');
    }
  }

  Future<void> updateHabit(Habit habit) async {
    try {
      final habits = await loadHabits();
      final index = habits.indexWhere((h) => h.id == habit.id);
      if (index != -1) {
        habits[index] = habit;
        await saveHabits(habits);
      }
    } catch (e) {
      throw Exception('Ошибка при обновлении: $e');
    }
  }
}
