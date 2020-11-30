import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sharik/logic/navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../logic/language.dart';
import '../utils/helper.dart';

class LanguageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
// todo use layouts
//     Localizations.of<MaterialLocalizations>(context, MaterialLocalizations).can



    return Expanded(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 28),
            child: Text(
              'Select the language\nyou are familiar\nwith',
              textAlign: TextAlign.center,
              style: GoogleFonts.getFont(
                'Comfortaa',
                fontSize: 24,
              ),
            ),
          ),
          LanguageButton(LocaleModel.en, model),
          const SizedBox(height: 14),
          LanguageButton(LocaleModel.inHi, model),
          const SizedBox(height: 14),
          LanguageButton(LocaleModel.ru, model),
          const SizedBox(height: 14),
          LanguageButton(LocaleModel.inGu, model),
          const SizedBox(height: 14),
          LanguageButton(LocaleModel.pl, model),
          const SizedBox(height: 14),
          LanguageButton(LocaleModel.ua, model),
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}

class LanguageButton extends StatelessWidget {
  final Language language;

  const LanguageButton(this.language);

  @override
  Widget build(BuildContext c) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: SizedBox(
            height: 90,
            child: Material(
              borderRadius: BorderRadius.circular(12),
              color: Colors.deepPurple[400],
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  // todo use either language or locale
                  c.read<LanguageManager>().language = language;
                  c.n.page = IntroPage()
                },
                child: Stack(
                  children: <Widget>[
                    Center(
                        child: Text(language.nameLocal,
                            style: GoogleFonts.getFont(
                                L('Andika', getLocaleAdapter(locale)),
                                color: Colors.white,
                                fontSize: 24))),
                    Container(
                      margin: const EdgeInsets.all(6),
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: SvgPicture.asset(
                            'assets/flags/${language.name}.svg',
                          )),
                    )
                  ],
                ),
              ),
            )),
      );
}
