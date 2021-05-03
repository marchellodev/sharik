import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/foundation.dart';

import 'ip_service.dart';

class ReceiverService extends ChangeNotifier {
  final _ipService = LocalIpService();

  void init() {
    _ipService.load();
  }

  void check() async {

    // todo check those devices for open ports & configure ipService
    print(await getAliveDevices());
  }

  Future<List<String>> getAliveDevices() async {
    var ip = '192.168.0.107';

    final _ = ip.split('.');
    final thisDevice = _.removeLast();

    ip = _.join('.');

    final result = {
      for (var e in List.generate(254, (index) => index + 1))
        e: e != int.parse(thisDevice) ? _isAlive('$ip.$e') : Future.value(false)
    };

    final list = <String>[];
    for (final val in result.entries) {
      if (await val.value) {
        list.add('$ip.${val.key}');
      }
    }

    return list;
  }

  Future<bool> _isAlive(String ip) async {
    final ping = await Ping(ip, count: 1, timeout: 1, ttl: 10).stream.first;

    if (ping.error != null) {
      return false;
    }

    if (ping.summary != null && ping.summary!.received == 0) {
      return false;
    }

    return true;
  }
}
