import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:sharik/logic/navigation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/helper.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext c) {
    return IntroSlider(
      nameDoneBtn: c.l.introGeneralDone,
      nameNextBtn: c.l.introGeneralNext,
      isShowSkipBtn: false,
      styleNameDoneBtn:
          GoogleFonts.getFont(c.l.fontComfortaa, color: Colors.white),
      styleNamePrevBtn:
          GoogleFonts.getFont(c.l.fontComfortaa, color: Colors.white),
      colorDot: Colors.white70,
      colorActiveDot: Colors.white,
      slides: <Slide>[
        Slide(
          styleTitle: GoogleFonts.getFont(
            c.l.fontComfortaa,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ),
          styleDescription: GoogleFonts.getFont(c.l.fontAndika,
              color: Colors.white, fontSize: 18.0),
          title: 'CONNECT',
          description:
              'Connect devices to the same network - use Wi-Fi or Mobile Hotspot',
          pathImage: 'assets/slide_1.png',
          backgroundColor: Colors.purple[400],
        ),
        Slide(
          styleTitle: GoogleFonts.getFont(
            c.l.fontComfortaa,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ),
          styleDescription: GoogleFonts.getFont(c.l.fontAndika,
              color: Colors.white, fontSize: 18.0),
          title: 'SEND',
          description: 'Select any file you like',
          pathImage: 'assets/slide_2.png',
          backgroundColor: Colors.indigo[400],
        ),
        Slide(
          styleTitle: GoogleFonts.getFont(
            c.l.fontComfortaa,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ),
          styleDescription: GoogleFonts.getFont(c.l.fontAndika,
              color: Colors.white, fontSize: 18.0),
          title: 'RECEIVE',
          description: 'Open given link on another device in any browser',
          pathImage: 'assets/slide_3.png',
          backgroundColor: Colors.teal[400],
        ),
        Slide(
          styleTitle: GoogleFonts.getFont(
            c.l.fontComfortaa,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ),
          title: 'EVERYWHERE',
          pathImage: 'assets/slide_4.png',
          backgroundColor: Colors.blueGrey[400],
          widgetDescription: GestureDetector(
            onTap: () async {
              if (await canLaunch('https://github.com/marchellodev/sharik')) {
                await launch('https://github.com/marchellodev/sharik');
              }
            },
            child: Text(
              'Click here to learn more',
              style: GoogleFonts.getFont(c.l.fontAndika,
                  color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
      onDonePress: () => c.n.page = HomePage(),
    );
  }
}
