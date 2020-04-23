import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pedantic/pedantic.dart';
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
  AnimationController _ipController;
  Animation _ipAnimation;
  AnimationController _conController;
  Animation _conAnimation;

  AppModel _model;
  FileModel _file;

  String ip;
  String network;
  bool wifi = false;
  bool tether = false;
  int port = 0;
  HttpServer _server;

  Future<bool> _isPortFree(int port) async {
    try {
      var _ = await HttpServer.bind(InternetAddress.anyIPv4, port);
      await _.close(force: true);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> _getPort() async {
    final ports = [50500, 50050, 60060, 60600, 56789, 62200];

    for (final port in ports) {
      if (await _isPortFree(port)) {
        return port;
      }
    }

    var _ = await HttpServer.bind(InternetAddress.anyIPv4, 0);
    await _.close(force: true);
    return _.port;
  }

  void serve() async {
    await for (var request in _server) {
      if (_file.type == FileTypeModel.file || _file.type == FileTypeModel.app) {
        var f = File(_file.data);
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
              Uri.encodeComponent(_file.type == FileTypeModel.file
                  ? _file.name
                  : _file.name + '.apk'),
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
        request.response.write(_file.data);
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
    setState(() => ip = L('loading...', _model.localeAdapter));

    if (!_ipController.isAnimating) {
      unawaited(_ipController.forward().then((value) => _ipController.reset()));
    }

    String _ip = await getIp();

    if (port == 0 && _ip != null) {
      port = await _getPort();
      _server = await HttpServer.bind(InternetAddress.anyIPv4, port);
      serve();
    }
    setState(() => ip = 'http://$_ip:$port');
  }

  void updCon() async {
    setState(() {
      network = L('loading...', _model.localeAdapter);
      wifi = false;
      tether = false;
    });
    if (!_ipController.isAnimating) {
      unawaited(
          _conController.forward().then((value) => _conController.reset()));
    }

    var w = false;
    var t = false;

    if (Platform.isAndroid) {
      w = await WiFiForIoTPlugin.isConnected();
      t = await WiFiForIoTPlugin.isWiFiAPEnabled();
    }

    setState(() {
      wifi = w;
      tether = t;
      if (!Platform.isAndroid) {
        network = L('Undefined', _model.localeAdapter);
      } else if (w) {
        network = 'Wi-Fi';
      } else if (t) {
        network = L('Mobile Hotspot', _model.localeAdapter);
      } else {
        network = L('Not connected', _model.localeAdapter);
      }
    });
    updIp();
  }

  @override
  void dispose() {
    if (_server != null) _server.close();

    if (_conController.isAnimating) _conController.stop();

    if (_ipController.isAnimating) _ipController.stop();

    super.dispose();
  }

  @override
  void initState() {
    _model = Provider.of<AppModel>(context, listen: false);
    _file = _model.file;

    ip = L('loading...', _model.localeAdapter);
    network = L('loading...', _model.localeAdapter);

    _ipController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _ipAnimation = Tween(begin: 0, end: pi).animate(_ipController);

    _conController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _conAnimation = Tween(begin: 0, end: pi).animate(_conController);

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
                  _file.icon,
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
                      _file.name,
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
                    width: 18,
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Container(
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
                                      text: L(
                                          'Connect to', _model.localeAdapter)),
                                  Platform.isAndroid
                                      ? TextSpan(
                                          text: ' Wi-Fi ',
                                          style: TextStyle(
                                              color: wifi
                                                  ? Colors.green[100]
                                                  : Colors.red[100]))
                                      : TextSpan(text: ' Wi-Fi '),
                                  TextSpan(
                                      text: L(
                                          'or set up a', _model.localeAdapter)),
                                  Platform.isAndroid
                                      ? TextSpan(
                                          text: L(' Mobile Hotspot',
                                              _model.localeAdapter),
                                          style: TextStyle(
                                              color: tether
                                                  ? Colors.green[100]
                                                  : Colors.red[100]))
                                      : TextSpan(
                                          text: L(' Mobile Hotspot',
                                              _model.localeAdapter)),
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
                        animation: _conAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                              angle: _conAnimation.value / 1, child: child);
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
          Spacer(),
          Center(
              child: Text(
            L('Now open this link', _model.localeAdapter) +
                '\n' +
                L('in any browser', _model.localeAdapter),
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
                            L('Copied to Clipboard', _model.localeAdapter),
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
                        animation: _ipAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                              angle: _ipAnimation.value / 1, child: child);
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
              L('The recipient needs to be connected', _model.localeAdapter) +
                  '\n' +
                  L('to the same network', _model.localeAdapter),
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
