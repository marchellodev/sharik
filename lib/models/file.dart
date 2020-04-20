import 'dart:io' show Platform;

import 'package:hive/hive.dart';

part 'file.g.dart';

@HiveType(typeId: 1)
class FileModel {
  @HiveField(0)
  final FileTypeModel type;

  /// path to file if type is file
  /// path to apk if type is app
  /// raw text if type is text
  @HiveField(1)
  final String data;

  @HiveField(2)
  String name;

  String get icon {
    switch (type) {
      case FileTypeModel.file:
        return 'assets/icon_folder2.svg';
        break;
      case FileTypeModel.text:
        return 'assets/icon_file_word.svg';
        break;
      case FileTypeModel.app:
        return 'assets/icon_file_app.svg';
        break;
    }
    throw Exception('unknown type');
  }

  FileModel({this.type, this.data, this.name}) {
    if (name == null) {
      switch (type) {
        case FileTypeModel.file:
          name = data.split(Platform.isWindows ? '\\' : '/').last;
          break;
        case FileTypeModel.text:
          name = data.length >= 101
              ? data.replaceAll('\n', ' ').substring(0, 100)
              : data.replaceAll('\n', ' ');
          break;
        case FileTypeModel.app:
          throw Exception('when type is app, name is neccesary');
          break;
      }
    }
  }
}

@HiveType(typeId: 2)
enum FileTypeModel {
  @HiveField(0)
  file,
  @HiveField(1)
  text,
  @HiveField(2)
  app
}
