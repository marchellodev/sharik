import 'dart:io';

import 'package:device_apps/device_apps.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sharik/models/app.dart';
import 'package:sharik/models/page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../locale.dart';
import '../main.dart';
import 'app_selector.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var latest = [];
  AppModel model;

  @override
  void initState() {
    model = Provider.of<AppModel>(context, listen: false);
    pref();
    super.initState();
  }

  void pref() {
    setState(() => latest = latestBox.get('data', defaultValue: []));
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
                        child: Text(L.get('Select file', model.locale),
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
                  File f = await FilePicker.getFile();
                  if (f != null && f.path != null && f.path.length > 0) {
                    file = ['file', f.path];

                    setState(() {
                      if (latest.contains(file)) latest.remove(file);

                      latest.insert(0, file);
                    });

                    latestBox.put('data', latest);

                    model.setState(() => model.setPage(PageModel.sharing));
                  }
                },
              ),
            )),
        Row(
          children: <Widget>[
            Platform.isAndroid
                ? Expanded(
                    child: Container(
                        margin: EdgeInsets.only(left: 24, top: 8),
                        height: 48,
                        child: Material(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.deepPurple[400],
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            child: Center(
                                child: Text(L.get('App', model.locale),
                                    style: GoogleFonts.andika(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24)))),
                            onTap: () async {
                              showDialog(
                                  context: context,
                                  child: AppSelector((String selected) async {
                                    Application app =
                                        await DeviceApps.getApp(selected);
                                    file = [
                                      'app',
                                      [
                                        app.appName,
                                        app.packageName,
                                        app.apkFilePath
                                      ]
                                    ];

                                    setState(() {
                                      if (latest.contains(file))
                                        latest.remove(file);

                                      latest.insert(0, file);
                                    });

                                    latestBox.put('data', latest);

                                    model.setState(
                                        () => model.setPage(PageModel.sharing));
                                  }));
                            },
                          ),
                        )),
                  )
                : Container(),
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
                          child: Text(L.get('Text', model.locale),
                              style: GoogleFonts.andika(
                                  textStyle: TextStyle(
                                      color: Colors.white, fontSize: 24)))),
                      onTap: () {
                        // flutter defined function
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            TextEditingController c = TextEditingController();
                            return AlertDialog(
                              title: Text(L.get('Type text', model.locale)),
                              content: TextField(
                                controller: c,
                                maxLines: null,
                                minLines: null,
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text(L.get('Close', model.locale)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text(L.get('Send', model.locale)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    file = ['text', c.text];

                                    if (file[1].length == 0) return;

                                    setState(() {
                                      if (latest.contains(file))
                                        latest.remove(file);

                                      latest.insert(0, file);
                                    });

                                    latestBox.put('data', latest);

                                    model.setState(
                                        () => model.setPage(PageModel.sharing));
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
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 24, right: 24),
              child: Text(
                L.get('Latest', model.locale),
                style:
                    GoogleFonts.comfortaa(textStyle: TextStyle(fontSize: 24)),
              ),
            ),
            Spacer(),
            Container(
              margin: EdgeInsets.only(right: 24),
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      latest.clear();
                    });

                    latestBox.put('data', latest);
                  },
                  icon: Icon(
                    Icons.delete,
                    size: 20,
                  )),
            )
          ],
        ),
        Expanded(
          child: Container(
              padding: EdgeInsets.only(left: 24, right: 24),
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 16),
                  itemCount: latest.length,
                  itemBuilder: (context, index) => card(latest[index]))),
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
                  onTap: () => model.setPage(PageModel.language),
                ),
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
                      'assets/icon_help.svg',
                      semanticsLabel: 'help',
                      height: 16,
                    ),
                  ),
                  onTap: () => model.setPage(PageModel.intro),
                ),
              ),
              Spacer(),
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
                    if (await canLaunch('https://marchello.cf'))
                      await launch('https://marchello.cf');
                  },
                ),
              ),
              SizedBox(
                width: 2,
              ),
              Container(
                color: Colors.deepPurple[700],
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
                      'assets/icon_github.svg',
                      semanticsLabel: 'play store',
                      height: 18,
                    ),
                  ),
                  onTap: () async {
                    if (await canLaunch(
                        'https://github.com/marchellodev/sharik'))
                      await launch('https://github.com/marchellodev/sharik');
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget card(List f) {
    List<String> s = getIconText(f);
    String icon = s[0];
    String text = s[1];
    return Container(
      height: 44,
      margin: EdgeInsets.only(bottom: 12),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Colors.deepPurple[300],
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            file = f;

            if (f.length == 0) {
              latest.remove(file);
              return;
            }

            setState(() {
              if (latest.contains(file)) latest.remove(file);

              latest.insert(0, file);
            });

            latestBox.put('data', latest);

            model.setState(() => model.setPage(PageModel.sharing));
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                SvgPicture.asset(
                  icon,
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
                    text,
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

List<String> getIconText(List f) {
  String icon;
  String text;

  switch (f[0]) {
    case 'file':
      icon = 'assets/icon_folder2.svg';
      text = (Platform.isAndroid
          ? f[1].split(Platform.isWindows ? '\\' : '/').last
          : f[1]);
      break;
    case 'text':
      icon = 'assets/icon_file_word.svg';
      text = f[1].replaceAll('\n', ' ');
      break;
    case 'app':
      icon = 'assets/icon_file_app.svg';
      text = f[1][0];
      break;
  }
  return [icon, text];
}
