import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeManager extends ChangeNotifier {
  ThemeMode _theme = ThemeMode.system;

  ThemeMode get theme => _theme;

  set theme(ThemeMode val) {
    _theme = val;
    if (val == ThemeMode.system) {
      Hive.box<String>('strings').delete('theme');
    } else {
      Hive.box<String>('strings')
          .put('theme', val == ThemeMode.light ? 'light' : 'dark');
    }

    notifyListeners();
  }

  void change() {
    if (theme == ThemeMode.system) {
      theme = ThemeMode.dark;
    } else if (theme == ThemeMode.dark) {
      theme = ThemeMode.light;
    } else {
      theme = ThemeMode.system;
    }
  }

  IconData get icon {
    // final theme = manager.theme;

    if (theme == ThemeMode.light) {
      return Icons.brightness_high_rounded;
    } else if (theme == ThemeMode.dark) {
      return Icons.brightness_low_rounded;
    } else {
      return Icons.brightness_auto_rounded;
    }
  }

  // }
  // static IconData getIcon(ThemeManager manager) {
  //   final theme = manager.theme;
  //
  //   if (theme == ThemeMode.light) {
  //     return Icons.brightness_6;
  //   } else if (theme == ThemeMode.dark) {
  //     return Icons.brightness_7;
  //   } else {
  //     return Icons.brightness_auto_rounded;
  //   }
  // }

  ThemeManager() {
    if (Hive.box<String>('strings').containsKey('theme')) {
      final theme = Hive.box<String>('strings').get('theme');
      if (theme == 'light') {
        _theme = ThemeMode.light;
      } else if (theme == 'dark') {
        _theme = ThemeMode.dark;
      }
    }
  }
}
