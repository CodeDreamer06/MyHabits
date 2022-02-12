import 'package:flutter/material.dart';
import 'package:duration/duration.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myhabits/create_habit_screen.dart';

part 'models.g.dart';

@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late Color accentColor;

  @HiveField(2)
  late Duration duration;

  @HiveField(3)
  late GoalType goalType;

  @HiveField(4)
  late List<int> categoryIndices;

  @HiveField(5)
  late List<Log> logs;

  Habit(
      {required this.title,
      required this.accentColor,
      required this.duration,
      required this.goalType,
      required this.categoryIndices,
      this.logs = const []});
}

@HiveType(typeId: 1)
class Log extends HiveObject {
  @HiveField(0)
  late int mood;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late DateTime startTime;

  @HiveField(3)
  late DateTime endTime;

  Log(
      {required this.startTime,
      required this.endTime,
      required this.mood,
      required this.description});
}
