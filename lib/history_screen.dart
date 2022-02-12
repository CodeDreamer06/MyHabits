import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'models.dart';
import 'circular_progress_bar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Box<Habit>? habitBox;

  List<Image> faces = [];

  @override
  void initState() {
    super.initState();
    faces = [
      for (var imageUrl in [
        "images/face1.png",
        "images/face2.png",
        "images/face3.png",
        "images/face4.png",
        "images/face5.png"
      ])
        Image.asset(imageUrl)
    ];
    initDb();
  }

  @override
  void didChangeDependencies() {
    for (var face in faces) {
      precacheImage(face.image, context);
    }
    super.didChangeDependencies();
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
    if (habitBox == null || !habitBox!.isOpen) {
      initDb();
      return const CircularProgressBar();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 16.0, bottom: 16),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Text('Today',
                style: TextStyle(
                  color: Color(0xff2AEB8E),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                )),
          ),
          const SizedBox(height: 20.0),
          Expanded(
            child: SingleChildScrollView(
              child: ValueListenableBuilder(
                valueListenable: habitBox!.listenable(),
                builder: (context, box, _) {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: habitBox!.getAt(0)!.logs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildHistoryItem(index, context);
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Container _buildHistoryItem(int index, BuildContext context) {
    var habit = habitBox!.getAt(0)!.logs[index];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: const Color(0xffC0A4FF).withOpacity(.15),
      ),
      margin: const EdgeInsets.only(right: 20.0, bottom: 20.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 14.0,
            height: 90.0,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0)),
              color: habitBox!.getAt(0)!.accentColor,
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habitBox!.getAt(0)!.title,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      Text(
                        habit.description,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Row(
                        children: [
                          Text(
                            habit.endTime
                                    .toLocal()
                                    .difference(habit.startTime.toLocal())
                                    .inHours
                                    .toString() +
                                ' hour',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          SizedBox(
                            height: 35.0,
                            child: faces
                                .asMap()
                                .entries
                                .elementAt(habit.mood)
                                .value,
                          )
                        ],
                      ),
                    ],
                  ),
                  Text(
                    DateFormat("HH:MM").format(habit.startTime.toLocal()),
                    style: Theme.of(context).textTheme.headline2,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
