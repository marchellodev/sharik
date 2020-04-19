import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/app.dart';
import '../models/locale.dart';
import '../models/page.dart';

class LanguagePage extends StatelessWidget {
  Widget button(LocaleModel locale, AppModel model) => Container(
      height: 100,
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Colors.deepPurple[400],
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: <Widget>[
              Center(
                  child: Text(locale2name(locale),
                      style: GoogleFonts.andika(
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 24)))),
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

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<AppModel>(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 8, bottom: 28),
            child: Text(
              'Select the language\nyou are familiar\nwith',
              textAlign: TextAlign.center,
              style: GoogleFonts.comfortaa(
                fontSize: 26,
              ),
            ),
          ),
          button(LocaleModel.en, model),
          SizedBox(height: 24),
          button(LocaleModel.ru, model),
          SizedBox(height: 24),
          button(LocaleModel.ua, model),
        ],
      ),
    );
  }
}
