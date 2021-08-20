import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../logic/sharing_object.dart';

// todo not only file model but generic interface
Future<SharingObject?> openDialog(BuildContext context, Widget dialog,
    {bool dismissible = true}) {
  return Hive.box<String>('strings').get('disable_blur', defaultValue: '0') ==
          '1'
      ? showDialog(
          context: context,
          barrierDismissible: dismissible,
          barrierLabel: 'Close',
          builder: (_) => dialog)
      : showGeneralDialog<SharingObject?>(
          context: context,
          barrierDismissible: dismissible,
          barrierLabel: 'Close',
          transitionDuration: const Duration(milliseconds: 180),
          transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 2 * anim1.value, sigmaY: 2 * anim1.value),
                child: FadeTransition(
                  opacity: anim1,
                  child: SafeArea(child: child),
                ),
              ),
          pageBuilder: (_, __, ___) => dialog);
}
