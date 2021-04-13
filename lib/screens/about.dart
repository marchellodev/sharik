import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sharik/components/buttons.dart';
import 'package:sharik/components/logo.dart';
import 'package:sharik/components/page_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../conf.dart';
import '../utils/helper.dart';

// todo check fonts for consistence
class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          SharikRouter.navigateTo(context, context.widget, Screens.home, RouteDirection.left);

          return Future.value(false);
        },
        child: GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) {
            if ((details.primaryVelocity ?? 0) > 0) {
              SharikRouter.navigateTo(context, this, Screens.home, RouteDirection.left);
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
                        () => SharikRouter.navigateTo(context, this, Screens.home, RouteDirection.left),
                        TransparentButtonBackground.def,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 34),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Current version', style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 16)),
                  const Text('3.0', style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 16)),
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('The latest version', style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 16)),
                  const Text('3.1', style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 16)),
                ],
              ),
              SizedBox(height: 18),
              //    splashColor: Colors.deepPurple.shade500.withOpacity(0.32),
              //           hoverColor: Colors.deepPurple.shade50.withOpacity(0.4),

              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      height: 40,
                      text: 'Update',
                      font: 'JetBrainsMono',
                      onClick: () {},
                      roundedRadius: 8,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Material(
                      color: Colors.deepPurple.shade100,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        // splashColor: Colors.deepPurple.shade400.withOpacity(0.32),
                        // splashColor: Colors.deepPurple.shade300.withOpacity(0.3),
                        // hoverColor: Colors.deepPurple.shade300.withOpacity(0.2),
                        splashColor: Colors.deepPurple.shade300.withOpacity(0.28),
                        hoverColor: Colors.deepPurple.shade300.withOpacity(0.14),
                        onTap: () {},
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          child: Text(
                            'Changelog',
                            style: TextStyle(fontSize: 16, color: Colors.deepPurple[700], fontFamily: 'JetBrainsMono'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 42),
              Text('Sharik is completely free with its code published on GitHub.\nEveryone is welcomed to contribute ̚  ( ဖဖ)',
                  textAlign: TextAlign.center, style: GoogleFonts.getFont(context.l.fontComfortaa, fontSize: 16)),
              const SizedBox(height: 4),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TransparentButton(
                      Icon(FeatherIcons.github, size: 24, color: context.t.dividerColor), () {}, TransparentButtonBackground.def),
                  const SizedBox(width: 4),
                  TransparentButton(
                    SvgPicture.asset(
                      'assets/icons/social/telegram.svg',
                      width: 24,
                      height: 24,
                      color: context.t.dividerColor,
                    ),
                    () {},
                    TransparentButtonBackground.def,
                  ),
                ],
              ),
              const SizedBox(height: 34),
              Text('Contributors',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(context.l.fontComfortaa, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              Column(
                children: const [
                  _ContributorCard(
                    'Mark Motliuk',
                    'marchellodev',
                    'Maintainer',
                  ),
                  _ContributorCard(
                    'Behzad Najafzadeh',
                    'behzad-njf',
                    'Translator',
                  ),
                  _ContributorCard(
                    'Atrate',
                    'atrate',
                    'Translator',
                  ),
                  _ContributorCard(
                    '...',
                    '...',
                    '...',
                  ),
                  _ContributorCard(
                    '...',
                    '...',
                    '...',
                  ),
                  _ContributorCard(
                    '归零幻想',
                    '...',
                    '...',
                  ),
                ],
              ),
              const SizedBox(height: 22),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContributorCard extends StatelessWidget {
  final String fullName;
  final String nickName;
  final String role;

  const _ContributorCard(this.fullName, this.nickName, this.role);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: ListButton(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(fullName, style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 16, color: Colors.grey.shade50, letterSpacing: 0.1)),
                Text(role,
                    style: GoogleFonts.poppins(
                        color: Colors.deepPurple.shade50, fontSize: 16, fontStyle: FontStyle.italic, letterSpacing: 0.4)),
              ],
            ),
            () => launch('https://github.com/$nickName')));
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: context.t.buttonColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.deepPurple.shade500.withOpacity(0.32),
          hoverColor: Colors.deepPurple.shade50.withOpacity(0.4),
          onTap: () => launch('https://github.com/$nickName'),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(fullName, style: GoogleFonts.poppins(fontSize: 16, color: Colors.deepPurple.shade800, letterSpacing: 0.2)),
                Text(role,
                    style: GoogleFonts.poppins(color: Colors.grey.shade900, fontSize: 16, fontStyle: FontStyle.italic, letterSpacing: 0.4)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
