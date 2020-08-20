import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../locale.dart';
import '../models/app.dart';
import '../models/page.dart';

class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AppModel>(context, listen: false);

    return IntroSlider(
      nameDoneBtn: L('DONE', model.localeAdapter),
      nameNextBtn: L('NEXT', model.localeAdapter),
      isShowSkipBtn: false,
      styleNameDoneBtn: GoogleFonts.getFont(L('Comfortaa', model.localeAdapter),
          color: Colors.white),
      styleNamePrevBtn: GoogleFonts.getFont(L('Comfortaa', model.localeAdapter),
          color: Colors.white),
      colorDot: Colors.white70,
      colorActiveDot: Colors.white,
      slides: <Slide>[
        Slide(
          styleTitle: GoogleFonts.getFont(
            L('Comfortaa', model.localeAdapter),
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ),
          styleDescription: GoogleFonts.getFont(
              L('Andika', model.localeAdapter),
              color: Colors.white,
              fontSize: 18.0),
          title: L('CONNECT', model.localeAdapter),
          description: L(
              'Connect devices to the same network - use Wi-Fi or Mobile Hotspot',
              model.localeAdapter),
          pathImage: 'assets/slide_1.png',
          backgroundColor: Colors.purple[400],
        ),
        Slide(
          styleTitle: GoogleFonts.getFont(
            L('Comfortaa', model.localeAdapter),
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ),
          styleDescription: GoogleFonts.getFont(
              L('Andika', model.localeAdapter),
              color: Colors.white,
              fontSize: 18.0),
          title: L('SEND', model.localeAdapter),
          description: L('Select any file you like', model.localeAdapter),
          pathImage: 'assets/slide_2.png',
          backgroundColor: Colors.indigo[400],
        ),
        Slide(
          styleTitle: GoogleFonts.getFont(
            L('Comfortaa', model.localeAdapter),
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ),
          styleDescription: GoogleFonts.getFont(
              L('Andika', model.localeAdapter),
              color: Colors.white,
              fontSize: 18.0),
          title: L('RECEIVE', model.localeAdapter),
          description: L('Open given link on another device in any browser',
              model.localeAdapter),
          pathImage: 'assets/slide_3.png',
          backgroundColor: Colors.teal[400],
        ),
        Slide(
          styleTitle: GoogleFonts.getFont(
            L('Comfortaa', model.localeAdapter),
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ),
          title: L('EVERYWHERE', model.localeAdapter),
          pathImage: 'assets/slide_4.png',
          backgroundColor: Colors.blueGrey[400],
          widgetDescription: GestureDetector(
            onTap: () async {
              if (await canLaunch('https://github.com/marchellodev/sharik')) {
                await launch('https://github.com/marchellodev/sharik');
              }
            },
            child: Text(
              '${L('Sharik is available for Android, Windows, MacOS and Linux!', model.localeAdapter)}\n${L('Click here to learn more', model.localeAdapter)}',
              style: GoogleFonts.getFont(L('Andika', model.localeAdapter),
                  color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
      onDonePress: () => model.setPage(PageModel.home),
    );
  }
}
