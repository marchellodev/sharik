import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'pages/home.dart';
import 'pages/intro.dart';
import 'pages/language.dart';
import 'pages/share.dart';
import 'dart:io' show Platform;
import 'package:hive_flutter/hive_flutter.dart';

typedef Callback = void Function(String data);

String locale = 'en';
String file;

Future<void> main() async {
  if (Platform.isAndroid)
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xFF673AB7), // navigation bar color
    ));

  await Hive.initFlutter();
  await Hive.openBox('app');

  getTemporaryDirectory().then((value) => value.deleteSync(recursive: true));

  runApp(App());
}

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> with TickerProviderStateMixin {
  TabController pager;
  TabController pagerGlobal;
  bool back = false;

  void lang() async {
    String _locale = Hive.box('app').get('locale', defaultValue: null);

    await Future.delayed(const Duration(seconds: 1), () {});

    if (_locale != null) {
      locale = _locale;
      pagerGlobal.animateTo(3);
    } else
      pagerGlobal.animateTo(1);
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid)
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: pagerGlobal,
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Color(0xFF673AB7),
                child: Center(
                  child: SvgPicture.asset('assets/logo_inverse.svg',
                      height: 64, semanticsLabel: 'app icon'),
                ),
              ),
              Column(
                children: <Widget>[
                  SafeArea(
                    child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                        child: logo()),
                  ),
                  LanguagePage((lang) async {
                    pagerGlobal.animateTo(2);
                    locale = lang;
                    Hive.box('app').put('locale', locale);
                  }),
                ],
              ),
              IntroPage(() {
                pagerGlobal.animateTo(3);
              }),
              Column(
                children: <Widget>[
                  SafeArea(
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: <Widget>[
                          logo(),
                          back
                              ? IconButton(
//                                  tooltip: "back",
                                  onPressed: () {
                                    setState(() {
                                      back = false;
                                    });
                                    pager.animateTo(0);

                                    getTemporaryDirectory().then((value) => value.deleteSync(recursive: true));
                                  },
                                  icon: SvgPicture.asset(
                                    'assets/icon_back.svg',
                                    width: 18,
                                  ))
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: pager,
                          children: <Widget>[
                        HomePage((e) {
                          if (e == '_help') {
                            pagerGlobal.animateTo(2);
                          } else if (e == '_locale') {
                            pagerGlobal.animateTo(1);
                          } else {
                            setState(() {
                              back = true;
                            });

                            pager.animateTo(1);
                          }
                        }),
                        WillPopScope(onWillPop: _onWillPop, child: SharePage())
                      ]))
                ],
              )
            ]),
      ),
    );
  }

  // ignore: missing_return
  Future<bool> _onWillPop() {
    setState(() {
      back = false;
    });
    pager.animateTo(0);

    getTemporaryDirectory().then((value) => value.deleteSync(recursive: true));
  }

  Widget logo() => Material(
        type: MaterialType.transparency,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset('assets/logo.svg', semanticsLabel: 'app icon'),
            SizedBox(
              width: 8,
            ),
            Text(
              "Sharik",
              style: GoogleFonts.poppins(
                  fontSize: 36, fontWeight: FontWeight.w500),
            )
          ],
        ),
      );

  @override
  void initState() {
    pager = TabController(initialIndex: 0, vsync: this, length: 2);
    pagerGlobal = TabController(initialIndex: 0, vsync: this, length: 4);
    lang();
    super.initState();
  }
}
