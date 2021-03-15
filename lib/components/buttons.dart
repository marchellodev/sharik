import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/helper.dart';

class PrimaryButton extends StatelessWidget {
  final Function() onClick;
  final String text;
  final int height;
  final int fontSize;

  final Widget? secondaryIcon;
  final String? font;

  const PrimaryButton(
      {required this.onClick,
      required this.text,
      required this.height,
      this.secondaryIcon,
      this.font,
      this.fontSize = 24});

  // todo reevaluate hover and splash colors
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height.toDouble(),
        child: Material(
          borderRadius: BorderRadius.circular(12),
          color: Colors.deepPurple.shade400,
          child: InkWell(
            splashColor: Colors.deepPurple.shade200.withOpacity(0.3),
            hoverColor: Colors.deepPurple.shade200.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            onTap: onClick,
            child: secondaryIcon != null
                ? Stack(
                    children: [
                      Align(
                        alignment: const Alignment(0.9, 0.0),
                        child: secondaryIcon,
                      ),
                      Center(
                          child: Text(text,
                              style: GoogleFonts.getFont(font ?? context.l.fontAndika,
                                  color: Colors.grey.shade100, fontSize: fontSize.toDouble()))),
                    ],
                  )
                : Center(
                    child: Text(text,
                        style: GoogleFonts.getFont(font ?? context.l.fontAndika,
                            color: Colors.grey.shade100, fontSize: fontSize.toDouble())),
                  ),
          ),
        ));
  }
}

