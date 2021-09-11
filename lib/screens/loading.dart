import 'dart:io';
import 'dart:typed_data';

import 'package:ackee_dart/ackee_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:widget_to_image/widget_to_image.dart';

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
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    init();
  }

  Future<void> init() async {
    await Future.delayed(Duration.zero);

    try {
      Hive.registerAdapter(SharingObjectTypeAdapter());
      Hive.registerAdapter(SharingObjectAdapter());

      await Hive.initFlutter('sharik_storage');

      await Hive.openBox<String>('strings');
      await Hive.openBox<SharingObject>('history');

      context.read<LanguageManager>().init();
      context.read<ThemeManager>().init();

      _initAnalytics(context);

      LicenseRegistry.addLicense(() async* {
        final fonts = ['Andika', 'Comfortaa', 'JetBrains', 'Poppins'];

        for (final el in fonts) {
          final license =
              await rootBundle.loadString('google_fonts/$el/OFL.txt');
          yield LicenseEntryWithLineBreaks(['google_fonts'], license);
        }
      });

      try {
        if (Platform.isAndroid || Platform.isIOS) {
          final sharedFile = await ReceiveSharingIntent.getInitialMedia();
          final sharedText = await ReceiveSharingIntent.getInitialText();

          if (sharedFile.length > 1) {
            SharikRouter.navigateTo(
                _globalKey,
                Screens.error,
                RouteDirection.right,
                'Sorry, you can only share 1 file at a time');
            return;
          }

          if (sharedFile.isNotEmpty) {
            // todo apply dry
            final _file = SharingObject(
                type: SharingObjectType.file,
                data: sharedFile[0].path.replaceFirst('file://', ''),
                name: SharingObject.getSharingName(
                  SharingObjectType.file,
                  sharedFile[0].path.replaceFirst('file://', ''),
                ));

            final _history = Hive.box<SharingObject>('history').values.toList();
            _history.removeWhere((element) => element.name == _file.name);
            _history.insert(0, _file);
            await Hive.box<SharingObject>('history').clear();
            await Hive.box<SharingObject>('history').addAll(_history);

            SharikRouter.navigateTo(
                _globalKey, Screens.sharing, RouteDirection.right, _file);
            return;
          }

          if (sharedText != null) {
            final _file = SharingObject(
                type: SharingObjectType.text,
                data: sharedText,
                name: SharingObject.getSharingName(
                  SharingObjectType.text,
                  sharedText,
                ));

            final _history = Hive.box<SharingObject>('history').values.toList();
            _history.removeWhere((element) => element.name == _file.name);
            _history.insert(0, _file);
            await Hive.box<SharingObject>('history').clear();
            await Hive.box<SharingObject>('history').addAll(_history);

            SharikRouter.navigateTo(
              _globalKey,
              Screens.sharing,
              RouteDirection.right,
              _file,
            );
            return;
          }
        }
      } catch (e) {
        print('Error when trying to receive sharing intent: $e');
      }

      if (Platform.isAndroid || Platform.isIOS) {
        await _receivingIntentListener(_globalKey);
      }

      SharikRouter.navigateTo(
          _globalKey,
          Hive.box<String>('strings').containsKey('language')
              ? Screens.home
              : Screens.languagePicker,
          RouteDirection.right);
    } catch (error, trace) {
      SharikRouter.navigateTo(_globalKey, Screens.error, RouteDirection.right,
          '$error \n\n $trace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: Scaffold(
          backgroundColor: Colors.deepPurple.shade400,
          body: Center(
            child: SvgPicture.asset('assets/logo_inverse.svg',
                height: 60,
                semanticsLabel: 'Sharik app icon',
                color: Colors.grey.shade300),
          )),
    );
  }
}

Future<void> _receivingIntentListener(GlobalKey key) async {
  final byteData = Hive.box<String>('strings')
              .get('disable_transition_effects', defaultValue: '0') ==
          '1'
      ? Uint8List(0)
      : (await WidgetToImage.repaintBoundaryToImage(key)).buffer.asUint8List();

  final files = ReceiveSharingIntent.getMediaStream();
  final texts = ReceiveSharingIntent.getTextStream();

  files.listen((sharedFile) {
    if (sharedFile.length > 1) {
      SharikRouter.navigateToFromImage(byteData, Screens.error,
          RouteDirection.right, 'Sorry, you can only share 1 file at a time');
      return;
    }

    if (sharedFile.isNotEmpty) {
      SharikRouter.navigateToFromImage(
          byteData,
          Screens.sharing,
          RouteDirection.right,
          SharingObject(
              type: SharingObjectType.file,
              data: sharedFile[0].path.replaceFirst('file://', ''),
              name: SharingObject.getSharingName(
                SharingObjectType.file,
                sharedFile[0].path.replaceFirst('file://', ''),
              )));
    }
  });

  texts.listen((sharedText) {
    SharikRouter.navigateToFromImage(
        byteData,
        Screens.sharing,
        RouteDirection.right,
        SharingObject(
            type: SharingObjectType.text,
            data: sharedText,
            name: SharingObject.getSharingName(
              SharingObjectType.text,
              sharedText,
            )));
    return;
  });
}

void _initAnalytics(BuildContext context) {
  if (!kReleaseMode) {
    print('Analytics is disabled since running in the debug mode');
    return;
  }

  if (Hive.box<String>('strings').get('tracking', defaultValue: '1') != '1') {
    print('Analytics is disables by the user');
    return;
  }

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
      browserName: 'Sharik ${context.read<LanguageManager>().language.name}',
      browserVersion: currentVersion,
      deviceName: Platform.localHostname,
      deviceManufacturer: Platform.operatingSystem,
      language: Localizations.localeOf(context).languageCode,
    ),
  );
}
