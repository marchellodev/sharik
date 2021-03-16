import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/helper.dart';

class PrimaryButton extends StatelessWidget {
  final Function() onClick;
  final String text;
  final int height;
  final int fontSize;
  final int roundedRadius;

  final Widget? secondaryIcon;
  final String? font;

  const PrimaryButton({
    required this.onClick,
    required this.text,
    required this.height,
    this.secondaryIcon,
    this.font,
    this.fontSize = 24,
    this.roundedRadius = 12,
  });

  // todo reevaluate hover and splash colors
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height.toDouble(),
        child: Material(
          borderRadius: BorderRadius.circular(roundedRadius.toDouble()),
          color: Colors.deepPurple.shade400,
          child: InkWell(
            splashColor: Colors.deepPurple.shade300.withOpacity(0.4),
            hoverColor: Colors.deepPurple.shade200.withOpacity(0.12),
            highlightColor: Colors.transparent,
            focusColor: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(roundedRadius.toDouble()),
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
                        style: font != 'JetBrainsMono'
                            ? GoogleFonts.getFont(font ?? context.l.fontAndika,
                                color: Colors.grey.shade100,
                                fontSize: fontSize.toDouble())
                            : TextStyle(
                                fontFamily: 'JetBrainsMono',
                                fontSize: 16,
                                color: Colors.grey.shade100)),
                  ),
          ),
        ));
  }
}

class DialogTextButton extends StatelessWidget {
  final String text;
  final Function()? onClick;

  const DialogTextButton(this.text, this.onClick);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        splashColor: context.t.dividerColor.withOpacity(0.04),
        hoverColor: context.t.dividerColor.withOpacity(0.04),
        highlightColor: Colors.transparent,
        focusColor: Colors.white.withOpacity(0.2),
        onTap: onClick,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          child: Text(
            text,
            style: GoogleFonts.getFont(
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
