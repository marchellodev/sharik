import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'file.dart';
import 'locale.dart';
import 'page.dart';

class AppModel {
  LocaleModel locale = LocaleModel.en;
  FileModel file;

  final TabController _pagerGlobal;
  final TabController _pagerHome;
  final Function(VoidCallback fn) setState;

  AppModel(this._pagerGlobal, this._pagerHome, this.setState) {
    locale = Hive.box('app2').get('locale', defaultValue: null);
    if (locale != null) {
      setPage(PageModel.home);
    } else {
      setPage(PageModel.language);
    }
  }

  void setLocale(LocaleModel newLocale) {
    locale = newLocale;
    Hive.box('app2').put('locale', locale);
  }

  void setPage(PageModel page) {
    switch (page) {
      case PageModel.loading:
        _pagerHome.animateTo(0);
        _pagerGlobal.animateTo(0);
        break;
      case PageModel.language:
        _pagerHome.animateTo(0);
        _pagerGlobal.animateTo(1);
        break;
      case PageModel.intro:
        _pagerHome.animateTo(0);
        _pagerGlobal.animateTo(2);
        break;
      case PageModel.home:
        _pagerHome.animateTo(0);
        _pagerGlobal.animateTo(3);
        break;
      case PageModel.sharing:
        _pagerGlobal.animateTo(3);
        _pagerHome.animateTo(1);
        break;
    }
  }

  PageModel getPage() {
    var home = _pagerHome.index;
    var global = _pagerGlobal.index;

    if (home == 0) {
      switch (global) {
        case 0:
          return PageModel.loading;
        case 1:
          return PageModel.language;
        case 2:
          return PageModel.intro;
        case 3:
          return PageModel.home;
      }
    } else if (global == 3) {
      return PageModel.sharing;
    } else {
      throw Exception('Wrong page or something');
    }

    return null;
  }
}
