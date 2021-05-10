import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:sharik/components/page_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../conf.dart';
import '../utils/helper.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext c) {
    return Scaffold(
      body: IntroSlider(
        nameDoneBtn: c.l.introGeneralDone,
        nameNextBtn: c.l.introGeneralNext,
        showSkipBtn: false,
        styleDoneBtn:
            GoogleFonts.getFont(c.l.fontComfortaa, color: Colors.white),
        stylePrevBtn:
            GoogleFonts.getFont(c.l.fontComfortaa, color: Colors.white),
        colorDot: Colors.white70,
        colorActiveDot: Colors.white,
        // todo use svgs instead
        // todo work on slides & descriptions
        slides: [
          Slide(
            styleTitle: GoogleFonts.getFont(
              c.l.fontComfortaa,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),
            styleDescription: GoogleFonts.getFont(c.l.fontAndika,
                color: Colors.white, fontSize: 18.0),
            title: c.l.intro1ConnectTitle,
            description: c.l.intro1ConnectDescription,
            pathImage: 'assets/slides/1_connect.png',
            backgroundColor: Colors.purple.shade400,
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
            title: c.l.intro2SendTitle,
            description: c.l.intro2SendDescription,
            pathImage: 'assets/slides/2_send.png',
            backgroundColor: Colors.indigo[400]!,
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
            title: c.l.intro3ReceiveTitle,
            description: c.l.intro3ReceiveDescription,
            pathImage: 'assets/slides/3_receive.png',
            backgroundColor: Colors.teal[400]!,
          ),
          Slide(
            styleTitle: GoogleFonts.getFont(
              c.l.fontComfortaa,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
            title: c.l.intro4EverywhereTitle,
            pathImage: 'assets/slides/4_everywhere.png',
            backgroundColor: Colors.blueGrey[400]!,
            widgetDescription: GestureDetector(
              onTap: () async {
                if (await canLaunch('https://github.com/marchellodev/sharik')) {
                  await launch('https://github.com/marchellodev/sharik');
                }
              },
              child: Text(
                c.l.intro4EverywhereDescription,
                style: GoogleFonts.getFont(c.l.fontAndika,
                    color: Colors.white, fontSize: 18.0),
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
        onDonePress: () => SharikRouter.navigateTo(
            c, this, Screens.home, RouteDirection.right),
      ),
    );
  }
}
