// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FileTypeModelAdapter extends TypeAdapter<FileTypeModel> {
  @override
  final int typeId = 2;

  @override
  FileTypeModel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FileTypeModel.file;
      case 1:
        return FileTypeModel.text;
      case 2:
        return FileTypeModel.app;
      default:
        return FileTypeModel.file;
    }
  }

  @override
  void write(BinaryWriter writer, FileTypeModel obj) {
    switch (obj) {
      case FileTypeModel.file:
        writer.writeByte(0);
        break;
      case FileTypeModel.text:
        writer.writeByte(1);
        break;
      case FileTypeModel.app:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FileTypeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FileModelAdapter extends TypeAdapter<FileModel> {
  @override
  final int typeId = 1;

  @override
  FileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FileModel(
      type: fields[0] as FileTypeModel,
      data: fields[1] as String,
      name: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FileModel obj) {
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
      other is FileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
