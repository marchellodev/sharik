import 'package:sharik/models/file.dart';

class Sender {
  final String ip;
  final String version;
  final String os;
  final String name;
  final String url;

  FileTypeModel type;
  int n;

  Sender(
      {this.version,
      String type,
      this.n,
      this.ip,
      this.name,
      this.os,
      this.url}) {
    switch (type) {
      case 'file':
        this.type = FileTypeModel.file;
        break;

      case 'text':
        this.type = FileTypeModel.text;
        break;

      case 'app':
        this.type = FileTypeModel.app;
        break;
    }
  }

  @override
  String toString() => ip;
}
