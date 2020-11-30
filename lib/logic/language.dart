import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'file:///C:/Users/markm/IdeaProjects/sharik/lib/conf.dart';

class Language {
  final String name;
  final String nameLocal;
  final Locale locale;
  final String contributorName;
  final String contributorLink;

  const Language(
      {@required this.name,
      @required this.nameLocal,
      @required this.locale,
      this.contributorName,
      this.contributorLink});
}

class LanguageManager extends ChangeNotifier {
  Language _language =
      languageList.firstWhere((element) => element.name == 'english');

  LanguageManager() {
    final l = Hive.box<String>('strings').get('language', defaultValue: null);

    if (l != null) {
      _language = languageList.firstWhere((element) => element.name == l);
      return;
    }

    final locales = WidgetsBinding.instance.window.locales;
    for (final locale in locales) {
      final language = languageList.firstWhere(
          (element) => element.locale == locale,
          orElse: () => null);

      if (language != null) {
        _language = language;
        break;
      }
    }
  }

  Language get language => _language;

  set language(Language language) {
    _language = language;
    Hive.box<String>('strings').put('language', _language.name);

    notifyListeners();
  }
}
