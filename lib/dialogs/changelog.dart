import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/buttons.dart';
import '../utils/helper.dart';

// review: done

class ChangelogDialog extends StatelessWidget {
  final String markdown;

  const ChangelogDialog(this.markdown);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      insetPadding: const EdgeInsets.all(24),
      title: Text(
        context.l.aboutChangelog,
        style: GoogleFonts.getFont(context.l.fontComfortaa,
            fontWeight: FontWeight.w700),
      ),
      scrollable: true,
      content: MarkdownBody(
        data: markdown,
        styleSheet: MarkdownStyleSheet(
          p: GoogleFonts.jetBrainsMono(fontSize: 12),
          h3: GoogleFonts.jetBrainsMono(fontSize: 14),
          h2: GoogleFonts.jetBrainsMono(
              height: 3, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        listItemCrossAxisAlignment: MarkdownListItemCrossAxisAlignment.start,
      ),
      actions: [
        DialogTextButton(context.l.generalClose, () {
          Navigator.of(context).pop();
        }),
      ],
    );
  }
}
