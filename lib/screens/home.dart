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

import '../components/buttons.dart';
import '../components/logo.dart';
import '../components/page_router.dart';
import '../conf.dart';
import '../dialogs/open_dialog.dart';
import '../dialogs/receiver.dart';
import '../dialogs/share_app.dart';
import '../dialogs/share_text.dart';
import '../logic/sharing_object.dart';
import '../logic/theme.dart';
import '../utils/helper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<SharingObject> _latest = <SharingObject>[];

  @override
  void initState() {
    _latest = Hive.box<SharingObject>('history').values.toList();

    super.initState();
  }

  Future<void> saveLatest() async {
    await Hive.box<SharingObject>('history').clear();
    await Hive.box<SharingObject>('history').addAll(_latest);
  }

  Future<void> shareFile(SharingObject file) async {
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
        Expanded(
          child: LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth < 800) {
              return Column(
                children: [
                  sharingPart(c),
                  const SizedBox(
                    height: 22,
                  ),
                  latestHeaderPart(c),
                  Expanded(
                    child: latestListPart(c),
                  ),
                ],
              );
            } else {
              return Row(
                children: [
                  Expanded(child: sharingPart(c)),
                  // const SizedBox(
                  //   height: 12,
                  // ),
                  Expanded(
                      child: Column(
                    children: [
                      latestHeaderPart(c),
                      Expanded(
                        child: latestListPart(c),
                      ),
                    ],
                  ))
                ],
              );
            }
          }),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          height: 64,
          decoration: BoxDecoration(
              color: Colors.deepPurple.shade100,
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
                    'sharik v$currentVersion',
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

  Widget latestListPart(BuildContext c) {
    return ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
        itemCount: _latest.length,
        itemBuilder: (context, index) => card(context, _latest[index]));
  }

  Widget latestHeaderPart(BuildContext c) {
    if (_latest.isNotEmpty) {
      return Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 24, right: 24),
            child: Text(
              c.l.homeHistory,
              style: GoogleFonts.getFont(c.l.fontComfortaa, fontSize: 24),
            ),
          ),
          const Spacer(),
          Container(
              margin: const EdgeInsets.only(right: 24),
              child: TransparentButton(const Icon(FeatherIcons.trash), () {
                setState(() => _latest.clear());

                saveLatest();
              }, TransparentButtonBackground.purpleDark))
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  Widget sharingPart(BuildContext c) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: PrimaryButton(
            height: 110,
            onClick: () async {
              if (Platform.isAndroid || Platform.isIOS) {
                final f = await FilePicker.platform.pickFiles();

                if (f != null) {
                  shareFile(SharingObject(
                    data: (f.paths.first)!,
                    type: SharingObjectType.file,
                  ));
                }
              } else {
                final f = await openFile();
                if (f != null) {
                  shareFile(SharingObject(
                      data: f.path, type: SharingObjectType.file));
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
      ],
    );
  }

  Widget card(BuildContext c, SharingObject f) {
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
