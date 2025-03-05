// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoomHiveModelAdapter extends TypeAdapter<RoomHiveModel> {
  @override
  final int typeId = 1;

  @override
  RoomHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoomHiveModel(
      id: fields[0] as String?,
      roomDescription: fields[1] as String,
      floor: fields[2] as int,
      address: fields[3] as String,
      rentPrice: fields[4] as double,
      parking: fields[5] as String,
      contactNo: fields[6] as String,
      bathroom: fields[7] as int,
      roomImage: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RoomHiveModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.roomDescription)
      ..writeByte(2)
      ..write(obj.floor)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.rentPrice)
      ..writeByte(5)
      ..write(obj.parking)
      ..writeByte(6)
      ..write(obj.contactNo)
      ..writeByte(7)
      ..write(obj.bathroom)
      ..writeByte(8)
      ..write(obj.roomImage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoomHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
