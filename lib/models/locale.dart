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
