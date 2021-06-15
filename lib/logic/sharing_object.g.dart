// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sharing_object.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SharingObjectTypeAdapter extends TypeAdapter<SharingObjectType> {
  @override
  final int typeId = 2;

  @override
  SharingObjectType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SharingObjectType.file;
      case 1:
        return SharingObjectType.text;
      case 2:
        return SharingObjectType.app;
      default:
        return SharingObjectType.file;
    }
  }

  @override
  void write(BinaryWriter writer, SharingObjectType obj) {
    switch (obj) {
      case SharingObjectType.file:
        writer.writeByte(0);
        break;
      case SharingObjectType.text:
        writer.writeByte(1);
        break;
      case SharingObjectType.app:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SharingObjectTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SharingObjectAdapter extends TypeAdapter<SharingObject> {
  @override
  final int typeId = 1;

  @override
  SharingObject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SharingObject(
      type: fields[0] as SharingObjectType,
      data: fields[1] as String,
      name: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SharingObject obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.data)
      ..writeByte(2)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SharingObjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
