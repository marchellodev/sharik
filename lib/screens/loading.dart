import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sharik/logic/theme.dart';

import '../components/page_router.dart';
import '../conf.dart';
import '../logic/language.dart';
import '../logic/sharing_object.dart';

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
