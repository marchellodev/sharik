// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocaleModelAdapter extends TypeAdapter<LocaleModel> {
  @override
  final typeId = 0;

  @override
  LocaleModel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LocaleModel.en;
      case 1:
        return LocaleModel.ru;
      case 2:
        return LocaleModel.ua;
      case 3:
        return LocaleModel.pl;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, LocaleModel obj) {
    switch (obj) {
      case LocaleModel.en:
        writer.writeByte(0);
        break;
      case LocaleModel.ru:
        writer.writeByte(1);
        break;
      case LocaleModel.ua:
        writer.writeByte(2);
        break;
      case LocaleModel.pl:
        writer.writeByte(3);
        break;
    }
  }
}
