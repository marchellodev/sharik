import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

import '../locale.dart';
import '../main.dart';

// ignore: must_be_immutable
class IntroPage extends StatelessWidget {
  Function tap;

  IntroPage(this.tap);

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
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
          backgroundColor: Color(0xFFEF5350),
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
          backgroundColor: Color(0xFFAB47BC),
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
          backgroundColor: Color(0xFF5C6BC0),
        ),
      ],
      onDonePress: tap,
    );
  }
}
