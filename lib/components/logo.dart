import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/helper.dart';

class SharikLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Material(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          SvgPicture.asset(
            'assets/logo.svg',
            semanticsLabel: 'Sharik app icon',
            color: context.t.cardColor,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            'Sharik',
            style:
                GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.w500),
          )
        ]),
      );
}
