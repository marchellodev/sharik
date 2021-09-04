import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_ar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_br.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_de.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_fa.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_fr.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_id.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_ja.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_ml.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_pl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_pt.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_ru.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_sk.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_th.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_tr.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_uk.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_zh.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_es.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_te.dart';

import 'logic/language.dart';
import 'logic/sharing_object.dart';
import 'screens/about.dart';
import 'screens/error.dart';
import 'screens/home.dart';
import 'screens/intro.dart';
import 'screens/languages.dart';
import 'screens/loading.dart';
import 'screens/settings.dart';
import 'screens/share.dart';

const List<int> ports = [50500, 50050];

// only for fetching update
const String currentVersion = '3.1';
const String multipleFilesDelimiter = '|sharik|';

const Sources source = Sources.gitHub;
enum Sources {
  gitHub,
  githubRelease,
  playStore,
  snap,
  windowsStore,
  appStore,
  none
}

// todo fix urls & add another distributions methods
String source2url(Sources source) {
  switch (source) {
    case Sources.gitHub:
      return 'https://github.com/marchellodev/sharik';
    case Sources.githubRelease:
      return 'https://github.com/marchellodev/sharik/releases';
    case Sources.playStore:
      return 'https://play.google.com/store/apps/details?id=dev.marchello.sharik';
    case Sources.snap:
      return 'https://snapcraft.io/sharik-app';
    case Sources.windowsStore:
      return 'https://www.microsoft.com/store/apps/9NGCLB7JSPR9';
    case Sources.appStore:
      return 'https://apps.apple.com/app/id1531473857';

    case Sources.none:
      return 'https://unknown.com';
  }
}

// todo order by the date of contribution
// todo support non-github links
const contributors = <Contributor>[
  Contributor(
    name: 'Mark Motliuk',
    githubNickname: 'marchellodev',
    type: ContributorTypes.maintainer,
  ),
  Contributor(
    name: 'Behzad Najafzadeh',
    githubNickname: 'behzad-njf',
    type: ContributorTypes.translator,
  ),
  Contributor(
    name: 'Atrate',
    githubNickname: 'Atrate',
    type: ContributorTypes.translatorCoder,
  ),
  Contributor(
    name: 'Mr. Blogger',
    githubNickname: 'mrfoxie',
    type: ContributorTypes.translator,
  ),
  Contributor(
    name: 'Yazeed AlKhalaf',
    githubNickname: 'YazeedAlKhalaf',
    type: ContributorTypes.translator,
  ),
  Contributor(
    name: 'mezysinc',
    githubNickname: 'mezysinc',
    type: ContributorTypes.translator,
  ),
  Contributor(
    name: 'Tibor Repček',
    githubNickname: 'tiborepcek',
    type: ContributorTypes.translator,
  ),
  Contributor(
    name: 'T. E. Kalaycı',
    githubNickname: 'tekrei',
    type: ContributorTypes.translator,
  ),
  Contributor(
    name: 'zcraber',
    githubNickname: 'zcraber',
    type: ContributorTypes.translator,
  ),
  Contributor(
    name: '归零幻想',
    githubNickname: 'zerofancy',
    type: ContributorTypes.translator,
  ),
  Contributor(
    name: 'Aikatsui',
    githubNickname: 'Aikatsui',
    type: ContributorTypes.translator,
  ),
  Contributor(
    name: 'Davide Bottasso',
    githubNickname: 'DavideBottasso',
    type: ContributorTypes.translator,
  ),
  Contributor(
    name: 'liimee',
    githubNickname: 'liimee',
    type: ContributorTypes.translator,
  ),
  Contributor(
    name: 'liimee',
    githubNickname: 'liimee',
    type: ContributorTypes.translator,
  ),
  // [nesquick](https://twitter.com/mamanamgae)
  Contributor(
    name: 'nesquick',
    githubNickname: '',
    type: ContributorTypes.translator,
  ),
  Contributor(
      name: 'mondstern',
      githubNickname: 'mondlicht-und-sterne',
      type: ContributorTypes.translator),
  // - Portuguese by [azilara](https://crowdin.com/profile/azilara)
  Contributor(
    name: 'azilara',
    githubNickname: '',
    type: ContributorTypes.translator,
  ),
   Contributor(
    name: '312k',
    githubNickname: '312k',
    type: ContributorTypes.translator,
  ),
  Contributor(
      name: 'scybernaut',
      githubNickname: 'scybernaut',
      type: ContributorTypes.translator),
  // [Sebastian Jasiński](https://crowdin.com/profile/princenorris)
  Contributor(
      name: 'Sebastian Jasiński',
      githubNickname: '',
      type: ContributorTypes.translator),
];

class Contributor {
  final String name;
  final String githubNickname;
  final ContributorTypes type;

  const Contributor({
    required this.name,
    required this.githubNickname,
    required this.type,
  });
}

enum ContributorTypes { maintainer, coder, translator, translatorCoder }

String contributorType2string(ContributorTypes type) {
  switch (type) {
    case ContributorTypes.maintainer:
      return 'Maintainer';
    case ContributorTypes.coder:
      return 'Coder';
    case ContributorTypes.translator:
      return 'Translator';
    case ContributorTypes.translatorCoder:
      return 'Coder & Translator';
  }
}

// todo indonesian
List<Language> get languageList => [
      Language(
          // 1.3 billion (400+700)
          name: 'english',
          nameLocal: 'English',
          locale: const Locale('en'),
          localizations: AppLocalizationsEn()),
      Language(
          // 1.3 billion (400+700)
          name: 'chinese',
          nameLocal: '汉语',
          locale:
              const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
          localizations: AppLocalizationsZh()),
      // Language(
      //     // 592 million (322+270)
      //     name: 'hindi',
      //     nameLocal: 'हिन्दी',
      //     locale: const Locale('hi'),
      //     localizations: AppLocalizationsHi()),

      Language(
          // 590 million
          name: 'spanish',
          nameLocal: 'español',
          locale: const Locale.fromSubtags(languageCode: 'es'),
          localizations: AppLocalizationsEs()),
      Language(
          // 300+ million
          name: 'french',
          nameLocal: 'français',
          locale: const Locale('fr'),
          localizations: AppLocalizationsFr()),
      Language(
          // rtl
          // 313 million
          name: 'arabic',
          nameLocal: 'اتصل',
          locale: const Locale('ar'),
          localizations: AppLocalizationsAr()),
      Language(
          // 313 million
          name: 'portuguese',
          nameLocal: 'português',
          locale: const Locale('pt'),
          localizations: AppLocalizationsPt()),
      Language(
          // 260 million (150+110)
          name: 'russian',
          nameLocal: 'Русский',
          locale: const Locale('ru'),
          localizations: AppLocalizationsRu()),
      Language(
          // 200+ million
          name: 'german',
          nameLocal: 'Deutsch',
          locale: const Locale('de'),
          localizations: AppLocalizationsDe()),
      Language(
          // 200 million
          name: 'indonesian',
          nameLocal: 'bahasa Indonesia',
          locale: const Locale('id'),
          localizations: AppLocalizationsId()),
      Language(
          // rtl
          // 110 million
          name: 'farsi',
          nameLocal: 'فارسی',
          locale: const Locale('fa'),
          localizations: AppLocalizationsFa()),
      Language(
          // 94 million
          name: 'telugu',
          nameLocal: 'తెలుగు',
          locale: const Locale('te'),
          localizations: AppLocalizationsTe()),
      Language(
          // 90 million
          name: 'brazilian_portuguese',
          nameLocal: 'português brasileiro',
          locale: const Locale('br'),
          localizations: AppLocalizationsBr()),
      Language(
          // 85 million
          name: 'italian',
          nameLocal: 'italiano',
          locale: const Locale('it'),
          localizations: AppLocalizationsIt()),
      Language(
          // 85 million
          name: 'japanese',
          nameLocal: '日本語',
          locale: const Locale('ja'),
          localizations: AppLocalizationsIt()),
      Language(
          // 80 million
          name: 'turkish',
          nameLocal: 'Türkçe',
          locale: const Locale('tr'),
          localizations: AppLocalizationsTr()),

      Language(
          // 70+ million
          name: 'thai',
          nameLocal: 'ภาษาไทย',
          locale: const Locale('th'),
          localizations: AppLocalizationsTh()),

      // Language(
      //     // 60 million (56+4)
      //     name: 'gujarati',
      //     nameLocal: 'ગુજરાતી',
      //     locale: const Locale('gu'),
      //     localizations: AppLocalizationsGu()),
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
      // Language(
      //     // 20 million
      //     name: 'sinhala',
      //     nameLocal: 'සිංහල',
      //     locale: const Locale('sin'),
      //     localizations: AppLocalizationsSi()),
      Language(
          // 5 million
          name: 'slovak',
          nameLocal: 'Slovenčina',
          locale: const Locale('sk'),
          localizations: AppLocalizationsSk())
    ];

enum Screens {
  loading,
  languagePicker,
  intro,
  home,
  about,
  sharing,
  error,
  settings,
}

Widget screen2widget(Screens s, [Object? args]) {
  switch (s) {
    case Screens.loading:
      return LoadingScreen();
    case Screens.languagePicker:
      return LanguagePickerScreen();
    case Screens.intro:
      return IntroScreen();
    case Screens.home:
      return HomeScreen();
    case Screens.about:
      return AboutScreen();
    case Screens.sharing:
      return SharingScreen(args! as SharingObject);
    case Screens.settings:
      return SettingsScreen();
    case Screens.error:
      return ErrorScreen(args! as String);
  }
}
