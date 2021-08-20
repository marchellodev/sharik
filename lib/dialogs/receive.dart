import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock/wakelock.dart';

import '../components/buttons.dart';
import '../logic/services/receiver_service.dart';
import '../logic/sharing_object.dart';
import '../utils/helper.dart';
import 'open_dialog.dart';
import 'select_network.dart';

// review: done

class ReceiverDialog extends StatefulWidget {
  @override
  _ReceiverDialogState createState() => _ReceiverDialogState();
}

class _ReceiverDialogState extends State<ReceiverDialog> {
  final ReceiverService receiverService = ReceiverService()..init();

  @override
  void initState() {
    if (!Platform.isLinux) {
      Wakelock.enable();
    }

    super.initState();
  }

  @override
  void dispose() {
    receiverService.kill();
    if (!Platform.isLinux) {
      Wakelock.disable();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: receiverService,
        builder: (context, _) {
          context.watch<ReceiverService>();

          return AlertDialog(
            scrollable: true,
            elevation: 0,
            insetPadding: const EdgeInsets.all(24),
            title: Text(
              context.l.sharingReceiver,
              style: GoogleFonts.getFont(context.l.fontComfortaa,
                  fontWeight: FontWeight.w700),
            ),
            content: receiverService.receivers.isEmpty
                ? SizedBox(
                    height: 42,
                    child: Center(
                      child: Stack(
                        children: [
                          Center(
                            child: SizedBox(
                                height: 42,
                                width: 42,
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(context
                                        .t.accentColor
                                        .withOpacity(0.8)))),
                          ),
                          Center(
                            child: Text(receiverService.loop.toString(),
                                style: GoogleFonts.getFont(
                                    context.l.fontComfortaa,
                                    fontSize: 13)),
                          )
                        ],
                      ),
                    ),
                  )
                : SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      children: [
                        SizedBox(
                          height: receiverService.receivers.length * 60,
                          child: Theme(
                            data: context.t.copyWith(
                              splashColor: context.t.dividerColor.withOpacity(0.08),
                              highlightColor: Colors.transparent,
                            ),
                            child: ListView.builder(
                                itemCount: receiverService.receivers.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (_, e) => ListTile(
                                  hoverColor: context.t.dividerColor.withOpacity(0.04),
                                      // todo text styling
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      leading: Icon(SharingObject(
                                        name: receiverService.receivers[e].name,
                                        data: receiverService.receivers[e].name,
                                        type: receiverService.receivers[e].type,
                                      ).icon),
                                      // todo style colors
                                      title: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Text(
                                            receiverService.receivers[e].name,
                                            style: GoogleFonts.getFont('Andika'),
                                          )),
                                      subtitle: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          '${receiverService.receivers[e].os}  •  ${receiverService.receivers[e].addr.ip}:${receiverService.receivers[e].addr.port}',
                                          style: GoogleFonts.getFont('Andika'),
                                        ),
                                      ),
                                      onTap: () {
                                        launch(
                                            'http://${receiverService.receivers[e].addr.ip}:${receiverService.receivers[e].addr.port}');
                                      },
                                    )),
                          ),
                        ),
                      ],
                    ),
                  ),
            actions: [
              DialogTextButton(
                  context.l.sharingNetworkInterfaces,
                  receiverService.loaded
                      ? () async {
                          final s = receiverService.ipService.selectedInterface;
                          await openDialog(context,
                              PickNetworkDialog(receiverService.ipService));
                          if (receiverService.ipService.selectedInterface !=
                              s) {
                            receiverService.loop = 0;
                          }
                        }
                      : null),
              DialogTextButton(context.l.generalClose, () {
                Navigator.of(context).pop();
              }),
              const SizedBox(width: 4),
            ],
          );
        });
  }
}
