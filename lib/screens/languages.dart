import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../components/buttons.dart';
import '../components/logo.dart';
import '../components/page_router.dart';
import '../conf.dart';
import '../logic/language.dart';

// review: done

class LanguagePickerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const SafeArea(
            child: SizedBox(
              height: 24,
            ),
          ),
          SharikLogo(),
          const SizedBox(
            height: 24,
          ),
          Text(
            'Select the language\nyou are familiar with',
            textAlign: TextAlign.center,
            style: GoogleFonts.getFont(
              'Comfortaa',
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 24),
          for (var lang in languageList) ...[
            LanguageButton(lang, () {
              context.read<LanguageManager>().language = lang;
              SharikRouter.navigateTo(
                  context, this, Screens.intro, RouteDirection.right);
            }),
            const SizedBox(height: 6)
          ],
        ],
      ),
    );
  }
}

class LanguageButton extends StatelessWidget {
  final Language language;
  final Function() onClick;

  const LanguageButton(this.language, this.onClick);

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: PrimaryButton(
        height: 78,
        onClick: onClick,
        text: language.nameLocal,
        secondaryIcon: SvgPicture.asset(
          'assets/flags/${language.name}.svg',
        ),
        font: language.localizations.fontAndika,
      ));
}
