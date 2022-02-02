import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'models.dart';
import 'create_habit_screen.dart';
import 'home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(HabitAdapter());
  await Hive.openBox<Habit>('Habits');
  runApp(const MyHabits());
}

class MyHabits extends StatelessWidget {
  const MyHabits({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Habits',
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/create-habit': (context) => const CreateHabitScreen()
      },
      theme: ThemeData(
          canvasColor: const Color(0xff181A2E), fontFamily: 'Poppins'),
    );
  }
}
