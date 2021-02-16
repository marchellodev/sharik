import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sharik/screens/about.dart';

import 'components/logo.dart';
import 'logic/navigation.dart';

class AppWrapper extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppWrapperState();
}

class AppWrapperState extends State<AppWrapper> with TickerProviderStateMixin {
  TabController _pagerGlobal;
  TabController _pagerHome;
  bool showBackButton = false;

  @override
  void initState() {
    _pagerGlobal = TabController(vsync: this, length: 4, initialIndex: 1);
    _pagerHome = TabController(vsync: this, length: 3);

    if (Platform.isAndroid) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    context.read<NavigationManager>().onChange = (NPage p) {
      print('changing page...: $p');
      switch (p.runtimeType) {
        case LoadingPage:
          _pagerHome.animateTo(0);
          _pagerGlobal.animateTo(0);

          break;
        case LanguagePage:
          _pagerHome.animateTo(0);
          _pagerGlobal.animateTo(1);
          break;
        case IntroPage:
          _pagerHome.animateTo(0);
          _pagerGlobal.animateTo(2);
          break;
        case HomePage:
          _pagerHome.animateTo(0);
          _pagerGlobal.animateTo(3);
          setState(() {
            showBackButton = false;
          });
          break;
        case SharingPage:
          _pagerHome.animateTo(1);
          _pagerGlobal.animateTo(3);
          setState(() {
            showBackButton = true;
          });
          break;
        case AboutPage:
          _pagerHome.animateTo(2);
          _pagerGlobal.animateTo(3);
          setState(() {
            showBackButton = true;
          });
          break;
      }
    };

    super.initState();
  }

  @override
  Widget build(_) {
    return TabBarView(physics: const NeverScrollableScrollPhysics(), controller: _pagerGlobal, children: [
      // todo loading page goes here
      LoadingPage().widget,

      LanguagePage().widget,

      IntroPage().widget,
      Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: <Widget>[
                  SharikLogo(),
                  // todo consider using context.select
                  // Consumer<NavigationManager>(builder: (BuildContext context, NavigationManager model, child) {
                  //
                  // },)
                  if (showBackButton)
                    IconButton(
                        onPressed: () {
                          setState(() => context.read<NavigationManager>().page = HomePage());

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
                  physics: showBackButton ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
                  controller: _pagerHome,
                  children: <Widget>[
                Builder(
                  builder: (context) => HomePage().widget,
                ),
                WillPopScope(
                    onWillPop: () async {
                      if (showBackButton) {
                        // todo use shortcut for that
                        setState(() => context.read<NavigationManager>().page = HomePage());
                        _removeTemporaryDir();
                      }
                      return false;
                    },
                    child: SharingPage().widget),
                 AboutScreen()
              ]))
        ],
      )
    ]);
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
