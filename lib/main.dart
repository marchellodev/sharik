import 'dart:io';

import 'package:androidish_ink_well/material_ink_splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:sharik/logic/theme.dart';
import 'package:sharik/screens/loading.dart';

import 'conf.dart';
import 'logic/language.dart';
import 'logic/navigation.dart';
import 'models/file.dart';

// todo move into provider / bloc
// todo accessibility
// todo make sure /screens/languages.dart not package:sharik/
// todo review language namings
// todo custom ripple effect

Future<void> main() async {
  // if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
  //   WidgetsFlutterBinding.ensureInitialized();
  //
  //   screen.setWindowMinSize(const Size(440, 680));
  //   screen.setWindowMaxSize(const Size(440, 680));
  // }

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
      child: Text('Sharik is already running. Error copied to clipboard'),
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
      builder: (_, child) {
        return ResponsiveWrapper.builder(
            ScrollConfiguration(
              behavior: BouncingScrollBehavior(),
              child: child!,
            ),
            maxWidth: 1800,
            minWidth: 420,
            defaultScale: true,
            breakpoints: [
              const ResponsiveBreakpoint.resize(400, name: MOBILE),
              const ResponsiveBreakpoint.autoScale(680, name: TABLET),
              const ResponsiveBreakpoint.autoScale(1100, name: DESKTOP),
            ]);
      },
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
