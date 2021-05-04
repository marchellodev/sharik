import 'dart:convert';

import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:multicast_dns/multicast_dns.dart';
import 'package:sharik/models/file.dart';

import '../../conf.dart';
import 'ip_service.dart';

class ReceiverService extends ChangeNotifier {
  final ipService = LocalIpService();
  final List<Receiver> receivers = [];

  bool loaded = false;
  int loop = 0;

  Future<void> init() async {
    await ipService.load();
    loaded = true;
    notifyListeners();
    //
    // final devices = <String>[];
    //
    //
    // while (true) {
    //
    //   if(loop == 0){
    //     devices.clear();
    //     devices.addAll(await compute(_getAliveDevices, ipService));
    //   }
    //
    //   await compute(_run, devices);
    //   loop++;
    //   notifyListeners();
    //   print(loop);
    //   await Future.delayed(const Duration(seconds: 2));
    // }

    // Parse the command line arguments.

    const String name = '_dartobservatory._tcp.local';
    final MDnsClient client = MDnsClient();
    // Start the client with default options.
    await client.start();

    // Get the PTR record for the service.
    await for (final PtrResourceRecord ptr in client
        .lookup<PtrResourceRecord>(ResourceRecordQuery.serverPointer(name))) {
      // Use the domainName from the PTR record to get the SRV record,
      // which will have the port and local hostname.
      // Note that duplicate messages may come through, especially if any
      // other mDNS queries are running elsewhere on the machine.
      await for (final SrvResourceRecord srv
          in client.lookup<SrvResourceRecord>(
              ResourceRecordQuery.service(ptr.domainName))) {
        // Domain name will be something like "io.flutter.example@some-iphone.local._dartobservatory._tcp.local"
        final String bundleId =
            ptr.domainName; //.substring(0, ptr.domainName.indexOf('@'));
        print('Dart observatory instance found at '
            '${srv.target}:${srv.port} for "$bundleId".');
      }
    }
    client.stop();

    print('Done.');
  }

  static Future<List<Receiver>> _run(List<String> devices) async {
    final receiverObjects = <Future<Receiver?>>[];

    for (final device in devices) {
      for (final port in ports) {
        receiverObjects.add(_hasSharik(device, port));
      }
    }

    final result = <Receiver>[];

    for (final obj in receiverObjects) {
      final awaited = await obj;

      if (awaited != null) {
        result.add(awaited);
      }
    }

    return result;
    // receivers.clear();

    // receivers.addAll(result);
  }

  static Future<Receiver?> _hasSharik(String ip, int port) async {
    try {
      final result = await http
          .get(Uri.parse('http://$ip:$port/sharik.json'))
          .timeout(const Duration(seconds: 1));

      return Receiver.fromJson(ip: ip, port: port, json: result.body);
    } catch (_) {
      return null;
    }
  }

  static Future<List<String>> _getAliveDevices(LocalIpService ipService) async {
    var ip = ipService.getIp();

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

  static Future<bool> _isAlive(String ip) async {
    await Future.delayed(Duration.zero);
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

class Receiver {
  final String ip;
  final int port;

  final String os;
  final String name;
  final FileTypeModel type;

  const Receiver({
    required this.ip,
    required this.port,
    required this.os,
    required this.name,
    required this.type,
  });

  factory Receiver.fromJson(
      {required String ip, required int port, required String json}) {
    final parsed = jsonDecode(json);

    return Receiver(
      ip: ip,
      port: port,
      os: parsed['os'] as String,
      name: parsed['name'] as String,
      // type: FileTypeModel.app
      type: string2fileType(parsed['type'] as String),
    );
  }
}
