part of 'models.dart';

class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 0;

  @override
  Habit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Habit(
      title: fields[0] as String,
      accentColor:
          Color(int.parse(fields[1].split('(0x')[1].split(')')[0], radix: 16)),
      duration: parseTime(fields[2]),
      goalType: GoalType.values.firstWhere((e) => e.toString() == fields[3]),
      categoryIndices: (fields[4] as List).cast<int>(),
      logs: (fields[5] ?? []).cast<Log>(),
    );
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.accentColor.toString())
      ..writeByte(2)
      ..write(obj.duration.toString())
      ..writeByte(3)
      ..write(obj.goalType.toString())
      ..writeByte(4)
      ..write(obj.categoryIndices)
      ..writeByte(5)
      ..write(obj.logs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LogAdapter extends TypeAdapter<Log> {
  @override
  final int typeId = 1;

  static final DateTime _unixEpoch = DateTime(1970, 1, 1, 0, 0, 0);

  @override
  Log read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return Log(
      startTime: _unixEpoch.add(Duration(milliseconds: fields[2])),
      endTime: _unixEpoch.add(Duration(milliseconds: fields[3])),
      mood: fields[0] as int,
      description: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Log obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.mood)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.startTime.millisecondsSinceEpoch)
      ..writeByte(3)
      ..write(obj.endTime.millisecondsSinceEpoch);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
