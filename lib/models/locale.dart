import 'package:hive/hive.dart';

part 'locale.g.dart';

@HiveType(typeId: 0)
enum LocaleModel {
  @HiveField(0)
  en,
  @HiveField(1)
  ru,
  @HiveField(2)
  ua
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
  }
  throw Exception('Unknown locale');
}
