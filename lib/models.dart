import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'models.g.dart';

@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late Color accentColor;

  Habit({required this.title, required this.accentColor});
}
