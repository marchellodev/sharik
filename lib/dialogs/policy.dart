import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/buttons.dart';
import '../utils/helper.dart';

// review: done

class PolicyDialog extends StatelessWidget {
  final String markdown;
  final String name;
  final String url;

  const PolicyDialog({
    required this.markdown,
    required this.name,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      insetPadding: const EdgeInsets.all(24),
      title: Text(
        name,
        style: GoogleFonts.getFont(
          context.l.fontComfortaa,
          fontWeight: FontWeight.w700,
        ),
      ),
      scrollable: true,
      content: MarkdownBody(
        data: markdown,
        styleSheet: MarkdownStyleSheet(
          p: GoogleFonts.jetBrainsMono(fontSize: 12),
          h3: GoogleFonts.jetBrainsMono(fontSize: 14),
          h2: GoogleFonts.jetBrainsMono(
            height: 3,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTapLink: (text, href, title) => launch(href!),
        listItemCrossAxisAlignment: MarkdownListItemCrossAxisAlignment.start,
      ),
      actions: [
        DialogTextButton(context.l.generalOpenInGithub, () {
          launch(url);
        }),
        DialogTextButton(context.l.generalClose, () {
          Navigator.of(context).pop();
        }),
      ],
    );
  }
}
