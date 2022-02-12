import 'package:flutter/material.dart';
import 'package:myhabits/database/db_service.dart';
import 'create_habit_screen.dart';
import 'home_screen.dart';
import 'add_log_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbService().init();
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
        '/create-habit': (context) => const CreateHabitScreen(),
        '/add-log': (context) => const AddLogScreen()
      },
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color(0xff6D38E0),
          canvasColor: const Color(0xff181A2E),
          fontFamily: 'Poppins',
          textTheme: const TextTheme(
              headline1: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: Colors.white),
              headline2: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
              headline3: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
              subtitle1: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  fontWeight: FontWeight.w500))),
    );
  }
}
