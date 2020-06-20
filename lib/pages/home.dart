import 'dart:convert';
import 'dart:io' show NetworkInterface, Platform;

import 'package:device_apps/device_apps.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';
import 'package:ping_discover_network/ping_discover_network.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../conf.dart';
import '../locale.dart';
import '../models/app.dart';
import '../models/file.dart';
import '../models/page.dart';
import '../models/sender.dart';
import 'app_selector.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _latest = <FileModel>[];
  AppModel _model;

  @override
  void initState() {
    _model = Provider.of<AppModel>(context, listen: false);
    _latest =
        Hive.box('app2').get('latest', defaultValue: []).cast<FileModel>();
    super.initState();
  }

  void saveLatest() {
    Hive.box('app2').put('latest', _latest);
  }

  void shareFile(FileModel file) {
    setState(() {
      if (_latest.contains(file)) _latest.remove(file);

      _latest.insert(0, file);
    });

    saveLatest();
    _model.file = file;
    _model.setState(() => _model.setPage(PageModel.sharing));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(left: 24, right: 24, top: 8),
            height: 104,
            child: Material(
              borderRadius: BorderRadius.circular(12),
              color: Colors.deepPurple[400],
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: <Widget>[
                    Center(
                        child: Text(L('Select file', _model.localeAdapter),
                            style: GoogleFonts.andika(
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 24)))),
                    Container(
                      margin: EdgeInsets.all(16),
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: SvgPicture.asset(
                            'assets/icon_file.svg',
                          )),
                    )
                  ],
                ),
                onTap: () async {
                  var f = await FilePicker.getFile();
                  if (f != null && f.path != null && f.path.isNotEmpty) {
                    shareFile(
                        FileModel(data: f.path, type: FileTypeModel.file));
                  }
                },
              ),
            )),
        Row(
          children: <Widget>[
            if (Platform.isAndroid)
              Expanded(
                child: Container(
                    margin: EdgeInsets.only(left: 24, top: 8),
                    height: 48,
                    child: Material(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.deepPurple[400],
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        child: Center(
                            child: Text(L('App', _model.localeAdapter),
                                style: GoogleFonts.andika(
                                    textStyle: TextStyle(
                                        color: Colors.white, fontSize: 24)))),
                        onTap: () async {
                          var data = await showDialog(
                                  context: context,
                                  child: AppSelector(_model.localeAdapter))
                              as String;
                          if (data != null && data.isNotEmpty) {
                            var app = await DeviceApps.getApp(data);
                            shareFile(FileModel(
                                type: FileTypeModel.app,
                                data: app.apkFilePath,
                                name: app.appName));
                          }
                        },
                      ),
                    )),
              ),
            SizedBox(
              width: Platform.isAndroid ? 8 : 24,
            ),
            Expanded(
              child: Container(
                  margin: EdgeInsets.only(right: 24, top: 8),
                  height: 48,
                  child: Material(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.deepPurple[400],
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      child: Center(
                          child: Text(L('Text', _model.localeAdapter),
                              style: GoogleFonts.andika(
                                  textStyle: TextStyle(
                                      color: Colors.white, fontSize: 24)))),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            var c = TextEditingController();
                            return AlertDialog(
                              title: Text(
                                L('Type some text', _model.localeAdapter),
                                style: GoogleFonts.comfortaa(
                                    fontWeight: FontWeight.w700),
                              ),
                              content: TextField(
                                controller: c,
                                maxLines: null,
                                minLines: null,
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text(L('Close', _model.localeAdapter)),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                                FlatButton(
                                  child: Text(L('Send', _model.localeAdapter)),
                                  onPressed: () {
                                    Navigator.of(context).pop();

                                    if (c.text.isNotEmpty) {
                                      shareFile(FileModel(
                                          data: c.text,
                                          type: FileTypeModel.text));
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  )),
            ),
          ],
        ),
        SizedBox(
          height: 22,
        ),
        if (_latest != null && _latest.isNotEmpty)
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 24, right: 24),
                child: Text(
                  L('Latest', _model.localeAdapter),
                  style:
                      GoogleFonts.comfortaa(textStyle: TextStyle(fontSize: 24)),
                ),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(right: 24),
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
              padding: EdgeInsets.only(left: 24, right: 24),
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 16),
                  itemCount: _latest.length,
                  itemBuilder: (context, index) => card(_latest[index]))),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 18),
          height: 54,
          decoration: BoxDecoration(
              color: Colors.deepPurple[100],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24))),
          child: Row(
            children: <Widget>[
              Material(
                color: Colors.deepPurple[100],
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  splashColor: Colors.deepPurple[400],
                  child: Container(
                    margin: EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      'assets/icon_locale.svg',
                      semanticsLabel: 'locale',
                      height: 18,
                    ),
                  ),
                  onTap: () => _model.setPage(PageModel.language),
                ),
              ),
              SizedBox(width: 2),
              Material(
                color: Colors.deepPurple[100],
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  splashColor: Colors.deepPurple[400],
                  child: Container(
                    margin: EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      'assets/icon_help.svg',
                      semanticsLabel: 'help',
                      height: 16,
                    ),
                  ),
                  onTap: () => _model.setPage(PageModel.intro),
                ),
              ),
              SizedBox(width: 2),
              Material(
                color: Colors.deepPurple[100],
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    splashColor: Colors.deepPurple[400],
                    child: Container(
                      margin: EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        'assets/icon_receive.svg',
                        semanticsLabel: 'receive',
                        height: 16,
                      ),
                    ),
                    onTap: () {
                      var senders = <Sender>[];
                      var running = false;
                      var stop = false;
                      var n = 0;

                      //todo: check for ip wiser?
                      Future<String> getIpMask() async {
                        for (var interface in await NetworkInterface.list()) {
                          for (var addr in interface.addresses) {
                            if (addr.address.startsWith('192.168.')) {
                              return '192.168.0';
                            }
                            if (addr.address.startsWith('172.16.')) {
                              return '172.16.0';
                            }
                            if (addr.address.startsWith('10.')) {
                              return '10.0.0';
                            }
                          }
                        }
                        if (!stop) {
                          await Future.delayed(Duration(seconds: 1));
                          return getIpMask();
                        } else {
                          return null;
                        }
                      }

                      void portRunner(StateSetter setState) async {
                        if (stop) {
                          return;
                        }

                        running = true;

                        var port = ports[n % ports.length];

                        if (n % 4 == 0) {
                          await Future.delayed(Duration(seconds: 1));
                        }

                        if (senders.firstWhere(
                                (element) => element.n < n ~/ ports.length,
                                orElse: () => null) !=
                            null) {
                          setState(() {
                            senders.removeWhere(
                                (element) => element.n < n ~/ ports.length);
                          });
                        }

                        NetworkAnalyzer.discover2(
                          await getIpMask(),
                          port,
                          timeout: Duration(milliseconds: 500),
                        )..listen((addr) async {
                            if (addr.exists) {
                              //todo: proper deserialization

                              try {
                                var info = jsonDecode(await http.read(
                                    'http://${addr.ip}:$port/sharik.json'));

                                var sender = Sender(
                                    n: n ~/ ports.length,
                                    ip: addr.ip,
                                    type: info['type'],
                                    version: info['sharik'],
                                    name: info['name'],
                                    os: info['os'],
                                    url: 'http://${addr.ip}:$port');
                                var inArr = senders.firstWhere(
                                    (element) =>
                                        element.ip == sender.ip &&
                                        element.os == sender.os &&
                                        element.name == sender.name,
                                    orElse: () => null);

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
                              title: Text(L('Receiver', _model.localeAdapter),
                                  style: GoogleFonts.comfortaa(
                                      fontWeight: FontWeight.w700)),
                              content: StatefulBuilder(
                                builder: (_, StateSetter setState) {
                                  if (!running) {
                                    portRunner(setState);
                                  }

                                  return senders.isNotEmpty
                                      ? Container(
                                          height: 320,
                                          width: 120,
                                          child: ListView(
                                            shrinkWrap: true,
                                            children: senders
                                                .map((e) {
                                                  return ListTile(
                                                    onTap: () async {
                                                      if (await canLaunch(
                                                          e.url)) {
                                                        await launch(e.url);
                                                      }
                                                    },
                                                    subtitle: Text(e.os),
                                                    title: Text(e.name),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Center(
                                              child: Container(
                                                height: 28,
                                                width: 28,
                                                margin: EdgeInsets.all(4),
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            ),
                                          ],
                                        );
                                },
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(L('Close', _model.localeAdapter)),
                                )
                              ],
                            );
                          }).then((value) => stop = true);
                    }),
              ),
              Spacer(),
              Material(
                color: Colors.deepPurple[100],
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  splashColor: Colors.deepPurple[400],
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Text(
                      'v2.2',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.deepPurple[700],
                          fontFamily: 'JetBrainsMono'),
                    ),
                  ),
                  onTap: () {
                    //todo: refactor
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => FutureBuilder(
                            future: () async {
                              final info = await PackageInfo.fromPlatform();
                              var v = info.version.split('.')[0] +
                                  '.' +
                                  info.version.split('.')[1];

                              var response = await http.read(
                                  'https://marchello.cf/shas/versions?package=${info.packageName}&version=$v&platform=${Platform.operatingSystem}&platform_version=${Uri.encodeComponent(Platform.operatingSystemVersion)}');

                              return jsonDecode(response);
                            }(),
                            builder: (_, snapshot) => AlertDialog(
                                  title: Text(
                                    L('Updates', _model.localeAdapter),
                                    style: GoogleFonts.comfortaa(
                                        fontWeight: FontWeight.w700),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      !snapshot.hasData
                                          ? Container(
                                              child:
                                                  CircularProgressIndicator())
                                          : (snapshot.data['latest'] ||
                                                  !snapshot.data['ok']
                                              ? Text(L(
                                                  'The latest version is already installed',
                                                  _model.localeAdapter))
                                              : changelog(snapshot.data)),
                                    ],
                                  ),
                                  actions: [
                                    if (Platform.isAndroid &&
                                        snapshot.hasData &&
                                        snapshot.data['ok'] &&
                                        !snapshot.data['latest'])
                                      FlatButton(
                                        onPressed: () async {
                                          if (await canLaunch(
                                              'https://play.google.com/store/apps/details?id=dev.marchello.sharik')) {
                                            await launch(
                                                'https://play.google.com/store/apps/details?id=dev.marchello.sharik');
                                          }
                                        },
                                        child: Text('Play Store'),
                                      ),
                                    if (snapshot.hasData &&
                                        snapshot.data['ok'] &&
                                        !snapshot.data['latest'])
                                      FlatButton(
                                        onPressed: () async {
                                          if (await canLaunch(
                                              'https://github.com/marchellodev/sharik')) {
                                            await launch(
                                                'https://github.com/marchellodev/sharik');
                                          }
                                        },
                                        child: Text('GitHub'),
                                      ),
                                    FlatButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text(
                                          L('Close', _model.localeAdapter)),
                                    )
                                  ],
//                                  scrollable: true,
                                )));
                  },
                ),
              ),
              SizedBox(
                width: 2,
              ),
              Container(
                color: Colors.deepPurple[800],
                height: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 12),
                width: 1,
              ),
              SizedBox(
                width: 2,
              ),
              Material(
                color: Colors.deepPurple[100],
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  splashColor: Colors.deepPurple[400],
                  child: Container(
                    margin: EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      'assets/icon_browser.svg',
                      semanticsLabel: 'instagram',
                      height: 18,
                    ),
                  ),
                  onTap: () async {
                    if (await canLaunch('https://marchello.cf')) {
                      await launch('https://marchello.cf');
                    }
                  },
                ),
              ),
              SizedBox(
                width: 1,
              ),
              Material(
                color: Colors.deepPurple[100],
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  splashColor: Colors.deepPurple[400],
                  child: Container(
                    margin: EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      'assets/icon_github.svg',
                      semanticsLabel: 'play store',
                      height: 18,
                    ),
                  ),
                  onTap: () async {
                    if (await canLaunch(
                        'https://github.com/marchellodev/sharik')) {
                      await launch('https://github.com/marchellodev/sharik');
                    }
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget changelog(Map data) {
    var changes = <Widget>[];

    data['changelog'].forEach((element) {
      changes.add(Text(
        'v${element['version']}',
        style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 16),
      ));
      changes.add(SizedBox(
        height: 4,
      ));
      element['changes'].forEach((change) {
        changes.add(Text(' • $change',
            style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 14)));
        changes.add(SizedBox(
          height: 2,
        ));
      });
      changes.add(SizedBox(
        height: 10,
      ));
    });
    return Container(
        height: 360,
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            Row(
              children: [
                Container(
                    width: 160,
                    child: Text(
                      L('Current version', _model.localeAdapter) + ':',
                      style: GoogleFonts.andika(fontSize: 16),
                    )),
                SizedBox(
                  width: 4,
                ),
                Text(
                  'v${data['current_version']}',
                  style: TextStyle(fontFamily: 'JetBrainsMono'),
                )
              ],
            ),
            Row(
              children: [
                Container(
                    width: 160,
                    child: Text(
                      L('The latest version', _model.localeAdapter) + ':',
                      style: GoogleFonts.andika(fontSize: 16),
                    )),
                SizedBox(
                  width: 4,
                ),
                Text('v${data['latest_version']}',
                    style: TextStyle(fontFamily: 'JetBrainsMono'))
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Center(
              child: Text(
                L('Changelog', _model.localeAdapter),
                style: GoogleFonts.comfortaa(fontSize: 18),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: changes,
            ),
          ],
        ));
  }

  Widget card(FileModel f) {
    return Container(
      height: 44,
      margin: EdgeInsets.only(bottom: 12),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Colors.deepPurple[300],
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            shareFile(f);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                SvgPicture.asset(
                  f.icon,
                  semanticsLabel: 'file ',
                  width: 18,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                    child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    f.name,
                    style: GoogleFonts.andika(
                      textStyle: TextStyle(color: Colors.white, fontSize: 18),
                    ),
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
