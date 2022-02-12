import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:myhabits/settings_screen.dart';
import 'package:myhabits/statistics_screen.dart';
import 'history_screen.dart';
import 'database/models.dart';
import 'habit_item.dart';
import 'circular_progress_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Image> navIcons = [];

  int navBarIndex = 0;

  final navItems = [
    const Logs(),
    const StatisticsScreen(),
    const HistoryScreen(),
    const SettingsScreen()
  ];

  @override
  void initState() {
    super.initState();
    navIcons = [
      for (var imageUrl in [
        "images/home.png",
        "images/stats.png",
        "images/history.png",
        "images/settings.png",
      ])
        Image.asset(imageUrl)
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (var navIcon in navIcons) {
      precacheImage(navIcon.image, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff6D38E0),
        onPressed: () {
          Navigator.pushNamed(context, '/create-habit');
        },
        child: const Icon(
          Icons.add,
          size: 35,
          semanticLabel: 'Add a log',
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        child: BottomAppBar(
          notchMargin: 12,
          shape: const CircularNotchedRectangle(),
          color: const Color(0xff282B45),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavIcon(0),
                _buildNavIcon(1, sizeChange: 5.0),
                const SizedBox(width: 50.0),
                _buildNavIcon(2),
                _buildNavIcon(3, sizeChange: -5.0),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(child: navItems[navBarIndex]),
    );
  }

  IconButton _buildNavIcon(index, {sizeChange = 0}) {
    return IconButton(
      onPressed: () {
        setState(() {
          navBarIndex = index;
        });
      },
      icon: ColorFiltered(
        colorFilter: ColorFilter.mode(
            navBarIndex == index ? const Color(0xff2AEB8E) : Colors.white,
            BlendMode.modulate),
        child: navIcons[index],
      ),
      iconSize: 45.0 + sizeChange,
    );
  }
}

class Logs extends StatefulWidget {
  const Logs({
    Key? key,
  }) : super(key: key);

  @override
  State<Logs> createState() => _LogsState();
}

class _LogsState extends State<Logs> {
  Box<Habit>? habitBox;

  @override
  void initState() {
    super.initState();
    initDb();
  }

  void initDb() async {
    if (habitBox == null || !habitBox!.isOpen) {
      await Hive.openBox<Habit>('Habits');
      habitBox = Hive.box<Habit>('Habits');
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (habitBox == null) {
      initDb();
      return const CircularProgressBar();
    }

    return ValueListenableBuilder(
      valueListenable: habitBox!.listenable(),
      builder: (context, box, _) {
        return Wrap(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
              child: Text(
                'Habits',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: habitBox!.length,
              itemBuilder: (BuildContext context, int index) {
                return HabitItem(habitBox!.getAt(index)!);
              },
            ),
          ],
        );
      },
    );
  }
}
