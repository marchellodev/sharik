import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:usage/usage_io.dart';

import 'models/app.dart';
import 'models/file.dart';
import 'models/locale.dart';
import 'models/page.dart';
import 'pages/home.dart';
import 'pages/intro.dart';
import 'pages/language.dart';
import 'pages/share.dart';

// todo move into provider / bloc
Analytics ga;

Future<void> main() async {
  try {
    Hive.registerAdapter(LocaleModelAdapter());
    Hive.registerAdapter(FileTypeModelAdapter());
    Hive.registerAdapter(FileModelAdapter());

    await Hive.initFlutter();
    await Hive.openBox('app2');

    ga = AnalyticsIO('UA-175911584-1', 'sharik', 'v2.5',
        documentDirectory: await getApplicationDocumentsDirectory());

    ga.sendEvent('pages', 'app_open');

    ga.sendEvent('app_open',
        'v2.5: ${Platform.operatingSystem} ${Platform.operatingSystemVersion}');

    runApp(MaterialApp(
      builder: (context, child) {
        return ResponsiveWrapper.builder(
            ScrollConfiguration(
              behavior: MyBehavior(),
              child: child,
            ),
            maxWidth: 1400,
            minWidth: 420,
            defaultScale: true,
            breakpoints: [
              const ResponsiveBreakpoint.resize(400, name: MOBILE),
              const ResponsiveBreakpoint.autoScale(800, name: TABLET),
              const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
            ]);
      },
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: App(),
      ),
    ));
  } catch (e) {
    print(e);
    runApp(const MaterialApp(
        home: Scaffold(
            body: Center(
      child: Text('Sharik is already running'),
    ))));
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> with TickerProviderStateMixin {
  TabController _pagerGlobal;
  TabController _pagerHome;

  @override
  Widget build(_) {
    return Provider<AppModel>(
      create: (_) => AppModel(_pagerGlobal, _pagerHome, setState),
      child: Builder(builder: (context) {
        final model = Provider.of<AppModel>(context, listen: false);
        return TabBarView(
            physics: const NeverScrollableScrollPhysics(),
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
              SafeArea(
                child: Column(
                  children: <Widget>[
                    Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 24, horizontal: 12),
                        child: SharikLogo()),
                    LanguagePage(),
                  ],
                ),
              ),
              IntroPage(),
              Column(
                children: <Widget>[
                  SafeArea(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 24, horizontal: 12),
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: <Widget>[
                          SharikLogo(),
                          if (model.getPage() == PageModel.sharing)
                            IconButton(
                                onPressed: () {
                                  setState(() => model.setPage(PageModel.home));

                                  _removeTemporaryDir();
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
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _pagerHome,
                          children: <Widget>[
                        Builder(
                          builder: (context) => HomePage(),
                        ),
                        WillPopScope(
                            onWillPop: () async {
                              if (model.getPage() == PageModel.sharing) {
                                setState(() => model.setPage(PageModel.home));
                                _removeTemporaryDir();
                              }
                              return false;
                            },
                            child: SharePage()),
                      ]))
                ],
              )
            ]);
      }),
    );
  }

  @override
  void initState() {
    _pagerGlobal = TabController(vsync: this, length: 4);
    _pagerHome = TabController(vsync: this, length: 2);

    if (Platform.isAndroid) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    super.initState();
  }

  void _removeTemporaryDir() {
    if (Platform.isAndroid) {
      getTemporaryDirectory().then((dir) {
        dir.exists().then((exists) {
          try {
            dir.delete(recursive: true);
          } catch (e) {
            print(e);
          }
        });
      });
    }
  }
}

class SharikLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        SvgPicture.asset('assets/logo.svg', semanticsLabel: 'Sharik app icon'),
        const SizedBox(
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
