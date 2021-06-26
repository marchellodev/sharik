import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';
import 'package:lucide_icons/lucide_icons.dart';

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

  Brightness get brightness => _theme == ThemeMode.system
      ? SchedulerBinding.instance!.window.platformBrightness
      : (_theme == ThemeMode.dark ? Brightness.dark : Brightness.light);

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

    if (theme == ThemeMode.light) {
      return LucideIcons.sun;
    } else if (theme == ThemeMode.dark) {
      return LucideIcons.moon;
    } else {
      return LucideIcons.monitor;
    }
  }

  void init() {

    if (Hive.box<String>('strings').containsKey('theme')) {
      final theme = Hive.box<String>('strings').get('theme');
      if (theme == 'light') {
        _theme = ThemeMode.light;
      } else if (theme == 'dark') {
        _theme = ThemeMode.dark;
      }
    }
    notifyListeners();
  }
}
