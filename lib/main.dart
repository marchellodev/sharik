import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:sharik/logic/theme.dart';
import 'package:sharik/screens/loading.dart';
import 'package:sharik/utils/material_ink_well.dart';

import 'conf.dart';
import 'logic/language.dart';
import 'logic/navigation.dart';
import 'models/file.dart';

// todo before migrating locales:
// - design review (colors, spacing, animations, etc)
// - landscape mode support
// - calibrating responsive framework
// - accessibility
// - create sharing intent (android, ios, maybe desktop?)
// - code cleanup & to-do review
// - review imports (cupertino, material, etc -> use only foundation or widgets)
// - cleanup assets & fonts

Future<void> main() async {
  Hive.registerAdapter(FileTypeModelAdapter());
  Hive.registerAdapter(FileModelAdapter());

  try {
    if (Platform.isAndroid || Platform.isIOS) {
      await Hive.initFlutter();
    } else {
      Hive.init('storage');
    }
  } on Exception catch (_, e) {
    print(e);

    Clipboard.setData(ClipboardData(text: e.toString()));

    runApp(const MaterialApp(
        home: Scaffold(
            body: Center(
      child:
          Text('Sharik is already running. Error was copied to the clipboard'),
    ))));
    return;
  }

  await Hive.openBox<String>('strings');
  await Hive.openBox<FileModel>('history');

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LanguageManager()),
      ChangeNotifierProvider(create: (_) => ThemeManager()),
      Provider(create: (_) => NavigationManager()),
    ],
    child: SharikApp(),
  ));
}

class SharikApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        // todo https://github.com/Codelessly/ResponsiveFramework/issues/38
        print('${MediaQuery.of(context).orientation} !!!!!!!!!!');
        const portraitBrakepoints = [
          ResponsiveBreakpoint.resize(480, name: MOBILE),
          ResponsiveBreakpoint.resize(520, name: MOBILE, scaleFactor: 1.4),
          ResponsiveBreakpoint.resize(600, name: TABLET, scaleFactor: 1.2),
          ResponsiveBreakpoint.autoScale(800, name: TABLET, scaleFactor: 1.4),
          ResponsiveBreakpoint.resize(1000, name: DESKTOP, scaleFactor: 1.8),
          ResponsiveBreakpoint.autoScale(2460, name: '4K', scaleFactor: 2.2),
        ];

        const landscapeBrakepoints = [
          ResponsiveBreakpoint.resize(480, name: MOBILE, scaleFactor: 0.6),
          ResponsiveBreakpoint.resize(520, name: MOBILE, scaleFactor: 0.6),
          ResponsiveBreakpoint.resize(600, name: TABLET, scaleFactor: 0.8),
          ResponsiveBreakpoint.autoScale(800, name: TABLET, scaleFactor: 0.8),
          ResponsiveBreakpoint.resize(1000, name: DESKTOP, scaleFactor: 1.1),
          ResponsiveBreakpoint.autoScale(1200, name: DESKTOP, scaleFactor: 1.1),
          ResponsiveBreakpoint.autoScale(2460, name: '4K', scaleFactor: 1.7),
        ];

        return Container(
          key: UniqueKey(),
          child: ResponsiveWrapper.builder(
              ScrollConfiguration(
                behavior: BouncingScrollBehavior(),
                child: child!,
              ),

              minWidth: 480,
              defaultScale: true,
              breakpoints:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? portraitBrakepoints
                      : landscapeBrakepoints),
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
