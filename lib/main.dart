import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import 'conf.dart';
import 'logic/language.dart';
import 'logic/theme.dart';
import 'screens/loading.dart';
import 'utils/material_ink_well.dart';

// todo before migrating locales:
// - design review (colors, spacing, animations, etc)
// - landscape mode support (home & about & sharing)
// - calibrating responsive framework
// - accessibility
// - create sharing intent (android, ios, maybe desktop?)
// - code cleanup & to-do review
// - review imports (cupertino, material, etc -> use only foundation or widgets)
// - cleanup assets & fonts
// - check fonts for usage
// - font licenses
// - get rid of all prints
// - add an icon to the android notifications bar

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LanguageManager()),
      ChangeNotifierProvider(create: (_) => ThemeManager()),
    ],
    child: SharikApp(),
  ));
}

class SharikApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, builder: (context, child) {
        // todo https://github.com/Codelessly/ResponsiveFramework/issues/38

        return Container(
          // key: UniqueKey(),
          child: ResponsiveWrapper.builder(
            ScrollConfiguration(
              behavior: BouncingScrollBehavior(),
              child: child!,
            ),

            minWidth: 480,
            defaultScale: true,
            // breakpoints:
            //     MediaQuery.of(context).orientation == Orientation.portrait
            //         ? portraitBrakepoints
            //         : landscapeBrakepoints
          ),
        );
      },
      // builder: DevicePreview.appBuilder, //
      locale: context.watch<LanguageManager>().language.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: languageList.map((e) => e.locale),
      title: 'Sharik',
      theme: ThemeData(
          splashFactory: MaterialInkSplash.splashFactory,
          brightness: Brightness.light,
          inputDecorationTheme: InputDecorationTheme(
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.grey.shade900.withOpacity(0.8), width: 2))),
          textSelectionTheme: TextSelectionThemeData(
              cursorColor: Colors.grey.shade600,
              selectionHandleColor: Colors.grey.shade200.withOpacity(0.9),
              selectionColor: Colors.deepPurple.shade100.withOpacity(0.6)),

          // sharik top icon color
          accentColor: Colors.deepPurple.shade500,

          // primarySwatch: Colors.deepPurple,

          // right click selection color
          cardColor: Colors.grey.shade200.withOpacity(0.9),

          // color of the button on the default background
          dividerColor: Colors.deepPurple.shade400,

          // about card color
          buttonColor: Colors.deepPurple.shade50.withOpacity(0.6)),
      darkTheme: ThemeData(
        splashFactory: MaterialInkSplash.splashFactory,

        brightness: Brightness.dark,
        inputDecorationTheme: InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.deepPurple.shade50.withOpacity(0.8),
                    width: 2))),

        // primarySwatch: Colors.grey,

        textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.deepPurple.shade50,
            selectionHandleColor: Colors.deepPurple.shade300.withOpacity(0.9),
            selectionColor: Colors.deepPurple.shade50.withOpacity(0.4)),

        // sharik top icon color
        accentColor: Colors.deepPurple.shade300,

        // right click selection color
        cardColor: Colors.deepPurple.shade400.withOpacity(0.9),

        // color of the button on the default background
        dividerColor: Colors.deepPurple.shade50,

        // about card color
        buttonColor: Colors.deepPurple.shade100.withOpacity(0.8),
      ),
      themeMode: context.watch<ThemeManager>().theme,
      home: LoadingScreen(),
    );
  }
}

Future<void> _initAnalytics() async {
  // Analytics ga;
  // if (Platform.isAndroid || Platform.isIOS) {
  //   ga = AnalyticsIO('UA-175911584-1', 'sharik', 'v2.5', documentDirectory: await getApplicationDocumentsDirectory());
  // } else {
  //   File('storage/.sharik').create(recursive: true);
  //
  //   ga = AnalyticsIO('UA-175911584-1', 'sharik', 'v2.5', documentDirectory: Directory('storage'));
  // }
  //
  // ga.sendEvent('pages', 'app_open');
  // ga.sendEvent('app_open', 'v2.5: ${Platform.operatingSystem} ${Platform.operatingSystemVersion}');
}
