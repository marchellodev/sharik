import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../locale.dart';
import '../models/app.dart';
import '../models/locale.dart';
import '../models/page.dart';

class LanguagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AppModel>(context);

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
  final LocaleModel locale;
  final AppModel model;

  const LanguageButton(this.locale, this.model);

  @override
  Widget build(BuildContext context) => SizedBox(
      height: 90,
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Colors.deepPurple[400],
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            model.setLocale(locale);
            model.setPage(PageModel.intro);
          },
          child: Stack(
            children: <Widget>[
              Center(
                  child: Text(locale2name(locale),
                      style: GoogleFonts.getFont(
                          L('Andika', getLocaleAdapter(locale)),
                          color: Colors.white,
                          fontSize: 24))),
              Container(
                margin: const EdgeInsets.all(6),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: SvgPicture.asset(
                      'assets/flag_${locale2sign(locale)}.svg',
                    )),
              )
            ],
          ),
        ),
      ));
}
