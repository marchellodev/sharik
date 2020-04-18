import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:url_launcher/url_launcher.dart';

import '../locale.dart';
import '../main.dart';

class IntroPage extends StatelessWidget {
  final Function tap;

  IntroPage(this.tap);

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      nameDoneBtn: L.get('DONE', locale),
      nameNextBtn: L.get('NEXT', locale),
      isShowSkipBtn: false,
      styleNameDoneBtn:
          GoogleFonts.comfortaa(textStyle: TextStyle(color: Colors.white)),
      styleNamePrevBtn:
          GoogleFonts.comfortaa(textStyle: TextStyle(color: Colors.white)),
      colorDot: Colors.white70,
      colorActiveDot: Colors.white,
      slides: <Slide>[
        Slide(
          styleTitle: GoogleFonts.comfortaa(
              textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          )),
          styleDescription: GoogleFonts.andika(
              textStyle: TextStyle(color: Colors.white, fontSize: 18.0)),
          title: L.get('CONNECT', locale),
          description: L.get('connect_same', locale),
          pathImage: 'assets/slide_1.png',
          backgroundColor: Colors.purple[400],
        ),
        Slide(
          styleTitle: GoogleFonts.comfortaa(
              textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          )),
          styleDescription: GoogleFonts.andika(
              textStyle: TextStyle(color: Colors.white, fontSize: 18.0)),
          title: L.get('SEND', locale),
          description: L.get('select_any', locale),
          pathImage: 'assets/slide_2.png',
          backgroundColor: Colors.indigo[400],
        ),
        Slide(
          styleTitle: GoogleFonts.comfortaa(
              textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          )),
          styleDescription: GoogleFonts.andika(
              textStyle: TextStyle(color: Colors.white, fontSize: 18.0)),
          title: L.get('RECEIVE', locale),
          description: L.get('open_link', locale),
          pathImage: 'assets/slide_3.png',
          backgroundColor: Colors.teal[400],
        ),
        Slide(
          styleTitle: GoogleFonts.comfortaa(
              textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          )),
          title: L.get('EVERYWHERE', locale),
          pathImage: 'assets/slide_4.png',
          backgroundColor: Colors.blueGrey[400],
          widgetDescription: GestureDetector(
            onTap: () async {
              if (await canLaunch('https://github.com/marchellodev/sharik'))
                await launch('https://github.com/marchellodev/sharik');
            },
            child: Text(
              L.get('sharik_is_available', locale),
              style: GoogleFonts.andika(
                  textStyle: TextStyle(color: Colors.white, fontSize: 18.0)),
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
      onDonePress: tap,
    );
  }
}
