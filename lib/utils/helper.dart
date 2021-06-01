import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

T? cast<T>(dynamic x) => x is T ? x : null;

extension LocaleContext on BuildContext {
  AppLocalizations get l => AppLocalizations.of(this)!;
}

extension ThemeContext on BuildContext {
  ThemeData get t => Theme.of(this);
}
