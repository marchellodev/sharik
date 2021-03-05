import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_ar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_br.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_fa.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_gu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_hi.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_ml.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_pl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_ru.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_sk.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_tr.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_uk.dart';
import 'package:sharik/logic/language.dart';
import 'package:sharik/screens/languages.dart';
import 'package:sharik/screens/loading.dart';

List<int> get ports => [50500, 50050, 56789, 56788];

// add new languages here

enum Screens { loading, languagePicker }

Widget screen2widget(Screens s) {
  switch (s) {
    case Screens.loading:
      return LoadingScreen();
    case Screens.languagePicker:
      return LanguagePickerScreen();
  }
}

List<Language> get languageList => [
      Language(
          // 1.1 billion (400+700)
          name: 'english',
          nameLocal: 'English',
          locale: const Locale('en'),
          localizations: AppLocalizationsEn()),
      Language(
          // 592 million (322+270)
          name: 'hindi',
          nameLocal: 'हिन्दी',
          locale: const Locale('hi'),
          localizations: AppLocalizationsHi()),
      Language(
          // 313 million
          name: 'arabic',
          nameLocal: 'اتصل',
          locale: const Locale('ar'),
          localizations: AppLocalizationsAr()),
      Language(
          // 260 million (150+110)
          name: 'russian',
          nameLocal: 'Русский',
          locale: const Locale('ru'),
          localizations: AppLocalizationsRu()),
      Language(
          // 110 million
          name: 'farsi',
          nameLocal: 'فارسی',
          locale: const Locale('fa'),
          localizations: AppLocalizationsFa()),
      Language(
          // 90 million
          name: 'brazilian_portuguese',
          nameLocal: 'português brasileiro',
          locale: const Locale('pt_br'),
          localizations: AppLocalizationsBr()),
      Language(
          // 80 million
          name: 'turkish',
          nameLocal: 'Türkçe',
          locale: const Locale('tr'),
          localizations: AppLocalizationsTr()),
      Language(
          // 60 million (56+4)
          name: 'gujarati',
          nameLocal: 'ગુજરાતી',
          locale: const Locale('gu'),
          localizations: AppLocalizationsGu()),
      Language(
          // 50 million (45+5)
          name: 'polish',
          nameLocal: 'Polski',
          locale: const Locale('pl'),
          localizations: AppLocalizationsPl()),
      Language(
          // 45 million
          name: 'malayalam',
          nameLocal: 'മലയാളം',
          locale: const Locale('ml'),
          localizations: AppLocalizationsMl()),
      Language(
          // 40 million
          name: 'ukrainian',
          nameLocal: 'Українська',
          locale: const Locale('uk'),
          localizations: AppLocalizationsUk()),
      Language(
          // 5 million
          name: 'slovak',
          nameLocal: 'Slovenčina',
          locale: const Locale('sk'),
          localizations: AppLocalizationsSk())
    ];
