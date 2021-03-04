import 'dart:convert';
import 'dart:io' show Platform;

import 'package:collection/collection.dart' show IterableExtension;
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:ping_discover_network/ping_discover_network.dart';
import 'package:provider/provider.dart';
import 'package:sharik/logic/navigation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../conf.dart';
import '../models/file.dart';
import '../models/sender.dart';
import '../utils/helper.dart';
import 'app_selector.dart';

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

    context.n.file = file;
    context.n.page = SharingPage();

    // _model.file = file;
    // _model.setState(() => _model.setPage(PageModel.sharing));
  }

  @override
  Widget build(BuildContext c) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
        Widget>[
      Container(
          margin: const EdgeInsets.only(left: 24, right: 24, top: 8),
          height: 104,
          child: Material(
            borderRadius: BorderRadius.circular(12),
            color: Colors.deepPurple[400],
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () async {
                // final f = await FilePicker.getFile();
                // if (f != null && f.path != null && f.path.isNotEmpty) {
                //   shareFile(FileModel(data: f.path, type: FileTypeModel.file));
                // }
              },
              child: Stack(
                children: <Widget>[
                  Center(
                      child: Text(c.l!.homeSelectFile,
                          style: GoogleFonts.getFont(c.l!.fontAndika,
                              color: Colors.white, fontSize: 24))),
                  Container(
                    margin: const EdgeInsets.all(16),
                    child: Align(
                        alignment: Alignment.bottomRight,
                        child: SvgPicture.asset(
                          'assets/icon_file.svg',
                        )),
                  )
                ],
              ),
            ),
          )),
      Row(
        children: <Widget>[
          if (Platform.isAndroid)
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 24, top: 8),
                  height: 48,
                  child: Material(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.deepPurple[400],
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        final data = await showDialog(
                            context: context,
                            builder: (_) => AppSelector()) as String?;
                        if (data != null && data.isNotEmpty) {
                          final app = await DeviceApps.getApp(data);
                          shareFile(FileModel(
                              type: FileTypeModel.app,
                              data: app.apkFilePath,
                              name: app.appName));
                        }
                      },
                      child: Center(
                          child: Text(c.l!.homeSelectApp,
                              style: GoogleFonts.getFont(c.l!.fontAndika,
                                  color: Colors.white, fontSize: 24))),
                    ),
                  )),
            ),
          if (Platform.isIOS)
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 24, top: 8),
                  height: 48,
                  child: Material(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.deepPurple[400],
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        // final f =
                        //     await FilePicker.getFile(type: FileType.media);
                        // if (f != null && f.path != null && f.path.isNotEmpty) {
                        //   shareFile(FileModel(
                        //       data: f.path, type: FileTypeModel.file));
                        // }
                      },
                      child: Center(
                          child: Text(c.l!.homeSelectGallery,
                              style: GoogleFonts.getFont(c.l!.fontAndika,
                                  color: Colors.white, fontSize: 24))),
                    ),
                  )),
            ),
          SizedBox(
            width: Platform.isAndroid || Platform.isIOS ? 8 : 24,
          ),
          Expanded(
            child: Container(
                margin: const EdgeInsets.only(right: 24, top: 8),
                height: 48,
                child: Material(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.deepPurple[400],
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          final controller = TextEditingController();
                          return AlertDialog(
                            title: Text(
                              c.l!.homeSelectTextTypeSomeText,
                              style: GoogleFonts.getFont(c.l!.fontComfortaa,
                                  fontWeight: FontWeight.w700),
                            ),
                            content: TextField(
                              autofocus: true,
                              controller: controller,
                              maxLines: null,
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(c.l!.generalClose,
                                    style:
                                        GoogleFonts.getFont(c.l!.fontAndika)),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();

                                  if (controller.text.isNotEmpty) {
                                    shareFile(FileModel(
                                        data: controller.text,
                                        type: FileTypeModel.text,
                                        name: ''));
                                  }
                                },
                                child: Text(c.l!.generalSend,
                                    style:
                                        GoogleFonts.getFont(c.l!.fontAndika)),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Center(
                        child: Text(c.l!.homeSelectText,
                            style: GoogleFonts.getFont(c.l!.fontAndika,
                                color: Colors.white, fontSize: 24))),
                  ),
                )),
          ),
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
                c.l!.homeLatest,
                style: GoogleFonts.getFont(c.l!.fontComfortaa, fontSize: 24),
              ),
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.only(right: 24),
              child: IconButton(
                  onPressed: () {
                    setState(() => _latest.clear());

                    saveLatest();
                  },
                  icon: SvgPicture.asset(
                    'assets/icon_remove.svg',
                    semanticsLabel: 'remove',
                    height: 16,
                  )),
            )
          ],
        ),
      Expanded(
        child: Container(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: ListView.builder(
                padding: const EdgeInsets.only(top: 16),
                itemCount: _latest.length,
                itemBuilder: (context, index) =>
                    card(context, _latest[index]))),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        height: 64,
        decoration: BoxDecoration(
            color: Colors.deepPurple[100],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        child: Row(
          children: <Widget>[
            Material(
              color: Colors.deepPurple[100],
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                splashColor: Colors.deepPurple[400],
                onTap: () =>
                    context.read<NavigationManager>().page = LanguagePage(),
                child: Container(
                  margin: const EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    'assets/icon_locale.svg',
                    semanticsLabel: 'locale',
                    height: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 2),
            Material(
              color: Colors.deepPurple[100],
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                splashColor: Colors.deepPurple[400],
                onTap: () =>
                    context.read<NavigationManager>().page = IntroPage(),
                child: Container(
                  margin: const EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    'assets/icon_help.svg',
                    semanticsLabel: 'help',
                    height: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 2),
            Material(
              color: Colors.deepPurple[100],
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                splashColor: Colors.deepPurple[400],
                onTap: () {
                  final senders = <Sender>[];
                  var running = false;
                  var stop = false;
                  var n = 0;

                  //todo: check for ip wiser?
                  Future<String> getIpMask() async {
                    // final ip = (await SharikWrapper.getLocalIp).split('.');
                    const ip = 'localhost';
                    return '${ip[0]}.${ip[1]}.${ip[2]}';

//                        for (var interface in await NetworkInterface.list()) {
//                          for (var addr in interface.addresses) {
//                            if (addr.address.startsWith('192.168.')) {
//                              return '192.168.0';
//                            }
//                            if (addr.address.startsWith('172.16.')) {
//                              return '172.16.0';
//                            }
//                            if (addr.address.startsWith('10.')) {
//                              return '10.0.0';
//                            }
//                          }
//                        }
//                        if (!stop) {
//                          await Future.delayed(Duration(seconds: 1));
//                          return getIpMask();
//                        } else {
//                          return null;
//                        }
                  }

                  // ignore: avoid_void_async
                  void portRunner(StateSetter setState) async {
                    if (stop) {
                      return;
                    }

                    running = true;

                    final port = ports[n % ports.length];

                    if (n % 4 == 0) {
                      await Future.delayed(const Duration(seconds: 1));
                    }

                    if (senders.firstWhereOrNull(
                            (element) => element.n! < n ~/ ports.length) !=
                        null) {
                      setState(() {
                        senders.removeWhere(
                            (element) => element.n! < n ~/ ports.length);
                      });
                    }
                    final ip = await getIpMask();
                    print(ip);

                    // todo recode all of that
                    // ignore: avoid_single_cascade_in_expression_statements
                    NetworkAnalyzer.discover2(
                      ip,
                      port,
                      timeout: const Duration(milliseconds: 500),
                    )..listen((addr) async {
                        if (addr.exists) {
                          //todo: proper deserialization

                          try {
                            final info = jsonDecode(await http.read(Uri.parse(
                                'http://${addr.ip}:$port/sharik.json')));

                            final sender = Sender(
                                n: n ~/ ports.length,
                                ip: addr.ip,
                                type: cast<String>(info['type']),
                                version: cast<String>(info['sharik']),
                                name: cast<String>(info['name']),
                                os: cast<String>(info['os']),
                                url: 'http://${addr.ip}:$port');
                            final inArr = senders.firstWhereOrNull((element) =>
                                element.ip == sender.ip &&
                                element.os == sender.os &&
                                element.name == sender.name);

                            if (inArr == null) {
                              setState(() => senders.add(sender));
                            } else {
                              inArr.n = n;
                            }
                          } catch (e) {
                            //todo: catch error
                          }
                        }
                      }).onDone(() {
                        n++;
                        portRunner(setState);
                      });
                  }

                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(c.l!.homeReceiver,
                              style: GoogleFonts.getFont(c.l!.fontComfortaa,
                                  fontWeight: FontWeight.w700)),
                          content: StatefulBuilder(
                            builder: (_, StateSetter setState) {
                              if (!running) {
                                portRunner(setState);
                              }

                              return senders.isNotEmpty
                                  ? SizedBox(
                                      height: 320,
                                      width: 120,
                                      child: ListView(
                                        shrinkWrap: true,
                                        children: senders
                                            .map((e) {
                                              return ListTile(
                                                onTap: () async {
                                                  if (await canLaunch(e.url!)) {
                                                    await launch(e.url!);
                                                  }
                                                },
                                                subtitle: Text(e.os!),
                                                title: Text(e.name!),
                                                //todo: what's below looks ugly
//                                                    leading: SvgPicture.asset(
//                                                        FileModel(
//                                                                type: e.type,
//                                                                name: e.name)
//                                                            .icon,
//                                                        color: Colors.black),
                                              );
                                            })
                                            .toList()
                                            .cast<Widget>(),
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Center(
                                          child: Container(
                                            height: 28,
                                            width: 28,
                                            margin: const EdgeInsets.all(4),
                                            child:
                                                const CircularProgressIndicator(),
                                          ),
                                        ),
                                      ],
                                    );
                            },
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                c.l!.generalClose,
                                style: GoogleFonts.getFont(c.l!.fontAndika),
                              ),
                            )
                          ],
                        );
                      }).then((value) => stop = true);
                },
                child: Container(
                  margin: const EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    'assets/icon_receive.svg',
                    semanticsLabel: 'receive',
                    height: 16,
                  ),
                ),
              ),
            ),
            const Spacer(),
            // todo make it into a component
            Material(
              color: Colors.deepPurple[100],
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                splashColor: Colors.deepPurple[400],
                onTap: () {
                  context.n.page = AboutPage();
                  //todo: refactor
//                   showDialog(
//                       context: context,
//                       builder: (BuildContext context) => FutureBuilder(
//                           future: () async {
//                             final info = await PackageInfo.fromPlatform();
//                             final v =
//                                 '${info.version.split('.')[0]}.${info.version.split('.')[1]}';
//
//                             final response = await http.read(
//                                 'https://marchello.cf/shas/versions?package=${info.packageName}&version=$v&platform=${Platform.operatingSystem}&platform_version=${Uri.encodeComponent(Platform.operatingSystemVersion)}');
//
//                             return jsonDecode(response);
//                           }(),
//                           builder: (_, AsyncSnapshot snapshot) => AlertDialog(
//                                 title: Text(
//                                   c.l.homeUpdates,
//                                   style: GoogleFonts.getFont(c.l.fontComfortaa,
//                                       fontWeight: FontWeight.w700),
//                                 ),
//                                 // todo create model for this
//                                 content: Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     if (!snapshot.hasData)
//                                       const CircularProgressIndicator()
//                                     else if (snapshot.data['latest'] == null ||
//                                         cast<bool>(snapshot.data['latest']) ||
//                                         !cast<bool>(snapshot.data['ok']))
//                                       Text(c.l.homeUpdatesTheLatestVersionIsInstalled,
//                                           style: GoogleFonts.getFont(
//                                               c.l.fontAndika))
//                                     else
//                                       changelog(c, cast<Map>(snapshot.data)),
//                                   ],
//                                 ),
//                                 actions: [
//                                   if (Platform.isAndroid &&
//                                       snapshot.hasData &&
//                                       cast<bool>(snapshot.data['ok']) &&
//                                       !cast<bool>(snapshot.data['latest']))
//                                     FlatButton(
//                                       onPressed: () async {
//                                         if (await canLaunch(
//                                             'https://play.google.com/store/apps/details?id=dev.marchello.sharik')) {
//                                           await launch(
//                                               'https://play.google.com/store/apps/details?id=dev.marchello.sharik');
//                                         }
//                                       },
//                                       child: Text('Play Store',
//                                           style: GoogleFonts.andika()),
//                                     ),
//                                   if (snapshot.hasData &&
//                                       cast<bool>(snapshot.data['ok']) &&
//                                       !cast<bool>(snapshot.data['latest']))
//                                     FlatButton(
//                                       onPressed: () async {
//                                         if (await canLaunch(
//                                             'https://github.com/marchellodev/sharik')) {
//                                           await launch(
//                                               'https://github.com/marchellodev/sharik');
//                                         }
//                                       },
//                                       child: Text('GitHub',
//                                           style: GoogleFonts.andika()),
//                                     ),
//                                   FlatButton(
//                                     onPressed: () =>
//                                         Navigator.of(context).pop(),
//                                     child: Text(
//                                       c.l.generalClose,
//                                       style:
//                                           GoogleFonts.getFont(c.l.fontAndika),
//                                     ),
//                                   )
//                                 ],
// //                                  scrollable: true,
//                               )));
                },
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    'sharik v3.0',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.deepPurple[700],
                        fontFamily: 'JetBrainsMono'),
                  ),
                ),
              ),
            ),
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
    ]);
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
                      '${c.l!.homeUpdatesCurrentVersion}:',
                      style: GoogleFonts.getFont(c.l!.fontAndika, fontSize: 16),
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
                      '${c.l!.homeUpdatesLatestVersion}:',
                      style: GoogleFonts.getFont(c.l!.fontAndika, fontSize: 16),
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
                c.l!.homeUpdatesChangelog,
                style: GoogleFonts.getFont(c.l!.fontComfortaa, fontSize: 18),
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
    return Container(
      height: 44,
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Colors.deepPurple[300],
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            shareFile(f);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                SvgPicture.asset(
                  f.icon,
                  semanticsLabel: 'file ',
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
                    style: GoogleFonts.getFont(c.l!.fontAndika,
                        color: Colors.white, fontSize: 18),
                    maxLines: 1,
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
