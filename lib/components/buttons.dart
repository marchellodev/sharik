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
                              style: GoogleFonts.getFont(
                                  font ?? context.l.fontAndika,
                                  color: Colors.grey.shade100,
                                  fontSize: fontSize.toDouble()))),
                    ],
                  )
                : Center(
                    child: Text(text,
                        style: GoogleFonts.getFont(font ?? context.l.fontAndika,
                            color: Colors.grey.shade100,
                            fontSize: fontSize.toDouble())),
                  ),
          ),
        ));
  }
}

class TransparentTextButton extends StatelessWidget {
  final String text;
  final Function()? onClick;
  final bool monoFont;

  const TransparentTextButton(this.text, this.onClick, {this.monoFont = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        splashColor: context.t.accentColor.withOpacity(0.1),
        onTap: onClick,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          child: Text(
            text,
            style: monoFont
                ? TextStyle(
                    fontSize: 16,
                    color: Colors.deepPurple.shade200,
                    fontFamily: 'JetBrainsMono')
                : GoogleFonts.getFont(
                    context.l.fontAndika,
                    fontSize: 15,
                    color: onClick != null
                        ? context.t.dividerColor
                        : context.t.dividerColor.withOpacity(0.6),
                  ),
          ),
        ),
      ),
    );
  }
}
