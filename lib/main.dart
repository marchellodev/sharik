import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'pages/home.dart';
import 'pages/intro.dart';
import 'pages/language.dart';
import 'pages/share.dart';

String locale = 'en';
List<dynamic> file = [];

Box latestBox;

void main() async {
  //todo: if app is already open (lock file)
  try {
    await Hive.initFlutter();
    await Hive.openBox('app');
    latestBox = await Hive.openBox('latest');

    runApp(App());
  } catch (e) {
    //todo: make this screen more interesting
    runApp(MaterialApp(
        home: Scaffold(
            body: Center(
      child: Text('Sharik is already running'),
    ))));
  }
}

void removeTemporaryDir() {
  getTemporaryDirectory().then((dir) {
    dir.exists().then((exists) {
      try {
        dir.delete(recursive: true);
      } catch (e) {}
    });
  });
}

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> with TickerProviderStateMixin {
  TabController _homePager;
  TabController _pagerGlobal;

  void lang() async {
    String _locale = Hive.box('app').get('locale', defaultValue: null);

    if (_locale != null) {
      locale = _locale;
      _setPage(Page.home);
    } else
      _setPage(Page.language);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _pagerGlobal,
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.deepPurple[500],
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
                        child: SharikLogo()),
                  ),
                  LanguagePage((lang) async {
                    _setPage(Page.intro);
                    locale = lang;
                    Hive.box('app').put('locale', locale);
                  }),
                ],
              ),
              IntroPage(() => _setPage(Page.home)),
              Column(
                children: <Widget>[
                  SafeArea(
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: <Widget>[
                          SharikLogo(),
                          if (_getPage() == Page.sharing)
                            IconButton(
                                onPressed: () {
                                  setState(() => _setPage(Page.home));

                                  removeTemporaryDir();
                                },
                                icon: SvgPicture.asset(
                                  'assets/icon_back.svg',
                                  width: 18,
                                ))
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: _homePager,
                          children: <Widget>[
                        HomePage((e) {
                          if (e == '_help') {
                            _setPage(Page.intro);
                          } else if (e == '_locale') {
                            _setPage(Page.language);
                          } else {
                            setState(() => _setPage(Page.sharing));
                          }
                        }),
                        WillPopScope(
                            onWillPop: () async {
                              await Future.delayed(Duration.zero);

                              if (_getPage() == Page.sharing) {
                                setState(() => _setPage(Page.home));
                                removeTemporaryDir();
                              }
                              return false;
                            },
                            child: SharePage())
                      ]))
                ],
              )
            ]),
      ),
    );
  }

  @override
  void initState() {
    _homePager = TabController(initialIndex: 0, vsync: this, length: 2);
    _pagerGlobal = TabController(initialIndex: 0, vsync: this, length: 4);
    lang();

    if (Platform.isAndroid)
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

    super.initState();
  }

  void _setPage(Page page) {
    switch (page) {
      case Page.loading:
        _homePager.animateTo(0);
        _pagerGlobal.animateTo(0);
        break;
      case Page.language:
        _homePager.animateTo(0);
        _pagerGlobal.animateTo(1);
        break;
      case Page.intro:
        _homePager.animateTo(0);
        _pagerGlobal.animateTo(2);
        break;
      case Page.home:
        _homePager.animateTo(0);
        _pagerGlobal.animateTo(3);
        break;
      case Page.sharing:
        _pagerGlobal.animateTo(3);
        _homePager.animateTo(1);
        break;
    }
  }

  Page _getPage() {
    var home = _homePager.index;
    var global = _pagerGlobal.index;

    if (home == 0) {
      switch (global) {
        case 0:
          return Page.loading;
        case 1:
          return Page.language;
        case 2:
          return Page.intro;
        case 3:
          return Page.home;
      }
    } else if (global == 3)
      return Page.sharing;
    else
      throw Exception('Wrong page or something');
    return null;
  }
}

enum Page { loading, language, intro, home, sharing }

class SharikLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        SvgPicture.asset('assets/logo.svg', semanticsLabel: 'Sharik app icon'),
        SizedBox(
          width: 10,
        ),
        Text(
          'Sharik',
          style: GoogleFonts.poppins(
              fontSize: 36,
              fontWeight: FontWeight.w500,
              color: Colors.grey[900]),
        )
      ]);
}
