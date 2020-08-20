import 'package:flutter/foundation.dart';

import 'models/locale.dart';

String L(String key, LocaleAdapter adapter) {
  if (adapter.locale == LocaleModel.en) {
    return key;
  }

  if (!adapter.map.containsKey(key)) {
    if (kReleaseMode) {
      return key;
    } else {
      throw Exception('not translated "$key" to ${adapter.locale}');
    }
  }

  return adapter.map[key];
}
