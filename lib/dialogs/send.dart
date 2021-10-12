import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../components/buttons.dart';
import '../conf.dart';
import '../logic/sharing_object.dart';
import '../utils/helper.dart';
import 'open_dialog.dart';
import 'share_app.dart';
import 'share_text.dart';

class SendDialog extends StatelessWidget {
  const SendDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      insetPadding: const EdgeInsets.all(24),
      title: Text(
        context.l.homeSend,
        style: GoogleFonts.getFont(context.l.fontComfortaa,
            fontWeight: FontWeight.w700),
      ),
      scrollable: true,
      content: Column(
        children: [
          SizedBox(
              width: double.infinity,
              child: TransparentButton(
                Row(
                  children: [
                    const Icon(
                      LucideIcons.file,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      context.l.homeFiles,
                      style: GoogleFonts.getFont(context.l.fontAndika,
                          fontSize: 18),
                    ),
                  ],
                ),
                () async {
                  if (Platform.isAndroid || Platform.isIOS) {
                    final f = await FilePicker.platform
                        .pickFiles(allowMultiple: true);

                    if (f != null) {
                      Navigator.of(context).pop(SharingObject(
                          data: f.paths.join(multipleFilesDelimiter),
                          type: SharingObjectType.file,
                          name: SharingObject.getSharingName(
                              SharingObjectType.file,
                              f.paths.join(multipleFilesDelimiter))));
                    }
                  } else {
                    final f = await openFiles();
                    if (f.isNotEmpty) {
                      final data =
                          f.map((e) => e.path).join(multipleFilesDelimiter);
                      Navigator.of(context).pop(SharingObject(
                        data: data,
                        type: SharingObjectType.file,
                        name: SharingObject.getSharingName(
                            SharingObjectType.file, data),
                      ));
                    }
                  }
                },
                TransparentButtonBackground.def,
                border: true,
              )),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: TransparentButton(
              Row(
                children: [
                  const Icon(
                    LucideIcons.fileText,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    context.l.homeSelectText,
                    style:
                        GoogleFonts.getFont(context.l.fontAndika, fontSize: 18),
                  ),
                ],
              ),
              () async {
                final text = await openDialog(context, ShareTextDialog());
                if (text != null) {
                  Navigator.of(context).pop(text);
                }
              },
              TransparentButtonBackground.def,
              border: true,
            ),
          ),
          if (Platform.isAndroid || Platform.isIOS) const SizedBox(height: 12),
          if (Platform.isAndroid)
            SizedBox(
                width: double.infinity,
                child: TransparentButton(
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.binary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        context.l.homeSelectApp,
                        style: GoogleFonts.getFont(context.l.fontAndika,
                            fontSize: 18),
                      ),
                    ],
                  ),
                  () async {
                    final f = await openDialog(context, ShareAppDialog());
                    if (f != null) {
                      Navigator.of(context).pop(f);
                    }
                  },
                  TransparentButtonBackground.def,
                  border: true,
                )),
          if (Platform.isIOS)
            SizedBox(
                width: double.infinity,
                child: TransparentButton(
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.image,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        context.l.homeSelectGallery,
                        style: GoogleFonts.andika(fontSize: 18),
                      ),
                    ],
                  ),
                  () async {
                    final f = await FilePicker.platform
                        .pickFiles(type: FileType.media, allowMultiple: true);

                    if (f != null) {
                      Navigator.of(context).pop(SharingObject(
                          data: f.paths.join(multipleFilesDelimiter),
                          type: SharingObjectType.file,
                          name: SharingObject.getSharingName(
                              SharingObjectType.file,
                              f.paths.join(multipleFilesDelimiter))));
                    }
                  },
                  TransparentButtonBackground.def,
                  border: true,
                )),
        ],
      ),
      actions: [
        DialogTextButton(context.l.generalClose, () {
          Navigator.of(context).pop();
        }),
        const SizedBox(width: 4),
      ],
    );
  }
}
