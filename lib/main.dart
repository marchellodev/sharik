import 'dart:io';

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
import 'package:usage/usage_io.dart';
import 'package:window_size/window_size.dart' as screen;

import 'conf.dart';
import 'logic/language.dart';
import 'logic/navigation.dart';
import 'models/file.dart';
import 'wrapper.dart';

// todo move into provider / bloc
// todo accessibility
// todo make sure /screens/languages.dart not package:sharik/

Future<void> main() async {
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    WidgetsFlutterBinding.ensureInitialized();

    screen.setWindowMinSize(const Size(440, 680));
    screen.setWindowMaxSize(const Size(440, 680));
  }

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

  // todo improve analytics
  // _initAnalytics();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LanguageManager()),
      Provider(create: (_) => NavigationManager()),
    ],
    child: SharikApp(),
  ));
}

class SharikApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (_, child) {
        return ResponsiveWrapper.builder(
            ScrollConfiguration(
              behavior: BouncingScrollBehavior(),
              child: child,
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
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: AppWrapper(),
      ),
    );
  }
}

Future<void> _initAnalytics() async {
  Analytics ga;
  if (Platform.isAndroid || Platform.isIOS) {
    ga = AnalyticsIO('UA-175911584-1', 'sharik', 'v2.5', documentDirectory: await getApplicationDocumentsDirectory());
  } else {
    File('storage/.sharik').create(recursive: true);

    ga = AnalyticsIO('UA-175911584-1', 'sharik', 'v2.5', documentDirectory: Directory('storage'));
  }

  ga.sendEvent('pages', 'app_open');
  ga.sendEvent('app_open', 'v2.5: ${Platform.operatingSystem} ${Platform.operatingSystemVersion}');
}
