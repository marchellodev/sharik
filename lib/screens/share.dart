import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sharik/components/buttons.dart';
import 'package:sharik/components/logo.dart';
import 'package:sharik/components/page_router.dart';
import 'package:sharik/dialogs/open_dialog.dart';
import 'package:sharik/dialogs/select_network.dart';
import 'package:sharik/logic/services/ip_service.dart';
import 'package:sharik/logic/services/sharing_service.dart';
import 'package:wakelock/wakelock.dart';

import '../conf.dart';
import '../models/file.dart';
import '../utils/helper.dart';

class SharingScreen extends StatefulWidget {
  final FileModel file;

  const SharingScreen(this.file);

  @override
  State<StatefulWidget> createState() {
    return ShareState();
  }
}

class ShareState extends State<SharingScreen> with TickerProviderStateMixin {
  late AnimationController _conController;
  late Animation<double> _conAnimation;

  late FileModel _file;

  final LocalIpService _ipService = LocalIpService();
  late SharingService _sharingService;

  bool _stateShowQr = false;

  @override
  void dispose() {
    // todo dispose services on exit

    if (_conController.isAnimating) _conController.stop();

    if (!Platform.isLinux) {
      Wakelock.disable();
    }

    super.dispose();
  }

  @override
  void initState() {
    // todo init stuff in a separate method
    _file = widget.file;

    _ipService.load();

    _sharingService = SharingService(_file);
    _sharingService.start();

    _conController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _conAnimation = Tween(begin: 0.0, end: pi).animate(_conController);

    if (!Platform.isLinux) {
      Wakelock.enable();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          SharikRouter.navigateTo(
              context, context.widget, Screens.home, RouteDirection.left);

          return Future.value(false);
        },
        child: GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) {
            if ((details.primaryVelocity ?? 0) > 0) {
              SharikRouter.navigateTo(
                  context, context.widget, Screens.home, RouteDirection.left);
            }
          },
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              const SafeArea(child: SizedBox(height: 28)),
              Stack(
                children: [
                  Hero(
                    tag: 'icon',
                    child: SharikLogo(),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TransparentButton(
                          const Icon(FeatherIcons.chevronLeft, size: 28),
                          () => SharikRouter.navigateTo(context, context.widget,
                              Screens.home, RouteDirection.left),
                          TransparentButtonBackground.purpleDark),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 34),
              Container(
                height: 46,
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          _file.data.toString(),
                          style: GoogleFonts.getFont(
                            'Andika',
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.deepPurple[400],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 16, top: 16),
                        child: Icon(FeatherIcons.wifi,
                            color: Colors.grey.shade50, size: 16)),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: ChangeNotifierProvider.value(
                          value: _ipService,
                          builder: (context, _) {
                            context.watch<LocalIpService>();
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      connectivity2string(
                                          _ipService.getConnectivityType()),
                                      style: GoogleFonts.getFont(
                                        'Andika',
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                        style: GoogleFonts.getFont(
                                          'Andika',
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                        children: [
                                          const TextSpan(text: 'Connect to'),
                                          if (Platform.isAndroid ||
                                              Platform.isIOS)
                                            TextSpan(
                                                text: ' Wi-Fi ',
                                                style: TextStyle(
                                                    color: false
                                                        ? Colors.green[100]
                                                        : Colors.red[100]))
                                          else
                                            const TextSpan(text: ' Wi-Fi '),
                                          const TextSpan(text: 'or set up a'),
                                          if (Platform.isAndroid ||
                                              Platform.isIOS)
                                            TextSpan(
                                                text: ' Mobile Hotspot',
                                                style: TextStyle(
                                                    color: false
                                                        ? Colors.green[100]
                                                        : Colors.red[100]))
                                          else
                                            const TextSpan(
                                                text: ' Mobile Hotspot'),
                                        ]),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                ]);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    // todo do not use pure white
                    TransparentButton(
                        AnimatedBuilder(
                            animation: _conAnimation,
                            builder: (context, child) {
                              return Transform.rotate(
                                  angle: _conAnimation.value, child: child);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(1),
                              child: Icon(FeatherIcons.refreshCw,
                                  size: 14, color: Colors.grey.shade100),
                            )), () {
                      _conController.forward(from: 0);
                      _ipService.load();
                    }, TransparentButtonBackground.purpleDark),
                  ],
                ),
              ),
              const SizedBox(height: 38),
              const SizedBox(height: 38),
              Center(
                  child: Text(
                'Now open this link\nin any browser',
                style: GoogleFonts.getFont(
                  'Comfortaa',
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              )),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurple[400],
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                child: MultiProvider(
                  providers: [
                    ChangeNotifierProvider.value(value: _ipService),
                    ChangeNotifierProvider.value(value: _sharingService),
                  ],
                  builder: (context, _) {
                    context.watch<LocalIpService>();
                    context.watch<SharingService>();

                    return Row(
                      children: <Widget>[
                        const SizedBox(
                          width: 14,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              'http://${_ipService.getIp()}:${_sharingService.port ?? 'loading'}',
                              // todo translate loading

                              // todo remove TextStyle
                              style: GoogleFonts.getFont('Andika',
                                  color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        // todo fix the splash color
                        TransparentButton(
                            const Icon(Icons.qr_code_outlined,
                                size: 17, color: Colors.white),
                            () => setState(() => _stateShowQr = !_stateShowQr),
                            TransparentButtonBackground.purpleDark),

                        TransparentButton(
                            const Icon(FeatherIcons.copy,
                                size: 16, color: Colors.white), () {
                          Clipboard.setData(
                                  ClipboardData(text: _ipService.getIp()))
                              .then((result) {
                            final snackBar = SnackBar(
                              backgroundColor: Colors.deepPurple[500],
                              duration: const Duration(seconds: 1),
                              content: Text(
                                'Copied to Clipboard',
                                style: GoogleFonts.getFont('Andika',
                                    color: Colors.white),
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          });
                        }, TransparentButtonBackground.purpleDark),
                        TransparentButton(
                            const Icon(FeatherIcons.server,
                                size: 16, color: Colors.white), () {
                          // todo make sure we have loaded the interfaces
                          openDialog(context, PickNetworkDialog(_ipService));
                        }, TransparentButtonBackground.purpleDark),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 38),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: _stateShowQr
                    ? MediaQuery.of(context).size.width - 24 * 2
                    : 0,
                child: Center(
                  child: QrImage(
                    data: 'http://168.192.0.101:50500',
                    foregroundColor: context.t.textTheme.button!.color,
                  ),
                ),
              ),
              const SizedBox(height: 38),
              const SizedBox(height: 38),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.deepPurple.shade300,
                ),
                child: Text(
                  'The recipient needs to be connected\nto the same network',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont('Andika',
                      color: Colors.white, fontSize: 18),
                ),
              ),
              const SizedBox(height: 38),
              SizedBox(
                child: SafeArea(
                  top: false,
                  right: false,
                  left: false,
                  child: Container(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
