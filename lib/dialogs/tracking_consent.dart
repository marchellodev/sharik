import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../components/buttons.dart';

import '../utils/helper.dart';

class TrackingConsentDialog extends StatefulWidget {
  const TrackingConsentDialog({Key? key}) : super(key: key);

  @override
  _TrackingConsentDialogState createState() => _TrackingConsentDialogState();
}

class _TrackingConsentDialogState extends State<TrackingConsentDialog> {
  int _timer = 5;

  void _tick() {
    if (_timer == 0) {
      return;
    }

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) {
        return;
      }

      setState(() {
        _timer--;
      });
      _tick();
    });
  }

  @override
  void initState() {
    _tick();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        elevation: 0,
        insetPadding: const EdgeInsets.all(24),
        title: Text(
          context.l.settingsTracking,
          style: GoogleFonts.getFont(
            context.l.fontComfortaa,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          DialogTextButton(
              '${context.l.settingsTrackingDisable}${_timer > 0 ? ' ($_timer)' : ''}',
              _timer > 0
                  ? null
                  : () {
                      Hive.box<String>('strings').put('tracking', '0');
                      Navigator.of(context).pop();
                    }),
          DialogTextButton(context.l.settingsTrackingAllow, () {
            Hive.box<String>('strings').put('tracking', '1');
            Navigator.of(context).pop();
          }),
        ],
        scrollable: true,
        content: MarkdownBody(
          data: context.l.settingsTrackingDescription,
          styleSheet: MarkdownStyleSheet(
            p: GoogleFonts.jetBrainsMono(fontSize: 14),
          ),
          listItemCrossAxisAlignment: MarkdownListItemCrossAxisAlignment.start,
        ));
  }
}
