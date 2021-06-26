import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../../conf.dart';
import '../sharing_object.dart';

class SharingService extends ChangeNotifier {
  final SharingObject _file;
  int? _port;
  HttpServer? _server;

  int? get port => _port;

  bool get running => _port != null;

  SharingService(this._file);

  Future<bool> _isPortFree(int port) async {
    try {
      final _ = await HttpServer.bind(InternetAddress.anyIPv4, port);
      await _.close(force: true);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<int> _getPrettyPort() async {
    for (final el in ports) {
      if (await _isPortFree(el)) {
        return el;
      }
    }

    final _ = await HttpServer.bind(InternetAddress.anyIPv4, 0);
    final port = _.port;
    await _.close(force: true);
    return port;
  }

  Future<void> start() async {
    _port = await _getPrettyPort();

    _server = await HttpServer.bind(InternetAddress.anyIPv4, _port!);

    _serve();

    notifyListeners();
  }

  Future<void> end() async {
    await _server!.close(force: true);

    // todo research this issue on ios & desktop OSes

    final dir = await getTemporaryDirectory();

    if (await dir.exists()) {
      return;
    }

    try {
      await dir.delete(recursive: true);
    } catch (e) {
      print('Error cleaning the path');
    }
  }

  Future<void> _serve() async {
    if (_server == null) {
      throw Exception('Server was not initialized');
    }

    await for (final request in _server!) {
      if (request.requestedUri.toString().split('/').length == 4 &&
          request.requestedUri.toString().split('/').last == 'sharik.json') {
        request.response.headers.contentType =
            ContentType('application', 'json', charset: 'utf-8');
        request.response.write(jsonEncode({
          'sharik': currentVersion,
          'type': _file.type.toString().split('.').last,
          'name': _file.name,
          'os': Platform.operatingSystem,
        }));
        request.response.close();
      } else {
        if (_file.type == SharingObjectType.file ||
            _file.type == SharingObjectType.app) {
          final f = File(_file.data);
          final size = await f.length();

          request.response.headers.contentType =
              ContentType('application', 'octet-stream', charset: 'utf-8');

          request.response.headers.add(
            'Content-Transfer-Encoding',
            'Binary',
          );

          request.response.headers.add(
            'Content-disposition',
            'attachment; filename="${Uri.encodeComponent(_file.type == SharingObjectType.file ? _file.name : '${_file.name}.apk')}"',
          );
          request.response.headers.add(
            'Content-length',
            size,
          );

          await f
              .openRead()
              .pipe(request.response)
              .catchError((e) {})
              .then((a) {
            request.response.close();
          });
        } else {
          request.response.headers.contentType =
              ContentType('text', 'plain', charset: 'utf-8');
          request.response.write(_file.data);
          request.response.close();
        }
      }
    }
  }
}
