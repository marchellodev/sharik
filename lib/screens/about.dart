import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
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
      body: GestureDetector(
        onHorizontalDragEnd: (DragEndDetails details) {
          if ((details.primaryVelocity ?? 0) > 0) {
            SharikRouter.navigateTo(
                context, this, Screens.home, RouteDirection.left);
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
                IconButton(
                    onPressed: () => SharikRouter.navigateTo(
                        context, this, Screens.home, RouteDirection.left),
                    icon: const Icon(Icons.arrow_back_ios))
              ],
            ),
            const SizedBox(height: 34),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Current version',
                    style:
                        TextStyle(fontFamily: 'JetBrainsMono', fontSize: 16)),
                const Text('3.0',
                    style:
                        TextStyle(fontFamily: 'JetBrainsMono', fontSize: 16)),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('The latest version',
                    style:
                        TextStyle(fontFamily: 'JetBrainsMono', fontSize: 16)),
                const Text('3.1',
                    style:
                        TextStyle(fontFamily: 'JetBrainsMono', fontSize: 16)),
              ],
            ),
            SizedBox(height: 18),
            //    splashColor: Colors.deepPurple.shade500.withOpacity(0.32),
            //           hoverColor: Colors.deepPurple.shade50.withOpacity(0.4),
            Row(
              children: [
                Expanded(
                  child: Material(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.deepPurple[400],
                    child: InkWell(
                      splashColor: Colors.deepPurple.shade100.withOpacity(0.32),
                      hoverColor: Colors.deepPurple.shade50.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      onTap: () async {},
                      child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          child: Text('Update',
                              style: TextStyle(
                                  fontFamily: 'JetBrainsMono',
                                  fontSize: 16,
                                  color: Colors.white))),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Material(
                    color: Colors.deepPurple[100],
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      splashColor: Colors.deepPurple[400]!.withOpacity(0.32),
                      onTap: () {},
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        child: Text(
                          'Changelog',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.deepPurple[700],
                              fontFamily: 'JetBrainsMono'),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 38),
            Text(
                'Sharik is completely free with its code published on GitHub.\nEveryone is welcomed to contribute :)',
                textAlign: TextAlign.center,
                style: GoogleFonts.getFont(context.l!.fontComfortaa,
                    fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    splashColor: Colors.deepPurple.shade400.withOpacity(0.32),
                    hoverColor: Colors.deepPurple.shade50,
                    onTap: () {},
                    child: Container(
                      alignment: Alignment.center,
                      width: 52,
                      height: 52,
                      child: SvgPicture.asset(
                        'assets/icons/social/github.svg',
                        width: 26,
                        color: Colors.deepPurple.shade300,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    splashColor: Colors.deepPurple.shade400.withOpacity(0.32),
                    hoverColor: Colors.deepPurple.shade50,
                    onTap: () {},
                    child: Container(
                      alignment: Alignment.center,
                      width: 52,
                      height: 52,
                      child: SvgPicture.asset(
                        'assets/icons/social/telegram.svg',
                        width: 26,
                        color: Colors.deepPurple.shade300,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text('Contributors',
                textAlign: TextAlign.center,
                style: GoogleFonts.getFont(context.l!.fontComfortaa,
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
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
                  '...',
                  '...',
                  '...',
                ),
              ],
            ),
            const SizedBox(height: 22),
          ],
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
                Text(fullName,
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.deepPurple.shade800,
                        letterSpacing: 0.2)),
                Text(role,
                    style: GoogleFonts.poppins(
                        color: Colors.grey.shade900,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 0.4)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
