import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  final List<HabitItem> habits = const [
    HabitItem(
      title: 'Exercise',
      accentColor: Color(0xffFE2C91),
    ),
    HabitItem(
      title: 'School',
      accentColor: Color(0xff2C4EFE),
    ),
    HabitItem(
      title: 'Social Media',
      accentColor: Color(0xff2AEB8E),
    ),
    HabitItem(
      title: 'Chess',
      accentColor: Color(0xffFEE81E),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Habits',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        actions: const [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(Icons.settings),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff6D38E0),
        onPressed: () {
          Navigator.pushNamed(context, '/create-habit');
        },
        child: const Icon(
          Icons.add,
          size: 35,
          semanticLabel: 'Add a log',
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
            child: BottomNavigationBar(
                elevation: 0,
                backgroundColor: Colors.transparent.withAlpha(0),
                unselectedItemColor: Colors.white,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.local_gas_station), label: 'Logs'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.graphic_eq), label: 'Statistics'),
                ]),
          ),
        ),
      ),
      body: ListView(children: habits),
    );
  }
}

class HabitItem extends StatelessWidget {
  final String title;
  final Color accentColor;

  const HabitItem({Key? key, required this.title, required this.accentColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: const Color(0xffC0A4FF).withOpacity(.15),
      ),
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 12.0,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0)),
              color: accentColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
