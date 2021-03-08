import 'package:flutter/material.dart';

import '../conf.dart';

class SharikRouter extends PageRouteBuilder {
  final Widget enterPage;
  final Widget exitPage;
  final RouteDirection direction;

  SharikRouter(
      {required this.exitPage,
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
                child: exitPage,
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

  static void navigateTo(BuildContext context, Widget screenFrom,
      Screens screen, RouteDirection direction,
      [Object? args]) {
    Navigator.pushReplacement(
        context,
        SharikRouter(
          exitPage: screenFrom,
          enterPage: screen2widget(screen, args),
          direction: direction,
        ));
  }
}

enum RouteDirection { left, right }
