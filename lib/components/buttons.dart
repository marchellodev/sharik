import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/helper.dart';

class PrimaryButton extends StatelessWidget {
  final Function()? onClick;
  final String text;
  final int height;
  final int fontSize;
  final int roundedRadius;
  final bool loading;

  final Widget? secondaryIcon;
  final String? font;

  const PrimaryButton({
    required this.onClick,
    required this.text,
    required this.height,
    this.secondaryIcon,
    this.loading = false,
    this.font,
    this.fontSize = 24,
    // todo maybe enum for radius and fontSize?
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
                              textAlign: TextAlign.center,
                              style: GoogleFonts.getFont(
                                  font ?? context.l.fontAndika,
                                  color: Colors.grey.shade100,
                                  fontSize: fontSize.toDouble()))),
                    ],
                  )
                : Center(
                    child: loading
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              valueColor: AlwaysStoppedAnimation<Color?>(
                                  Colors.grey.shade100),
                            ),
                          )
                        : Text(text,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.getFont(
                                font ?? context.l.fontAndika,
                                color: Colors.grey.shade100,
                                fontSize: fontSize.toDouble())),
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
        splashColor: context.t.dividerColor.withOpacity(0.08),
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

class TransparentButton extends StatelessWidget {
  final Widget child;
  final Function() onClick;
  final TransparentButtonBackground background;
  final bool border;

  const TransparentButton(this.child, this.onClick, this.background,
      {this.border = false});

  @override
  Widget build(BuildContext context) {
    Color splashColor;
    Color hoverColor;

    switch (background) {
      case TransparentButtonBackground.def:
        splashColor = context.t.dividerColor.withOpacity(0.08);
        hoverColor = context.t.dividerColor.withOpacity(0.04);
        break;
      case TransparentButtonBackground.purpleLight:
        splashColor = Colors.deepPurple.shade300.withOpacity(0.16);
        hoverColor = Colors.deepPurple.shade200.withOpacity(0.6);
        break;
      case TransparentButtonBackground.purpleDark:
        splashColor = Colors.deepPurple.shade200.withOpacity(0.2);
        hoverColor = Colors.deepPurple.shade200.withOpacity(0.4);
        break;
    }

    return Material(
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: border
                  ? Colors.deepPurple.shade100.withOpacity(0.16)
                  : Colors.transparent),
          borderRadius: BorderRadius.circular(8)),
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        splashColor: splashColor,
        hoverColor: hoverColor,
        highlightColor: Colors.transparent,
        focusColor: Colors.white.withOpacity(0.2),
        onTap: onClick,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: child,
        ),
      ),
    );
  }
}

class ListButton extends StatelessWidget {
  final Widget child;
  final Function() onPressed;

  const ListButton(this.child, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Colors.deepPurple.shade300,
      child: InkWell(
        splashColor: Colors.deepPurple.shade100.withOpacity(0.2),
        hoverColor: Colors.deepPurple.shade100.withOpacity(0.4),
        highlightColor: Colors.transparent,
        focusColor: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: child),
      ),
    );
  }
}

enum TransparentButtonBackground { def, purpleLight, purpleDark }
