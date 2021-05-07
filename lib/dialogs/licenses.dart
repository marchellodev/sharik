import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sharik/components/buttons.dart';
import 'package:sharik/dialogs/open_dialog.dart';

import '../utils/helper.dart';

// todo restyle

class LicensesDialog extends StatefulWidget {
  @override
  _LicensesDialogState createState() => _LicensesDialogState();
}

class _LicensesDialogState extends State<LicensesDialog> {
  final Map<String, List<LicenseEntry>> list = {};

  Future<void> listener() async {
    final stream = LicenseRegistry.licenses;

    await for (final license in stream) {
      setState(() {
        for (final package in license.packages) {
          if (!list.keys.contains(package)) {
            list[package] = [];
          }

          list[package]!.add(license);
        }
      });
    }
  }

  @override
  void initState() {
    listener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        elevation: 0,
        insetPadding: const EdgeInsets.all(24),
        title: Text(
          // todo translate
          'Licenses',
          style: GoogleFonts.getFont(context.l.fontComfortaa,
              fontWeight: FontWeight.w700),
        ),
        actions: [
          DialogTextButton(context.l.generalClose, () {
            Navigator.of(context).pop();
          }),
        ],
        scrollable: true,
        content: Column(
            children: list.entries
                .map((license) => ListTile(
                      title: Text(license.key),
                      // todo secondary color
                      trailing: Text(license.value.length.toString()),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onTap: () {
                        openDialog(context,
                            _LicensesDetailDialog(license.key, license.value));
                      },
                    ))
                .toList()));
  }
}

class _LicensesDetailDialog extends StatelessWidget {
  final String name;
  final List<LicenseEntry> licenses;

  const _LicensesDetailDialog(this.name, this.licenses);

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[];

    for (final license in licenses) {
      for (final par in license.paragraphs) {
        if (par.indent == LicenseParagraph.centeredIndent) {
          widgets.add(Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              par.text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'JetBrainsMono',
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ));
        }
        widgets.add(Padding(
          padding: EdgeInsets.only(top: 8, left: 16.0 * max(par.indent, 0)),
          child: Text(
            par.text,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 12,
            ),
          ),
        ));
      }

      widgets.add(const Padding(
        padding: EdgeInsets.all(18),
        child: Divider(),
      ));
    }

    // todo alertdialog as a template
    return AlertDialog(
        elevation: 0,
        insetPadding: const EdgeInsets.all(24),
        title: Text(
          // todo translate
          name,
          style: GoogleFonts.getFont(context.l.fontComfortaa,
              fontWeight: FontWeight.w700),
        ),
        actions: [
          DialogTextButton(context.l.generalClose, () {
            Navigator.of(context).pop();
          }),
        ],
        scrollable: true,
        content: Column(children: widgets));
  }
}
