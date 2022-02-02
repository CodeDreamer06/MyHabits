import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'models.dart';
import 'package:hive/hive.dart';

enum GoalType { target, limit }

class CreateHabitScreen extends StatefulWidget {
  const CreateHabitScreen({Key? key}) : super(key: key);

  @override
  _CreateHabitScreenState createState() => _CreateHabitScreenState();
}

class _CreateHabitScreenState extends State<CreateHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  late Box<Habit> habitBox;

  String goalValue = 'Per Week';
  List<String> categoryChips = [
    'Work',
    'Code',
  ];

  Color selectedColor = const Color(0xFFFE2C91);
  GoalType goalType = GoalType.target;

  @override
  void initState() {
    super.initState();
    habitBox = Hive.box<Habit>('Habits');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: Text(
        'Create a habit',
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
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNameInputBox(),
                const SizedBox(height: 20),
                _buildGoalInputBox(),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Categories',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                _buildCategoryChips(),
                _buildColorPicker(),
                const Spacer(),
                _buildCreateButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListView _buildNameInputBox() {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Name",
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        TextFormField(
          controller: _nameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Name cannot be empty';
            }

            return null;
          },
          style: const TextStyle(color: Colors.white),
          // autofocus: true,
          maxLength: 16,
          decoration: InputDecoration(
              fillColor: const Color(0xff353251),
              filled: true,
              hintText: 'Enter a name',
              counterText: "",
              contentPadding: const EdgeInsets.all(15.0),
              hintStyle: const TextStyle(color: Colors.white24),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15.0))),
        ),
      ],
    );
  }

  Wrap _buildCategoryChips() {
    return Wrap(
        direction: Axis.horizontal,
        children: categoryChips
                .map((title) => Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Chip(
                        label: Text(
                          title,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        backgroundColor: const Color(0xff6D38E0),
                        elevation: 6.0,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        deleteIconColor: Colors.white,
                        onDeleted: () {
                          setState(() {
                            categoryChips.remove(title);
                          });
                        },
                      ),
                    ))
                .toList() +
            [
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add_circle_rounded),
                    color: Colors.white,
                  ))
            ]);
  }

  Container _buildCreateButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(
            color: Color(0xff1D224B),
            spreadRadius: 5,
            blurRadius: 5,
            offset: Offset(0, 4))
      ]),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: const Color(0xff6D38E0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0))),
        child: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Create',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            habitBox.add(
                Habit(title: _nameController.text, accentColor: selectedColor));
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  ListView _buildGoalInputBox() {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Goal',
                style: Theme.of(context).textTheme.headline3,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ToggleSwitch(
                  totalSwitches: 2,
                  labels: const ['Target', 'Limit'],
                  radiusStyle: true,
                  cornerRadius: 20.0,
                  minWidth: 85.0,
                  inactiveBgColor: const Color(0xffC0A4FF).withAlpha(15),
                  initialLabelIndex: 0,
                  animate: true,
                  onToggle: (index) {
                    goalType = index == 0 ? GoalType.target : GoalType.limit;
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 16.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: const Color(0xff353251)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                    flex: 2,
                    child: TextFormField(
                        style: const TextStyle(color: Colors.white),
                        maxLength: 2,
                        buildCounter: null,
                        decoration: const InputDecoration(
                            fillColor: Color(0xff353251),
                            filled: true,
                            counterText: "",
                            hintText: "ex. 5 hours",
                            contentPadding: EdgeInsets.only(right: 4.0),
                            hintStyle: TextStyle(color: Colors.white24),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none))),
                Flexible(
                    flex: 1,
                    child: Container(
                        padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: const Color(0xff6D38E0)),
                        child: DropdownButton(
                            borderRadius: BorderRadius.circular(15.0),
                            underline: const SizedBox(),
                            icon: const SizedBox(),
                            dropdownColor: const Color(0xff403A4F),
                            value: goalValue,
                            style: const TextStyle(color: Colors.white),
                            hint: const Text("select",
                                style: TextStyle(color: Colors.white)),
                            onChanged: (String? value) {
                              setState(() {
                                goalValue = value!;
                              });
                            },
                            items: <String>['Per Week', 'Per Day', 'Per Month']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,
                                      style: TextStyle(
                                          fontWeight: value == goalValue
                                              ? FontWeight.w800
                                              : FontWeight.w400,
                                          fontSize: 16)));
                            }).toList())))
              ],
            )),
      ],
    );
  }

  ListView _buildColorPicker() {
    List<Color> categoryColors = [
      const Color(0xFFFE2C91),
      const Color(0xFF2C4EFE),
      const Color(0xFF2AEB8E),
      const Color(0xFFFEE81E),
      const Color(0xFF6D38E0),
      const Color(0xFFFF5F5F),
      const Color(0xffF5F5F5),
      const Color(0xffF521FA),
      const Color(0xffFF8F3F),
      const Color(0xff74EEFF)
    ];
    return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Color',
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          Wrap(
            children: categoryColors.map((color) {
              return InkWell(
                borderRadius: BorderRadius.circular(10.0),
                onTap: () {
                  setState(() {
                    selectedColor = color;
                  });
                },
                child: Container(
                  height: 47,
                  width: 47,
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                      border: color == selectedColor
                          ? Border.all(
                              color: color == const Color(0xffF5F5F5)
                                  ? Colors.grey
                                  : Colors.white,
                              width: 5.0)
                          : null),
                ),
              );
            }).toList(),
          ),
        ]);
  }
}
