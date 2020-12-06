import 'dart:ui';

import 'package:flutter_gen/gen_l10n/app_localizations_ar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_gu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_hi.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_pl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_ru.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_uk.dart';
import 'package:sharik/logic/language.dart';

List<int> get ports => [50500, 50050, 56789, 56788];

// add new languages here

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
          // 40 million
          name: 'ukrainian',
          nameLocal: 'Українська',
          locale: const Locale('uk'),
          localizations: AppLocalizationsUk())
    ];
