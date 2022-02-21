import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myhabits/create_habit_screen.dart';
import 'package:myhabits/database/db_service.dart';
import 'package:myhabits/database/models.dart';

void main() {
  group('Database smoke test', () {
    test('A habit should be created and deleted', () async {
      var habitBox = await DbService().init();
      int key = await habitBox.add(Habit(
          title: 'Running',
          accentColor: Colors.pinkAccent,
          duration: Duration(hours: int.parse('2')),
          goalType: GoalType.target,
          categoryIndices: []));
      expect(habitBox.values.last.title, 'Running');
      habitBox.delete(key);
    });
  });
}
