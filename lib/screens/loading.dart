import 'dart:io';

import 'package:ackee_dart/ackee_dart.dart';
import 'package:ackee_dart/attrs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import '../components/page_router.dart';
import '../conf.dart';
import '../logic/language.dart';
import '../logic/sharing_object.dart';
import '../logic/theme.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();

    init();
  }

  Future<void> init() async {
    await Future.delayed(Duration.zero);

    if (context.read<LanguageManager>().initialized ||
        context.read<ThemeManager>().initialized) {
      return;
    }

    try {
      Hive.registerAdapter(SharingObjectTypeAdapter());
      Hive.registerAdapter(SharingObjectAdapter());

      await Hive.initFlutter();

      await Hive.openBox<String>('strings');
      await Hive.openBox<SharingObject>('history');

      context.read<LanguageManager>().init();
      context.read<ThemeManager>().init();

      _initAnalytics(context);

      if (Platform.isAndroid || Platform.isIOS) {
        final sharedData = await ReceiveSharingIntent.getInitialMedia();

        if (sharedData.length > 1) {
          SharikRouter.navigateTo(
              context,
              build(context),
              Screens.error,
              RouteDirection.right,
              'Sorry, you can only share 1 file at a time');
          return;
        }

        if (sharedData.length == 1) {
          SharikRouter.navigateTo(
              context,
              build(context),
              Screens.sharing,
              RouteDirection.right,
              SharingObject(
                  type: SharingObjectType.file,
                  data: sharedData[0].path,
                  name: SharingObject.getSharingName(
                    SharingObjectType.file,
                    sharedData[0].path,
                  )));
          return;
        }
      }

      SharikRouter.navigateTo(
          context,
          build(context),
          Hive.box<String>('strings').containsKey('language')
              ? Screens.home
              : Screens.languagePicker,
          RouteDirection.right);
    } catch (error, trace) {
      SharikRouter.navigateTo(context, build(context), Screens.error,
          RouteDirection.right, '$error \n\n $trace');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.deepPurple.shade400,
      body: Center(
        child: SvgPicture.asset('assets/logo_inverse.svg',
            height: 60,
            semanticsLabel: 'Sharik app icon',
            color: Colors.grey.shade300),
      ));
}

Future<void> _initAnalytics(BuildContext context) async {
  // todo check if debug
  // if()

// Hive.box<String>('strings').get('language', defaultValue: null);
  startAckee(
    Uri.parse('https://ackee.mark.vin/api'),
    '0a143aeb-7105-449f-a2be-ed03b5674e96',
    Attributes(
      location: 'https://sharik.app',
      osName: Platform.operatingSystem,
      osVersion: Platform.operatingSystemVersion,
      referrer: source2url(source),
      screenWidth: MediaQuery.of(context).size.width,
      screenHeight: MediaQuery.of(context).size.height,
      browserWidth: MediaQuery.of(context).size.width,
      browserHeight: MediaQuery.of(context).size.height,
      browserName:
          'Sharik ${context.read<LanguageManager>().language.name} $currentVersion',
      browserVersion: currentVersion,
      deviceName: Platform.localHostname,
      deviceManufacturer: Platform.operatingSystem,
      language: Localizations.localeOf(context).languageCode,
    ),
  );

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
