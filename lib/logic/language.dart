import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

import '../conf.dart';

class Language {
  final String name;
  final String nameLocal;
  final Locale locale;
  final String? contributorName;
  final String? contributorLink;
  final AppLocalizations localizations;

  const Language(
      {required this.name,
      required this.nameLocal,
      required this.locale,
      required this.localizations,
      this.contributorName,
      this.contributorLink});
}

// todo review ChangeNotifier
class LanguageManager extends ChangeNotifier {
  Language _language =
      languageList.firstWhere((element) => element.name == 'english');
  
  bool _languageSet = false;
  bool get isLanguageSet => _languageSet;


  Language get language => _language;
  set language(Language language) {
    _language = language;
    Hive.box<String>('strings').put('language', _language.name);

    notifyListeners();
  }

  void init() {

    final l = Hive.box<String>('strings').get('language', defaultValue: null);

    if (l != null) {
      _language = languageList.firstWhere((element) => element.name == l);
      _languageSet = true;
      notifyListeners();
      return;
    }

    final locales = WidgetsBinding.instance!.window.locales;
    for (final locale in locales) {
      final language =
          languageList.firstWhereOrNull((element) => element.locale == locale);

      if (language != null) {
        _language = language;
        break;
      }
    }

    notifyListeners();
  }

  
}
