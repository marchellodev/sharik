import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.deepPurple[500],
      child: Center(
        child: SvgPicture.asset('assets/logo_inverse.svg',
            height: 64, semanticsLabel: 'app icon'),
      ),
    );
  }
}
