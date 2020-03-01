import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

// ignore: must_be_immutable
class LanguagePage extends StatelessWidget {
  Callback back;

  LanguagePage(this.back);

  Widget button(String locale) {
    String text;
    switch(locale){
      case 'en': text = 'English'; break;
      case 'ua': text = 'Українська'; break;
      case 'ru': text = 'Русский'; break;
    }

    return Container(
        height: 100,
        child: Material(
          borderRadius: BorderRadius.circular(12),
          color: Color(0xFF7E57C2),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: <Widget>[
                Center(
                    child: Text(text,
                        style: GoogleFonts.andika(
                            textStyle:
                            TextStyle(color: Colors.white, fontSize: 24)))),
                Container(
                  margin: EdgeInsets.all(6),
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: SvgPicture.asset(
                        'assets/flag_$locale.svg',
                      )),
                )
              ],
            ),
            onTap: () => back(locale),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 28, bottom: 28),
              child: Text(
                "Select the language\nyou are familiar\nwith",
                textAlign: TextAlign.center,
                style: GoogleFonts.comfortaa(
                  fontSize: 26,
                ),
              ),
            ),
            button('en'),
            SizedBox(height: 24),
            button('ru'),
            SizedBox(height: 24),
            button('ua'),
          ],
        ),
      );
}
