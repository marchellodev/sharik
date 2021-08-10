import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:widget_to_image/widget_to_image.dart';

import '../conf.dart';
import '../main.dart';

class SharikRouter extends PageRouteBuilder {
  final Widget enterPage;
  final Widget exitPageImage;
  final RouteDirection direction;

  SharikRouter(
      {required this.exitPageImage,
      required this.enterPage,
      required this.direction})
      : super(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) =>
              enterPage,
          transitionsBuilder: (BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child) =>
              Stack(
            children: [
              SlideTransition(
                position: Tween<Offset>(
                  begin: direction == RouteDirection.right
                      ? const Offset(0.0, 0.0)
                      : Offset.zero,
                  end: direction == RouteDirection.right
                      ? const Offset(-1.0, 0.0)
                      : const Offset(1.0, 0.0),
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.fastOutSlowIn,
                )),
                child: exitPageImage,
                // child: SizedBox(
                //   width: double.infinity,
                //   height: double.infinity,
                // child: Scaffold(
                //   // body: Container(
                //   //   color: Colors.red,
                //   // ),
                //     body: SizedBox(
                //         width: double.infinity,
                //         height: double.infinity,
                //         child: Image.memory(
                //           exitPageImage.buffer.asUint8List(),
                //           errorBuilder: (a2, a3, a4) {
                //             print('123');
                //             return Text('er');
                //           },
                //           alignment: Alignment.center,
                //           // height: double.infinity,
                //           // width: double.infinity,
                //           fit: BoxFit.cover,
                //         ))
                //
                //
                // ),
                // ),
              ),
              SlideTransition(
                position: Tween<Offset>(
                  begin: direction == RouteDirection.right
                      ? const Offset(1.0, 0.0)
                      : const Offset(-1.0, 0.0),
                  end: direction == RouteDirection.right
                      ? Offset.zero
                      : const Offset(0.0, 0.0),
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.fastOutSlowIn,
                )),
                child: child,
              )
            ],
          ),
        );

  static Future<void> navigateTo(
      GlobalKey screenKey, Screens screen, RouteDirection direction,
      [Object? args]) async {
    final byteData = performanceMode
        ? ByteData(0)
        : await WidgetToImage.repaintBoundaryToImage(screenKey);
    navigateToFromImage(byteData.buffer.asUint8List(), screen, direction, args);
  }

  static Future<void> navigateToFromImage(
      Uint8List data, Screens screen, RouteDirection direction,
      [Object? args]) async {
    if (performanceMode) {
      navigatorKey.currentState!.pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => screen2widget(screen, args),
          transitionDuration: Duration.zero,
        ),
      );
    } else {
      navigatorKey.currentState!.pushReplacement(SharikRouter(
        exitPageImage: Image.memory(data),
        enterPage: screen2widget(screen, args),
        direction: direction,
      ));
    }
  }
}

enum RouteDirection { left, right }
