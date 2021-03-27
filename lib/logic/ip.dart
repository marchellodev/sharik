import 'dart:io';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/foundation.dart';

class LocalIpService extends ChangeNotifier {
  List<NetworkInterface>? interfaces;
  String? _selectedInterface;

  set selectedInterface(String selectedInterface) {
    _selectedInterface = selectedInterface;
    print('interce set');
    notifyListeners();
  }

  Future<void> load() async {
    interfaces = await NetworkInterface.list(type: InternetAddressType.IPv4);
    notifyListeners();
  }

  String? _getIpByName(String name) => interfaces
      ?.firstWhereOrNull((element) => element.name == 'wlan0')
      ?.addresses
      .first
      .address;

  String getIp() {
    if (interfaces == null) {
      return 'loading';
      throw Exception('The local ip service was not initialized');
    }
    if (_selectedInterface != null) {
      for (final el in interfaces!) {
        if (el.name == _selectedInterface) {
          return el.addresses.first.address;
        }
      }
    }

    // todo research other numbers than 0, i.e. wlan1, Wi-Fi 2
    // Local Area Connection* 1 - Hotspot on windows
    // bridgexxx - Hotspot on Mac
    final names = [
      // linux wifi
      _getIpByName('wlan0'),
      // linux ethernet
      _getIpByName('eth0'),
      // linux hotspot
      _getIpByName('hotspot'),
      // windows wifi
      _getIpByName('Wi-Fi'),
      // ios/macos wifi
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
