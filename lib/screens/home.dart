import 'dart:io' show Platform;
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:sharik/components/buttons.dart';
import 'package:sharik/components/logo.dart';
import 'package:sharik/components/page_router.dart';
import 'package:sharik/dialogs/open_dialog.dart';
import 'package:sharik/dialogs/receiver.dart';
import 'package:sharik/dialogs/share_text.dart';
import 'package:sharik/logic/theme.dart';

import '../conf.dart';
import '../dialogs/share_app.dart';
import '../models/file.dart';
import '../utils/helper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<FileModel> _latest = <FileModel>[];

  @override
  void initState() {
    _latest = Hive.box<FileModel>('history').values.toList();

    super.initState();
  }

  Future<void> saveLatest() async {
    await Hive.box<FileModel>('history').clear();
    await Hive.box<FileModel>('history').addAll(_latest);
  }

  Future<void> shareFile(FileModel file) async {
    setState(() {
      if (_latest.contains(file)) _latest.remove(file);

      _latest.insert(0, file);
    });

    await saveLatest();

    // context.n.file = file;
    // context.n.page = SharingPage();
    SharikRouter.navigateTo(
        context, context.widget, Screens.sharing, RouteDirection.right, file);
    // _model.file = file;
    // _model.setState(() => _model.setPage(PageModel.sharing));
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SafeArea(child: SizedBox(height: 28)),
        Hero(
          tag: 'icon',
          child: SharikLogo(),
        ),
        const SizedBox(height: 34),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: PrimaryButton(
            height: 110,
            onClick: () async {
              if (Platform.isAndroid || Platform.isIOS) {
                final f = await FilePicker.platform.pickFiles();

                if (f != null) {
                  shareFile(FileModel(
                    data: (f.paths.first)!,
                    type: FileTypeModel.file,
                  ));
                }
              } else {
                final f = await openFile();
                if (f != null) {
                  shareFile(FileModel(data: f.path, type: FileTypeModel.file));
                }
              }
            },
            text: c.l.homeSelectFile,
            secondaryIcon: SvgPicture.asset(
              'assets/icon_file.svg',
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const SizedBox(width: 24),
            if (Platform.isAndroid)
              Expanded(
                child: PrimaryButton(
                  height: 50,
                  onClick: () async {
                    final f = await openDialog(context, ShareAppDialog());
                    if (f != null) {
                      shareFile(f);
                    }
                  },
                  text: c.l.homeSelectApp,
                ),
              ),
            if (Platform.isIOS)
              Expanded(
                child: PrimaryButton(
                  height: 50,
                  onClick: () async {
                    // todo ios gallery
                    // final f =
                    //     await FilePicker.getFile(type: FileType.media);
                    // if (f != null && f.path != null && f.path.isNotEmpty) {
                    //   shareFile(FileModel(
                    //       data: f.path, type: FileTypeModel.file));
                    // }
                  },
                  text: c.l.homeSelectGallery,
                ),
              ),
            if (Platform.isIOS || Platform.isAndroid) const SizedBox(width: 10),
            Expanded(
              child: PrimaryButton(
                height: 50,
                onClick: () async {
                  // todo return the file model instead for consistency
                  final f = await openDialog(context, ShareTextDialog());
                  if (f != null) {
                    shareFile(f);
                  }
                },
                text: c.l.homeSelectText,
              ),
            ),
            const SizedBox(width: 24),
          ],
        ),
        const SizedBox(
          height: 22,
        ),
        if (_latest.isNotEmpty)
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 24, right: 24),
                child: Text(
                  // todo rename to history
                  c.l.homeLatest,
                  style: GoogleFonts.getFont(c.l.fontComfortaa, fontSize: 24),
                ),
              ),
              const Spacer(),
              Container(
                  margin: const EdgeInsets.only(right: 24),
                  child: TransparentButton(
                      const Icon(FeatherIcons.trash),
                      () => () {
                            setState(() => _latest.clear());

                            saveLatest();
                          },
                      TransparentButtonBackground.purpleDark))
            ],
          ),
        Expanded(
          child: ListView.builder(
              padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
              itemCount: _latest.length,
              itemBuilder: (context, index) => card(context, _latest[index])),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          height: 64,
          decoration: BoxDecoration(
              color: Colors.deepPurple[100],
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24))),
          child: Row(
            children: [
              TransparentButton(
                  SizedBox(
                      height: 20,
                      width: 20,
                      child: Icon(FeatherIcons.globe,
                          color: Colors.deepPurple.shade700, size: 20)),
                  () => SharikRouter.navigateTo(context, context.widget,
                      Screens.languagePicker, RouteDirection.left),
                  TransparentButtonBackground.purpleLight),
              const SizedBox(width: 2),
              TransparentButton(
                SizedBox(
                    height: 20,
                    width: 20,
                    child: Icon(FeatherIcons.helpCircle,
                        color: Colors.deepPurple.shade700, size: 20)),
                () => SharikRouter.navigateTo(context, context.widget,
                    Screens.intro, RouteDirection.left),
                TransparentButtonBackground.purpleLight,
              ),
              const SizedBox(width: 2),
              TransparentButton(
                  SizedBox(
                      height: 20,
                      width: 20,
                      child: Icon(FeatherIcons.download,
                          color: Colors.deepPurple.shade700, size: 20)), () {
                openDialog(context, ReceiverDialog());
              }, TransparentButtonBackground.purpleLight),
              const SizedBox(width: 2),
              TransparentButton(
                  SizedBox(
                      height: 20,
                      width: 20,
                      child: Icon(context.watch<ThemeManager>().icon,
                          color: Colors.deepPurple.shade700, size: 20)),
                  () => context.read<ThemeManager>().change(),
                  TransparentButtonBackground.purpleLight),
              const Spacer(),
              TransparentButton(
                  Text(
                    'sharik v3.0',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.deepPurple.shade700,
                        fontFamily: 'JetBrainsMono'),
                  ),
                  () => SharikRouter.navigateTo(context, context.widget,
                      Screens.about, RouteDirection.right),
                  TransparentButtonBackground.purpleLight),
            ],
          ),
        ),
        Container(
          color: Colors.deepPurple[100],
          child: SafeArea(
            top: false,
            right: false,
            left: false,
            child: Container(),
          ),
        )
      ]),
    );
  }

  Widget changelog(BuildContext c, Map data) {
    final changes = <Widget>[];

    data['changelog'].forEach((element) {
      changes.add(Text(
        'v${element['version']}',
        style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 16),
      ));
      changes.add(const SizedBox(
        height: 4,
      ));
      element['changes'].forEach((change) {
        changes.add(Text(' • $change',
            style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 14)));
        changes.add(const SizedBox(
          height: 2,
        ));
      });
      changes.add(const SizedBox(
        height: 10,
      ));
    });
    return SizedBox(
        height: 360,
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            Row(
              children: [
                SizedBox(
                    width: 160,
                    child: Text(
                      '${c.l.homeUpdatesCurrentVersion}:',
                      style: GoogleFonts.getFont(c.l.fontAndika, fontSize: 16),
                    )),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  'v${data['current_version']}',
                  style: const TextStyle(fontFamily: 'JetBrainsMono'),
                )
              ],
            ),
            Row(
              children: [
                SizedBox(
                    width: 160,
                    child: Text(
                      '${c.l.homeUpdatesLatestVersion}:',
                      style: GoogleFonts.getFont(c.l.fontAndika, fontSize: 16),
                    )),
                const SizedBox(
                  width: 4,
                ),
                Text('v${data['latest_version']}',
                    style: const TextStyle(fontFamily: 'JetBrainsMono'))
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Center(
              child: Text(
                c.l.homeUpdatesChangelog,
                style: GoogleFonts.getFont(c.l.fontComfortaa, fontSize: 18),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: changes,
            ),
          ],
        ));
  }

  Widget card(BuildContext c, FileModel f) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ListButton(
          Row(
            children: <Widget>[
              SvgPicture.asset(
                f.icon,
                semanticsLabel: 'file',
                width: 18,
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                  child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  f.name,
                  style: GoogleFonts.getFont(c.l.fontAndika,
                      color: Colors.white, fontSize: 18),
                  maxLines: 1,
                ),
              ))
            ],
          ),
          () => shareFile(f)),
    );
  }
}
