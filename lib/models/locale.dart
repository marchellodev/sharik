import 'package:flutter/foundation.dart';
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
      break;
    case LocaleModel.ar:
      return 'عربي';
      break;
    case LocaleModel.ru:
      return 'Русский';
      break;
    case LocaleModel.ua:
      return 'Українська';
      break;
    case LocaleModel.pl:
      return 'Polski';
      break;
    case LocaleModel.inHi:
      return 'हिन्दी';
      break;
    case LocaleModel.inGu:
      return 'ગુજરાતી';
      break;
  }
  throw Exception('Unknown locale');
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
      break;
    case LocaleModel.ar:
      return LocaleAdapter(map: getAr, locale: locale);
      break;
    case LocaleModel.ru:
      return LocaleAdapter(map: getRu, locale: locale);
      break;
    case LocaleModel.ua:
      return LocaleAdapter(map: getUa, locale: locale);
      break;
    case LocaleModel.pl:
      return LocaleAdapter(map: getPl, locale: locale);
      break;
    case LocaleModel.inHi:
      return LocaleAdapter(map: getInHi, locale: locale);
      break;
    case LocaleModel.inGu:
      return LocaleAdapter(map: getInGu, locale: locale);
      break;
  }
  throw Exception('no such local!!!');
}
