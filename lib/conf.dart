import 'dart:ui';

import 'package:sharik/logic/language.dart';

List<int> get ports => [50500, 50050, 56789, 56788];

// add new languages here

List<Language> get languageList => const [
      Language(name: 'english', nameLocal: 'English', locale: Locale('en')),
      Language(name: 'hindi', nameLocal: 'हिन्दी', locale: Locale('hi')),
      Language(name: 'russian', nameLocal: 'Русский', locale: Locale('ru')),
      Language(name: 'gujarati', nameLocal: 'ગુજરાતી', locale: Locale('gu')),
      Language(name: 'polish', nameLocal: 'Polski', locale: Locale('pl')),
      Language(
          name: 'ukrainian', nameLocal: 'Українська', locale: Locale('ua')),
    ];
