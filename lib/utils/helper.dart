import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sharik/logic/navigation.dart';

T? cast<T>(dynamic x) => x is T ? x : null;

extension LocaleContext on BuildContext {
  AppLocalizations get l => AppLocalizations.of(this)!;
}

extension NavigatorContext on BuildContext {
  NavigationManager get n => read<NavigationManager>();
}

extension ThemeContext on BuildContext {
  ThemeData get t => Theme.of(this);
}
