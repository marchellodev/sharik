import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sharik/components/page_router.dart';

import '../conf.dart';
import '../utils/helper.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      SharikRouter.navigateTo(context, build(context), Screens.languagePicker);
    }
    // context.did
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: context.t.brightness == Brightness.light
          ? Colors.deepPurple.shade500
          : context.t.scaffoldBackgroundColor,
      body: Center(
        child: SvgPicture.asset('assets/logo_inverse.svg',
            height: 60,
            semanticsLabel: 'Sharik app icon',
            color: Colors.grey.shade200),
      ));
}
