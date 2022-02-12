import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'models.dart';

class HabitItemChild extends StatelessWidget {
  final Habit item;
  final EdgeInsets margin;

  const HabitItemChild(this.item, {Key? key, required this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: const Color(0xffC0A4FF).withOpacity(.15),
      ),
      height: 60,
      margin: margin,
      child: Row(
        children: <Widget>[
          Container(
            width: 14.0,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0)),
              color: item.accentColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              item.title,
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
        ],
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
    final optionsModal = Container(
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
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
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
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                ),
              ),
            ],
          )
        ],
      ),
    );

    return GestureDetector(
        onLongPress: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) => optionsModal);
        },
        onTap: () {
          Navigator.pushNamed(context, '/add-log', arguments: widget.item);
        },
        child: HabitItemChild(widget.item,
            margin:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0)));
  }
}
