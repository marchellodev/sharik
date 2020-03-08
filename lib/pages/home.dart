import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

import '../locale.dart';
import '../main.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  Callback back;

  HomePage(this.back);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> latest = [];

  @override
  void initState() {
    pref();
    super.initState();
  }

  void pref() async {
    setState(() {
      latest = Hive.box('app').get('latest', defaultValue: []);
      print(latest);
      print('setted');
    });
  }

  @override
  Widget build(BuildContext context) {
    print(latest);
    print('just was');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(left: 24, right: 24, top: 8),
            height: 110,
            child: Material(
              borderRadius: BorderRadius.circular(12),
              color: Color(0xFF7E57C2),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: <Widget>[
                    Center(
                        child: Text(L.get('Select file', locale),
                            style: GoogleFonts.andika(
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 24)))),
                    Container(
                      margin: EdgeInsets.all(16),
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: SvgPicture.asset(
                            'assets/icon_file.svg',
                          )),
                    )
                  ],
                ),
                onTap: () async {
                  File f = await FilePicker.getFile();
                  if (f != null) {
                    file = f.path;

                    if (file.length == 0) return;

                    setState(() {
                      if (latest.contains(file)) latest.remove(file);

                      latest.insert(0, file);
                    });

                    Hive.box('app').put('latest', latest);

                    widget.back('file');
                  }
                },
              ),
            )),

//        Container(
//            margin: EdgeInsets.only(left: 24, right: 24, top: 8),
//            height: 60,
//            child: Material(
//              borderRadius: BorderRadius.circular(12),
//              color: Color(0xFF7E57C2),
//              child: InkWell(
//                borderRadius: BorderRadius.circular(12),
//                child: Stack(
//                  children: <Widget>[
//                    Center(
//                        child: Text(L.get('Select file', locale),
//                            style: GoogleFonts.andika(
//                                textStyle: TextStyle(
//                                    color: Colors.white, fontSize: 24)))),
//                    Container(
//                      margin: EdgeInsets.all(16),
//                      child: Align(
//                          alignment: Alignment.bottomRight,
//                          child: SvgPicture.asset(
//                            'assets/icon_file.svg',
//                          )),
//                    )
//                  ],
//                ),
//                onTap: () async {
//                  File f = await FilePicker.getFile();
//                  if (f != null) {
//                    file = f.path;
//
//                    if (file.length == 0) return;
//
//                    setState(() {
//                      if (latest.contains(file)) latest.remove(file);
//
//                      latest.insert(0, file);
//                    });
//
//                    SharedPreferences prefs =
//                    await SharedPreferences.getInstance();
//                    await prefs.setStringList('latest', latest);
//
//                    widget.back('file');
//                  }
//                },
//              ),
//            )),

        SizedBox(
          height: 22,
        ),
        Container(
          margin: EdgeInsets.only(left: 24, right: 24),
          child: Text(
            L.get('Latest', locale),
            style: GoogleFonts.comfortaa(textStyle: TextStyle(fontSize: 24)),
          ),
        ),
        Expanded(
          child: Container(
              padding: EdgeInsets.only(left: 24, right: 24),
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 16),
                  itemCount: latest.length,
                  itemBuilder: (context, index) => card(latest[index]))),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 18),
          height: 54,
          decoration: BoxDecoration(
              color: Color(0xFFD1C4E9),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24))),
          child: Row(
            children: <Widget>[
              Material(
                color: Color(0xFFD1C4E9),
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  splashColor: Color(0xFF7E57C2),
                  child: Container(
                    margin: EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      'assets/icon_locale.svg',
                      semanticsLabel: 'locale',
                      height: 18,
                    ),
                  ),
                  onTap: () => widget.back('_locale'),
                ),
              ),
              SizedBox(
                width: 2,
              ),
              Material(
                color: Color(0xFFD1C4E9),
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  splashColor: Color(0xFF7E57C2),
                  child: Container(
                    margin: EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      'assets/icon_help.svg',
                      semanticsLabel: 'help',
                      height: 16,
                    ),
                  ),
                  onTap: () => widget.back('_help'),
                ),
              ),
              Spacer(),
              Material(
                color: Color(0xFFD1C4E9),
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  splashColor: Color(0xFF7E57C2),
                  child: Container(
                    margin: EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      'assets/icon_email.svg',
                      semanticsLabel: 'instagram',
                      height: 14,
                    ),
                  ),
                  onTap: () async {
                    if (await canLaunch('mailto:marchellodev@gmail.com'))
                      await launch('mailto:marchellodev@gmail.com');
                  },
                ),
              ),
              SizedBox(
                width: 2,
              ),
              Material(
                color: Color(0xFFD1C4E9),
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  splashColor: Color(0xFF7E57C2),
                  child: Container(
                    margin: EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      'assets/icon_instagram.svg',
                      semanticsLabel: 'instagram',
                      height: 18,
                    ),
                  ),
                  onTap: () async {
                    if (await canLaunch('https://instagram.com/marchellodev'))
                      await launch('https://instagram.com/marchellodev');
                  },
                ),
              ),
              SizedBox(
                width: 2,
              ),
              Container(
                color: Color(0xFF512DA8),
                height: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 12),
                width: 1,
              ),
              SizedBox(
                width: 2,
              ),
              Material(
                color: Color(0xFFD1C4E9),
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  splashColor: Color(0xFF7E57C2),
                  child: Container(
                    margin: EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      'assets/icon_github.svg',
                      semanticsLabel: 'play store',
                      height: 18,
                    ),
                  ),
                  onTap: () async {
                    if (await canLaunch(
                        'https://github.com/marchellodev/sharik'))
                      await launch('https://github.com/marchellodev/sharik');
                  },
                ),
              ),
              SizedBox(
                width: 2,
              ),
              Material(
                color: Color(0xFFD1C4E9),
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  splashColor: Color(0xFF7E57C2),
                  child: Container(
                    margin: EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      'assets/icon_store.svg',
                      semanticsLabel: 'play store',
                      height: 18,
                    ),
                  ),
                  onTap: () async {
                    if (await canLaunch(
                        'https://play.google.com/store/apps/details?id=dev.marchello.sharik'))
                      await launch(
                          'https://play.google.com/store/apps/details?id=dev.marchello.sharik');
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget card(String f) {
    //weird stuff goes here, but it works :D
    ScrollController controller = ScrollController();

    print('displaying card...');
    int n = 0;
    void set() {
      if (controller.positions.isNotEmpty) {
        controller.jumpTo(controller.position.maxScrollExtent);
        n++;
        print(n);
        if (n < 5) Timer(Duration(milliseconds: 100), () => set());
      } else
        Timer(Duration(milliseconds: 100), () => set());
    }

    print(latest);
    if (!Platform.isAndroid) set();

    return Container(
      height: 58,
      margin: EdgeInsets.only(bottom: 18),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xFF9575CD),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            file = f;

            if (f.length == 0) {
              latest.remove(file);
              return;
            }

            setState(() {
              if (latest.contains(file)) latest.remove(file);

              latest.insert(0, file);
            });

            Hive.box('app').put('latest', latest);

            widget.back('file');
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                SvgPicture.asset(
                  'assets/icon_folder2.svg',
                  semanticsLabel: 'file ',
                  width: 18,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                    child: SingleChildScrollView(
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    Platform.isAndroid ? f.split('/').last : f,
                    style: GoogleFonts.andika(
                      textStyle: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
