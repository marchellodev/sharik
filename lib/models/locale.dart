import 'package:hive/hive.dart';

part 'locale.g.dart';

//todo: make creating translations easier
@HiveType(typeId: 0)
enum LocaleModel {
  @HiveField(0)
  en,
  @HiveField(1)
  ru,
  @HiveField(2)
  ua,
  @HiveField(3)
  pl
}

String locale2sign(LocaleModel locale) {
  switch (locale) {
    case LocaleModel.en:
      return 'en';
      break;
    case LocaleModel.ru:
      return 'ru';
      break;
    case LocaleModel.ua:
      return 'ua';
      break;
    case LocaleModel.pl:
      return 'pl';
      break;
  }
  throw Exception('Unknown locale');
}

String locale2name(LocaleModel locale) {
  switch (locale) {
    case LocaleModel.en:
      return 'English';
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
  }
  throw Exception('Unknown locale');
}
