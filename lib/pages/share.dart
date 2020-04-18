import 'dart:async';
import 'dart:io';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wifi_iot/wifi_iot.dart';

import '../locale.dart';
import '../models/app.dart';
import '../models/file.dart';

class SharePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ShareState();
  }
}

class ShareState extends State<SharePage> with TickerProviderStateMixin {
  AnimationController ipController;
  Animation ipAnimation;
  AnimationController conController;
  Animation conAnimation;

  AppModel model;
  FileModel file;

  String ip;
  String network;
  bool wifi = false;
  bool tether = false;
  int port = 0;
  HttpServer server;

  Future<int> getUnusedPort([InternetAddress address]) {
    return HttpServer.bind(address ?? InternetAddress.anyIPv4, 0)
        .then((socket) {
      var port = socket.port;
      socket.close();
      return port;
    });
  }

  void serve() async {
    await for (var request in server) {
      if (file.type == FileTypeModel.file || file.type == FileTypeModel.app) {
        var f = File(file.data);
        var size = await f.length();

        request.response.headers.contentType =
            ContentType('application', 'octet-stream', charset: 'utf-8');

        request.response.headers.add(
          'Content-Transfer-Encoding',
          'Binary',
        );

        request.response.headers.add(
          'Content-disposition',
          'attachment; filename=' +
              Uri.encodeComponent(file.type == FileTypeModel.file
                  ? file.name
                  : file.name + '.apk'),
        );
        request.response.headers.add(
          'Content-length',
          size,
        );

        await f.openRead().pipe(request.response).catchError((e) {}).then((a) {
          request.response.close();
        });
      } else {
        request.response.headers.contentType =
            ContentType('text', 'plain', charset: 'utf-8');
        request.response.write(file.data);
        await request.response.close();
      }
    }
  }

  Future getIp() async {
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.address.startsWith('192.168.')) {
          return addr.address;
        }
        if (addr.address.startsWith('10.')) {
          return addr.address;
        }
        if (addr.address.startsWith('172.16.')) {
          return addr.address;
        }
      }
    }
  }

  void updIp() async {
    setState(() {
      ip = L.get('loading...', model.locale);
    });
    ipController.repeat();

    await Future.delayed(const Duration(milliseconds: 500), () {});
    String _ip = await getIp();

    if (port == 0 && _ip != null) {
      server = await HttpServer.bind(InternetAddress(_ip), 0, shared: true);
      port = server.port;
      serve();
    }
    setState(() {
      ip = 'http://$_ip:$port';
    });

    ipController.stop();
  }

  void updCon() async {
    setState(() {
      network = L.get('loading...', model.locale);
      wifi = false;
      tether = false;
    });
    conController.repeat();

    var w = false;
    var t = false;

    if (Platform.isAndroid) {
      w = await WiFiForIoTPlugin.isConnected();
      t = await WiFiForIoTPlugin.isWiFiAPEnabled();
    }

    await Future.delayed(const Duration(milliseconds: 500), () {});
    setState(() {
      wifi = w;
      tether = t;
      if (!Platform.isAndroid) {
        network = L.get('undefined', model.locale);
      } else if (w) {
        network = 'Wi-Fi';
      } else if (t) {
        network = L.get('Mobile Hotspot', model.locale);
      } else {
        network = L.get('Not connected', model.locale);
      }
    });
    conController.stop();

    updIp();
  }

  @override
  void dispose() {
    if (server != null) server.close();

    if (conController.isAnimating) conController.stop();

    if (ipController.isAnimating) ipController.stop();

    super.dispose();
  }

  @override
  void initState() {
    model = Provider.of<AppModel>(context, listen: false);
    file = model.file;

    ip = L.get('loading...', model.locale);
    network = L.get('loading...', model.locale);

    ipController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    ipAnimation = Tween(begin: 0, end: 2 * pi).animate(ipController);

    conController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    conAnimation = Tween(begin: 0, end: 2 * pi).animate(conController);

    updCon();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 24, right: 24, top: 16),
      child: Column(
        children: <Widget>[
          Container(
            height: 46,
            margin: EdgeInsets.only(bottom: 18),
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.deepPurple[400],
            ),
            child: Row(
              children: <Widget>[
                SvgPicture.asset(
                  file.icon,
                  //todo: add semantics stuff everywhere
                  semanticsLabel: 'file',
                  width: 18,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      file.name,
                      style: GoogleFonts.andika(
                        textStyle: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      maxLines: 1,
                    ),
                  ),
                )
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.only(bottom: 18),
//            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.deepPurple[400],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 16),
                  margin: EdgeInsets.only(top: 18),
                  child: SvgPicture.asset(
                    'assets/icon_network.svg',
                    semanticsLabel: 'network ',
//                  height: 16,
                    width: 18,
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Container(
//                                padding: EdgeInsets.symmetric(horizontal: 16),

                    margin: EdgeInsets.only(top: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              network,
                              style: GoogleFonts.andika(
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                                style: GoogleFonts.andika(
                                  textStyle: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                children: [
                                  TextSpan(
                                      text: L.get('Connect to', model.locale)),
                                  Platform.isAndroid
                                      ? TextSpan(
                                          text: ' Wi-Fi ',
                                          style: TextStyle(
                                              color: wifi
                                                  ? Colors.green[100]
                                                  : Colors.red[100]))
                                      : TextSpan(text: ' Wi-Fi '),
                                  TextSpan(
                                      text: L.get('or enable', model.locale) +
                                          ' '),
                                  Platform.isAndroid
                                      ? TextSpan(
                                          text: L.get('enable Mobile Hotspot',
                                              model.locale),
                                          style: TextStyle(
                                              color: tether
                                                  ? Colors.green[100]
                                                  : Colors.red[100]))
                                      : TextSpan(
                                          text: L.get('enable Mobile Hotspot',
                                              model.locale)),
                                ]),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                        ]),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Material(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.deepPurple[400],
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      updCon();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                      child: AnimatedBuilder(
                        animation: conAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                              angle: conAnimation.value / 1, child: child);
                        },
                        child: SvgPicture.asset(
                          'assets/icon_update.svg',
                          semanticsLabel: 'update ',
                          height: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

//                              SizedBox(height: 16,),
          Spacer(),
          Center(
              child: Text(
            L.get('Now open', model.locale),
            style: GoogleFonts.comfortaa(
                textStyle: TextStyle(
              fontSize: 20,
            )),
            textAlign: TextAlign.center,
          )),

          Container(
            decoration: BoxDecoration(
              color: Colors.deepPurple[400],
              borderRadius: BorderRadius.circular(12),
            ),
            height: 42,
            margin: EdgeInsets.symmetric(horizontal: 2, vertical: 18),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      ip,
                      style: GoogleFonts.andika(
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 6,
                ),

                Material(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.deepPurple[400],
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      ClipboardManager.copyToClipBoard(ip).then((result) {
                        final snackBar = SnackBar(
                          backgroundColor: Colors.deepPurple[500],
                          duration: Duration(seconds: 1),
                          content: Text(
                            L.get('copied', model.locale),
                            style: GoogleFonts.andika(color: Colors.white),
                          ),
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                      child: SvgPicture.asset(
                        'assets/icon_copy.svg',
                        semanticsLabel: 'update',
                        width: 16,
                      ),
                    ),
                  ),
                ),
                Material(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.deepPurple[400],
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      updIp();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                      child: AnimatedBuilder(
                        animation: ipAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                              angle: ipAnimation.value / 1, child: child);
                        },
                        child: SvgPicture.asset(
                          'assets/icon_update.svg',
                          semanticsLabel: 'update ',
                          height: 16,
                        ),
                      ),
                    ),
                  ),
                ),
//                SizedBox(
//                  width: 12,
//                ),
              ],
            ),
          ),
          Spacer(),

          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 18),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.deepPurple[300],
            ),
            child: Text(
              L.get('The recipient', model.locale),
              textAlign: TextAlign.center,
              style: GoogleFonts.andika(
                textStyle: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
