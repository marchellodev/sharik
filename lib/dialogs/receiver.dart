import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sharik/components/buttons.dart';
import 'package:sharik/dialogs/open_dialog.dart';
import 'package:sharik/dialogs/select_network.dart';
import 'package:sharik/logic/services/receiver_service.dart';

import '../models/file.dart';
import '../utils/helper.dart';

class ReceiverDialog extends StatelessWidget {
  final ReceiverService receiverService = ReceiverService()..init();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: receiverService,
        builder: (context, _) {
          context.watch<ReceiverService>();

          return AlertDialog(
            elevation: 0,
            insetPadding: const EdgeInsets.all(24),
            title: Text(
              'Receiver',
              style: GoogleFonts.getFont(context.l.fontComfortaa,
                  fontWeight: FontWeight.w700),
            ),
            content: Text('content'),
            actions: [
              DialogTextButton(
                  'Network interfaces', receiverService.loaded ? () {


                    openDialog(context, PickNetworkDialog(receiverService.ipService));

              } : null),
              DialogTextButton(context.l.generalClose, () {
                Navigator.of(context).pop();
              }),
              const SizedBox(width: 4),
            ],
          );
        });
  }
}
