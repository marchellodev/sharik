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
  pl,
  @HiveField(4)
  inHi,
  @HiveField(5)
  inGu,
}

String locale2sign(LocaleModel locale) => locale.toString().split('.').last;

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
    case LocaleModel.inHi:
      return 'हिन्दी';
      break;
    case LocaleModel.inGu:
      return 'ગુજરાતી';
      break;
  }
  throw Exception('Unknown locale');
}

String getAndikaFont(LocaleModel locale) {
  if (locale == LocaleModel.inHi) {
    return 'Poppins';
  }
  if (locale == LocaleModel.inGu) {
    return 'Hind Vadodara';
  } else {
    return 'Andika';
  }
}
