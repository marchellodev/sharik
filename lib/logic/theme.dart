import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';
import '../utils/helper.dart';

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

  String name(BuildContext context) {
    switch (theme) {
      case ThemeMode.system:
        return context.l.settingsThemeSystem;
      case ThemeMode.light:
        return context.l.settingsThemeLight;
      case ThemeMode.dark:
        return context.l.settingsThemeDark;
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
