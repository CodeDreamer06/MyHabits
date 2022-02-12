import 'package:myhabits/database/models.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DbService {
  late Box<Habit> habitBox;

  Future<Box<Habit>> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    Hive.registerAdapter(HabitAdapter());
    Hive.registerAdapter(LogAdapter());
    habitBox = await Hive.openBox<Habit>('Habits');
    return habitBox;
  }
}
