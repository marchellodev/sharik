import 'dart:io';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/foundation.dart';

// todo review the process of defining the current connectivity method
class LocalIpService extends ChangeNotifier {
  List<NetworkInterface>? interfaces;
  String? _selectedInterface;

  set selectedInterface(String? selectedInterface) {
    _selectedInterface = selectedInterface;
    notifyListeners();
  }

  String? get selectedInterface => _selectedInterface;

  Future<void> load() async {
    interfaces = await NetworkInterface.list(type: InternetAddressType.IPv4);
    interfaces!.sort((a, b) => a.name.length - b.name.length);
    notifyListeners();
  }

  String getIp() {
    // todo refactor for different oses
    if (interfaces == null) {
      return 'loading';
    }

    if (_selectedInterface != null) {
      for (final el in interfaces!) {
        if (el.name == _selectedInterface) {
          return el.addresses.first.address;
        }
      }
    }

    final names = [
      // windows hotspot
      _getIpByName('Local Area Connection'),
      // ios/macos hotspot
      _getIpByName('bridge'),
      // linux hotspot
      _getIpByName('hotspot'),
      // windows wifi
      _getIpByName('Wi-Fi'),
      // linux ethernet
      _getIpByName('eth'),
      // linux wifi
      _getIpByName('wl'),
      // ios/macos wifi
      _getIpByName('en'),
    ];

    for (final el in names) {
      if (el != null) {
        return el;
      }
    }

    return interfaces![0].addresses.first.address;
  }

  String? _getIpByName(String name) => interfaces
      ?.firstWhereOrNull((element) => element.name.toLowerCase().contains(name.toLowerCase()))
      ?.addresses
      .first
      .address;

  Connectivity getConnectivityType() {
    switch (Platform.operatingSystem) {
      case 'windows':
        return _connectivityWindows();
      case 'linux':
        return _connectivityLinux();
      case 'android':
        return _connectivityLinux();
      case 'macos':
        return _connectivityMacos();
      case 'ios':
        return _connectivityMacos();
    }

    throw Exception('unknown platform: ${Platform.operatingSystem}');
  }

  Connectivity _connectivityMacos() {
    // todo eth - ?
    if (_interfaceExists('bridge')) {
      return Connectivity.hotspot;
    } else if (_interfaceExists('en')) {
      return Connectivity.wifi;
    }

    return Connectivity.unknown;
  }

  Connectivity _connectivityWindows() {
    if (_interfaceExists('Local Area Connection')) {
      return Connectivity.hotspot;
    } else if (_interfaceExists('Wi-Fi')) {
      return Connectivity.wifi;
    } else if (_interfaceExists('Ethernet')) {
      return Connectivity.ethernet;
    }

    return Connectivity.unknown;
  }

  Connectivity _connectivityLinux() {
    // todo for linux, use `lshw -class network` instead:
    if (_interfaceExists('hotspot')) {
      return Connectivity.hotspot;
    } else if (_interfaceExists('wl')) {
      return Connectivity.wifi;
    } else if (_interfaceExists('eth')) {
      return Connectivity.ethernet;
    }

    return Connectivity.unknown;
  }

  bool _interfaceExists(String name) {
    if (interfaces == null) {
      return false;
    }

    return interfaces!
        .where((element) => element.name.toLowerCase().contains(name.toLowerCase()))
        .isNotEmpty;
  }
}

enum Connectivity { wifi, ethernet, hotspot, cellular, none, unknown }

String connectivity2string(Connectivity c) {
// todo translate
  switch (c) {
    case Connectivity.wifi:
      return 'Wi-Fi';
    case Connectivity.ethernet:
      return 'Ethernet';
    case Connectivity.hotspot:
      return 'Hotspot';
    case Connectivity.cellular:
      return 'Cellular';
    case Connectivity.none:
      return 'None';
    case Connectivity.unknown:
      return 'Unknown';
  }
}

// class Connection {
//   final String ip;
//   final Connectivity connectivity;
//
//   const Connection({required this.ip, required this.connectivity});
// }
