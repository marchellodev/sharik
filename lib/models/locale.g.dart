// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocaleModelAdapter extends TypeAdapter<LocaleModel?> {
  @override
  final int typeId = 0;

  @override
  LocaleModel? read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LocaleModel.en;
      case 1:
        return LocaleModel.ar;
      case 2:
        return LocaleModel.ru;
      case 3:
        return LocaleModel.ua;
      case 4:
        return LocaleModel.pl;
      case 5:
        return LocaleModel.inHi;
      case 6:
        return LocaleModel.inGu;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, LocaleModel? obj) {
    switch (obj) {
      case LocaleModel.en:
        writer.writeByte(0);
        break;
      case LocaleModel.ar:
        writer.writeByte(1);
        break;
      case LocaleModel.ru:
        writer.writeByte(2);
        break;
      case LocaleModel.ua:
        writer.writeByte(3);
        break;
      case LocaleModel.pl:
        writer.writeByte(4);
        break;
      case LocaleModel.inHi:
        writer.writeByte(5);
        break;
      case LocaleModel.inGu:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocaleModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
