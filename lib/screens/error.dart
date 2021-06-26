import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorScreen extends StatefulWidget {
  final String _error;

  const ErrorScreen(this._error);

  @override
  _ErrorScreenState createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  void initState() {
    Clipboard.setData(ClipboardData(text: widget._error));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurple.shade400,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            // todo translate
            child: Text(
              'Unfortunately, an error has occurred.\n\nError information was copied to the clipboard, please file an issue on GitHub:\nhttps://github.com/marchellodev/sharik\n\n\nRestarting or reinstalling the app might help solve the problem.\n\nThanks for using Sharik! :>',
              textAlign: TextAlign.center,
              style: GoogleFonts.jetBrainsMono(
                  fontSize: 14, color: Colors.grey.shade300),
            ),
          ),
        ));
  }
}
