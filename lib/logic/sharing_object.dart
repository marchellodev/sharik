import 'dart:io' show Platform;

import 'package:hive/hive.dart';

part 'sharing_object.g.dart';

@HiveType(typeId: 1)
class SharingObject {
  @HiveField(0)
  final SharingObjectType type;

  /// path to file if type is file
  /// path to apk if type is app
  /// raw text if type is text
  @HiveField(1)
  final String data;

  @HiveField(2)
  late String name;

  String get icon {
    switch (type) {
      case SharingObjectType.file:
        return 'assets/icon_folder2.svg';

      case SharingObjectType.text:
        return 'assets/icon_file_word.svg';

      case SharingObjectType.app:
        return 'assets/icon_file_app.svg';
    }
  }

  SharingObject({required this.type, required this.data, String? fileName}) {
    if (fileName == null) {
      switch (type) {
        case SharingObjectType.file:
          name = data.split(Platform.isWindows ? '\\' : '/').last;
          break;
        case SharingObjectType.text:
          final _ = data.trim().replaceAll('\n', ' ');
          name = _.length >= 101 ? _.substring(0, 100) : _;
          break;
        case SharingObjectType.app:
          throw Exception('when type is app, name is neccesary');
      }
    } else {
      name = fileName;
    }
  }
}

@HiveType(typeId: 2)
enum SharingObjectType {
  @HiveField(0)
  file,
  @HiveField(1)
  text,
  @HiveField(2)
  app
}

SharingObjectType string2fileType(String type) {
  switch (type) {
    case 'file':
      return SharingObjectType.file;

    case 'text':
      return SharingObjectType.text;

    case 'app':
      return SharingObjectType.app;
  }
  throw UnimplementedError('Type $type does not exist');
}
