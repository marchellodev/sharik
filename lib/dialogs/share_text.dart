import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/buttons.dart';
import '../logic/sharing_object.dart';
import '../utils/helper.dart';

// review: done

class ShareTextDialog extends StatefulWidget {
  @override
  _ShareTextDialogState createState() => _ShareTextDialogState();
}

class _ShareTextDialogState extends State<ShareTextDialog> {
  String text = '';

  // todo cancel instead close
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      insetPadding: const EdgeInsets.all(24),
      title: Text(
        context.l.homeSelectTextTypeSomeText,
        style: GoogleFonts.getFont(context.l.fontComfortaa,
            fontWeight: FontWeight.w700),
      ),
      scrollable: true,
      content: TextField(
        autofocus: true,
        maxLines: null,
        minLines: 2,
        onChanged: (str) {
          setState(() {
            text = str;
          });
        },
      ),
      actions: [
        DialogTextButton(context.l.generalClose, () {
          Navigator.of(context).pop();
        }),
        DialogTextButton(
            context.l.generalSend,
            text.isEmpty
                ? null
                : () {
                    Navigator.of(context).pop(SharingObject(
                      data: text,
                      type: SharingObjectType.text,
                      name: SharingObject.getSharingName(
                          SharingObjectType.text, text),
                    ));
                  }),
        const SizedBox(width: 4),
      ],
    );
  }
}
