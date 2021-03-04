import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SharikLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        SvgPicture.asset('assets/logo.svg', semanticsLabel: 'Sharik app icon'),
        const SizedBox(
          width: 10,
        ),
        Text(
          'Sharik',
          style: GoogleFonts.poppins(
              fontSize: 36,
              fontWeight: FontWeight.w500,
              color: Colors.grey[900]),
        )
      ]);
}
