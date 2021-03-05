import 'dart:io';

import 'package:collection/collection.dart' show IterableExtension;

Future<String> getIp() async {
  final list = await NetworkInterface.list(type: InternetAddressType.IPv4);

  for (final el in list) {
    print(el);
  }

  if (Platform.isAndroid) {
    final ip = list.firstWhereOrNull((element) => element.name == 'wlan0');

    if (ip != null) {
      return ip.addresses.first.address;
    }
  } else if (Platform.isWindows) {
    final ip = list.firstWhereOrNull((element) => element.name == 'Wi-Fi');

    if (ip != null) {
      return ip.addresses.first.address;
    }
  }

  if (list.isEmpty) {
    return 'null';
  } else {
    return list[0].addresses.first.address;
  }
}
