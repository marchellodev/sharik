import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/page_router.dart';
import '../conf.dart';
import '../utils/helper.dart';

// review: done

// todo minor: manage colors when clicking on buttons
class IntroScreen extends StatelessWidget {
  final _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: WillPopScope(
        onWillPop: () async {
          SharikRouter.navigateTo(
              _globalKey, Screens.home, RouteDirection.right);

          return false;
        },
        child: Scaffold(
          body: IntroSlider(
            isScrollable: true,
            colorDot: Colors.white70,
            colorActiveDot: Colors.white,
            // todo check border radius compared to the bottom bar
            borderRadiusDoneBtn: 8,
            showSkipBtn: false,
            renderNextBtn: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 14),
              child: Text(context.l.introGeneralNext,
                  style: GoogleFonts.getFont(context.l.fontComfortaa,
                      color: Colors.white)),
            ),
            renderDoneBtn: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 14),
              child: Text(context.l.introGeneralDone,
                  style: GoogleFonts.getFont(context.l.fontComfortaa,
                      color: Colors.white)),
            ),
            onDonePress: () => SharikRouter.navigateTo(
                _globalKey, Screens.home, RouteDirection.right),
            slides: [
              Slide(
                styleTitle: GoogleFonts.getFont(
                  context.l.fontComfortaa,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
                styleDescription: GoogleFonts.getFont(context.l.fontAndika,
                    color: Colors.white, fontSize: 18.0),
                title: context.l.intro1ConnectTitle,
                description: context.l.intro1ConnectDescription,
                pathImage: 'assets/slides/1_connect.png',
                backgroundColor: Colors.purple.shade400,
              ),
              Slide(
                styleTitle: GoogleFonts.getFont(
                  context.l.fontComfortaa,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
                styleDescription: GoogleFonts.getFont(context.l.fontAndika,
                    color: Colors.white, fontSize: 18.0),
                title: context.l.intro2SendTitle,
                description: context.l.intro2SendDescription,
                pathImage: 'assets/slides/2_send.png',
                backgroundColor: Colors.indigo.shade400,
              ),
              Slide(
                styleTitle: GoogleFonts.getFont(
                  context.l.fontComfortaa,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
                styleDescription: GoogleFonts.getFont(context.l.fontAndika,
                    color: Colors.white, fontSize: 18.0),
                title: context.l.intro3ReceiveTitle,
                description: context.l.intro3ReceiveDescription,
                pathImage: 'assets/slides/3_receive.png',
                backgroundColor: Colors.teal.shade400,
              ),
              Slide(
                styleTitle: GoogleFonts.getFont(
                  context.l.fontComfortaa,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
                title: context.l.intro4EverywhereTitle,
                pathImage: 'assets/slides/4_everywhere.png',
                backgroundColor: Colors.blueGrey.shade400,
                widgetDescription: GestureDetector(
                  onTap: () async {
                    if (await canLaunch(
                        'https://github.com/marchellodev/sharik')) {
                      await launch('https://github.com/marchellodev/sharik');
                    }
                  },
                  child: Text(
                    context.l.intro4EverywhereDescription,
                    style: GoogleFonts.getFont(context.l.fontAndika,
                        color: Colors.white, fontSize: 18.0),
                    textAlign: TextAlign.center,
                    maxLines: 12,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
