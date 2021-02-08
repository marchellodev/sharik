import 'package:flutter/material.dart';
import 'package:sharik/screens/home.dart';
import 'package:sharik/screens/intro.dart';
import 'package:sharik/screens/languages.dart';
import 'package:sharik/screens/loading.dart';
import 'package:sharik/screens/share.dart';

// todo think about this organization once again

class NavigationManager {
  NPage _page = LanguagePage();
  Function(NPage page) _onChange;

  NPage get page => _page;

  set onChange(Function(NPage page) f) => _onChange = f;

  set page(NPage page) {
    _page = page;
    _onChange(_page);
  }
}

abstract class NPage {
  Widget get widget;
}

class LoadingPage extends NPage {
  @override
  Widget get widget => LoadingScreen();
}

class LanguagePage extends NPage {
  @override
  Widget get widget => LanguageScreen();
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
  Widget get widget => SharingScreen();
}
