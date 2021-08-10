import 'dart:ui';

import 'package:flutter/material.dart';
import '../conf.dart';

import '../logic/sharing_object.dart';

// todo not only file model but generic interface
Future<SharingObject?> openDialog(BuildContext context, Widget dialog) {
  return performanceMode
      ? showDialog(context: context, builder: (_) => dialog)
      : showGeneralDialog<SharingObject?>(
          context: context,
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
