import 'package:flutter/material.dart';
import 'package:myhabits/button.dart';
import 'package:myhabits/habit_item.dart';

import 'package:hive/hive.dart';
import 'models.dart';

class AddLogScreen extends StatefulWidget {
  const AddLogScreen({Key? key}) : super(key: key);

  @override
  _AddLogScreenState createState() => _AddLogScreenState();
}

class _AddLogScreenState extends State<AddLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionBoxController = TextEditingController();

  List<Image> faces = [];
  int moodIndex = 2;

  late Box<Habit> habitBox;

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

    habitBox = Hive.box<Habit>('Habits');
  }

  @override
  void didChangeDependencies() {
    for (var face in faces) {
      precacheImage(face.image, context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final habit = ModalRoute.of(context)!.settings.arguments as Habit;

    AppBar appBar = AppBar(
      title: Text(
        'Add a Log',
        style: Theme.of(context).textTheme.headline1,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
    return Scaffold(
      appBar: appBar,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  appBar.preferredSize.height,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabelText('Activity'),
                  HabitItemChild(habit,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 10.0)),
                  _buildLabelText('Date'),
                  _buildDateInput(),
                  _buildLabelText('Time'),
                  Row(
                    children: [
                      _buildTimeInput('4:00 am'),
                      _buildTimeInput('6:00 am'),
                    ],
                  ),
                  _buildLabelText('Mood'),
                  _buildMoodButtons(),
                  _buildLabelText('Description'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        style: const TextStyle(color: Colors.white),
                        maxLength: 64,
                        controller: _descriptionBoxController,
                        buildCounter: null,
                        decoration: InputDecoration(
                          fillColor: const Color(0xff353251),
                          filled: true,
                          counterText: "",
                          contentPadding: const EdgeInsets.all(15.0),
                          hintStyle: const TextStyle(color: Colors.white24),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide.none),
                        )),
                  ),
                  const Spacer(),
                  Button(
                      text: 'Add Log',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          var habits = habitBox.values
                              .firstWhere((item) => item.key == habit.key);
                          habits.logs = [
                            ...habits.logs,
                            Log(
                                startTime: DateTime.now(),
                                endTime: DateTime.now()
                                    .add(const Duration(hours: 1)),
                                mood: moodIndex,
                                description: _descriptionBoxController.text)
                          ];
                          habits.save();
                          Navigator.pop(context);
                          // habit.logs.add(Log(
                          //     dateTimeRange: DateTimeRange(
                          //         start: DateTime.now(), end: DateTime.now()),
                          //     mood: moodIndex,
                          //     description: _descriptionBoxController.text));
                          // habit.save();
                        }
                      })
                ],
              )),
        ),
      ),
    );
  }

  Padding _buildLabelText(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline3,
      ),
    );
  }

  Widget _buildDateInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: const Color(0xffC0A4FF).withOpacity(.15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Today',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: _buildRoundIconButton(
                  Icons.calendar_today,
                  onPressed: () {
                    showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now().add(const Duration(days: 30)));
                  },
                ),
              ),
            ],
          )),
    );
  }

  Container _buildRoundIconButton(IconData icon,
      {required void Function() onPressed}) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: const Color(0xff6D38E0)),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
      ),
    );
  }

  Widget _buildTimeInput(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      decoration: BoxDecoration(
          color: const Color(0xffC0A4FF).withOpacity(.15),
          borderRadius: BorderRadius.circular(20.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          _buildRoundIconButton(Icons.watch, onPressed: () {
            showTimePicker(context: context, initialTime: TimeOfDay.now());
          }),
        ],
      ),
    );
  }

  Widget _buildMoodButtons() {
    return Wrap(
      direction: Axis.horizontal,
      children: faces
          .asMap()
          .entries
          .map((face) => GestureDetector(
                onTap: () {
                  setState(() {
                    moodIndex = face.key;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: face.key == moodIndex
                          ? Colors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(50.0)),
                  child: face.value,
                  padding: const EdgeInsets.only(top: 3.0),
                ),
              ))
          .toList(),
    );
  }
}
