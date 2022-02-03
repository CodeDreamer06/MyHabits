import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Habit> habitBox;

  @override
  void initState() {
    super.initState();
    Hive.openBox<Habit>('Habits');
    habitBox = Hive.box<Habit>('Habits');
  }

  @override
  void dispose() {
    habitBox.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Habits',
          style: Theme.of(context).textTheme.headline1,
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
                      icon: Icon(Icons.history), label: 'History'),
                ]),
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: habitBox.listenable(),
        builder: (context, box, _) {
          return ListView.builder(
            itemCount: habitBox.length,
            itemBuilder: (BuildContext context, int index) {
              return HabitItem(habitBox.getAt(index)!);
            },
          );
        },
      ),
    );
  }
}

class HabitItem extends StatefulWidget {
  final Habit item;

  const HabitItem(this.item, {Key? key}) : super(key: key);

  @override
  State<HabitItem> createState() => _HabitItemState();
}

class _HabitItemState extends State<HabitItem> {
  late Box<Habit> habitBox;

  @override
  void initState() {
    super.initState();
    habitBox = Hive.box<Habit>('Habits');
  }

  @override
  void dispose() {
    habitBox.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 180,
                padding: const EdgeInsets.all(25.0),
                color: const Color(0xff343649),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.title,
                      style: Theme.of(context).textTheme.headline2,
                    ),
                    Text(
                      'Progress: 5 hours / 8 hours',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text('Edit',
                                style: Theme.of(context).textTheme.headline3),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0))),
                          ),
                        ),
                        const SizedBox(width: 20.0),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              habitBox.delete(widget.item.key);
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Delete',
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0))),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: const Color(0xffC0A4FF).withOpacity(.15),
        ),
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Row(
          children: <Widget>[
            Container(
              width: 14.0,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0)),
                color: widget.item.accentColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                widget.item.title,
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
