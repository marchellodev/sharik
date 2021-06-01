import 'package:flutter/material.dart';

import '../screens/about.dart';
import '../screens/home.dart';
import '../screens/intro.dart';
import '../screens/languages.dart';
import '../screens/loading.dart';
import 'sharing_object.dart';

// todo think about this organization once again

class NavigationManager {
  NPage _page = HomePage();
  late Function(NPage page) _onChange;
  SharingObject? file;

  NPage get page => _page;

  set onChange(Function(NPage page) f) => _onChange = f;

  set page(NPage page) {
    _page = page;
    _onChange(_page);
  }
}

// todo use enum instead

abstract class NPage {
  Widget get widget;

  const NPage();
}

class LoadingPage extends NPage {
  @override
  Widget get widget => LoadingScreen();
}

class LanguagePage extends NPage {
  @override
  Widget get widget => LanguagePickerScreen();
}

class IntroPage extends NPage {
  @override
  Widget get widget => IntroScreen();
}

class HomePage extends NPage {
  @override
  Widget get widget => HomeScreen();
}

class SharingPage extends NPage {
  @override
  Widget get widget => Text('err');
}

class AboutPage extends NPage {
  @override
  Widget get widget => AboutScreen();
}
