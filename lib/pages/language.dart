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
    var model = Provider.of<AppModel>(context);

    return Expanded(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24),
        physics: AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 8, bottom: 28),
            child: Text(
              'Select the language\nyou are familiar\nwith',
              textAlign: TextAlign.center,
              style: GoogleFonts.getFont(
                'Comfortaa',
                fontSize: 26,
              ),
            ),
          ),
          LanguageButton(LocaleModel.en, model),
          SizedBox(height: 16),
          LanguageButton(LocaleModel.inHi, model),
          SizedBox(height: 16),
          LanguageButton(LocaleModel.ru, model),
          SizedBox(height: 16),
          LanguageButton(LocaleModel.inGu, model),
          SizedBox(height: 16),
          LanguageButton(LocaleModel.pl, model),
          SizedBox(height: 16),
          LanguageButton(LocaleModel.ua, model),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class LanguageButton extends StatelessWidget {
  final LocaleModel locale;
  final AppModel model;

  LanguageButton(this.locale, this.model);

  @override
  Widget build(BuildContext context) => Container(
      height: 90,
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Colors.deepPurple[400],
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: <Widget>[
              Center(
                  child: Text(locale2name(locale),
                      style: GoogleFonts.getFont(
                          L('Andika', getLocaleAdapter(locale)),
                          color: Colors.white,
                          fontSize: 24))),
              Container(
                margin: EdgeInsets.all(6),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: SvgPicture.asset(
                      'assets/flag_${locale2sign(locale)}.svg',
                    )),
              )
            ],
          ),
          onTap: () {
            model.setLocale(locale);
            model.setPage(PageModel.intro);
          },
        ),
      ));
}
