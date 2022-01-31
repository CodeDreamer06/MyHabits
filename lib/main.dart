import 'package:flutter/material.dart';
import './create_habit_screen.dart';
import './HomeScreen.dart';

void main() => runApp(const MyHabits());

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
