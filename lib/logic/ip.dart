import 'dart:io';

import 'package:collection/collection.dart' show IterableExtension;

class LocalIpService {
  List<NetworkInterface>? interfaces;
  String? selectedInterface;

  Future<void> load() async {
    interfaces = await NetworkInterface.list(type: InternetAddressType.IPv4);
  }

  String? _getIpByName(String name) => interfaces
      ?.firstWhereOrNull((element) => element.name == 'wlan0')
      ?.addresses
      .first
      .address;

  String getIp() {
    if (interfaces == null) {
      throw Exception('The local ip service was not initialized');
    }
    if (selectedInterface != null) {
      for (final el in interfaces!) {
        if (el.name == selectedInterface) {
          return el.addresses.first.address;
        }
      }
    }

    final names = [
      _getIpByName('wlan0'),
      _getIpByName('Wi-Fi'),
      _getIpByName('en0')
    ];

    for (final el in names) {
      if (el != null) {
        return el;
      }
    }

    return interfaces![0].addresses.first.address;
  }

  Connectivity getConnectivityType() {
    // todo find connectivity type based on the network interfaces

    return Connectivity.unknown;
  }
}

enum Connectivity { wifi, ethernet, hotspot, cellular, none, unknown }

Future<String?> getIp() async {
  final list = await NetworkInterface.list(type: InternetAddressType.IPv4);
}
