import 'package:hive/hive.dart';
import 'package:sharik/locales/ar.dart';

import '../locales/in_gu.dart';
import '../locales/in_hi.dart';
import '../locales/pl.dart';
import '../locales/ru.dart';
import '../locales/ua.dart';

part 'locale.g.dart';

//todo: make creating translations easier
@HiveType(typeId: 0)
enum LocaleModel {
  @HiveField(0)
  en,
  @HiveField(1)
  ar,
  @HiveField(2)
  ru,
  @HiveField(3)
  ua,
  @HiveField(4)
  pl,
  @HiveField(5)
  inHi,
  @HiveField(6)
  inGu,
}

String locale2sign(LocaleModel locale) => locale.toString().split('.').last;

String locale2name(LocaleModel locale) {
  switch (locale) {
    case LocaleModel.en:
      return 'English';
    case LocaleModel.ar:
      return 'عربي';
    case LocaleModel.ru:
      return 'Русский';
    case LocaleModel.ua:
      return 'Українська';
    case LocaleModel.pl:
      return 'Polski';
    case LocaleModel.inHi:
      return 'हिन्दी';
    case LocaleModel.inGu:
      return 'ગુજરાતી';
  }
}

class LocaleAdapter {
  final Map<String, String> map;
  final LocaleModel locale;

  LocaleAdapter({required this.map, required this.locale});
}

LocaleAdapter getLocaleAdapter(LocaleModel locale) {
  switch (locale) {
    case LocaleModel.en:
      return LocaleAdapter(map: {}, locale: locale);
    case LocaleModel.ar:
      return LocaleAdapter(map: getAr, locale: locale);
    case LocaleModel.ru:
      return LocaleAdapter(map: getRu, locale: locale);
    case LocaleModel.ua:
      return LocaleAdapter(map: getUa, locale: locale);
    case LocaleModel.pl:
      return LocaleAdapter(map: getPl, locale: locale);
    case LocaleModel.inHi:
      return LocaleAdapter(map: getInHi, locale: locale);
    case LocaleModel.inGu:
      return LocaleAdapter(map: getInGu, locale: locale);
  }
}
