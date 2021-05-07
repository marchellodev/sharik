import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sharik/components/buttons.dart';
import 'package:sharik/components/logo.dart';
import 'package:sharik/components/page_router.dart';
import 'package:sharik/dialogs/changelog.dart';
import 'package:sharik/dialogs/licenses.dart';
import 'package:sharik/dialogs/open_dialog.dart';
import 'package:sharik/logic/services/update_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../conf.dart';
import '../utils/helper.dart';

// todo check fonts for consistence
class AboutScreen extends StatelessWidget {
  final updateService = UpdateService();

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
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TransparentButton(
                        const Icon(FeatherIcons.chevronLeft, size: 28),
                        () => SharikRouter.navigateTo(
                            context, this, Screens.home, RouteDirection.left),
                        TransparentButtonBackground.def,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 34),
              ChangeNotifierProvider.value(
                value: updateService,
                builder: (ctx, _) {
                  ctx.watch<UpdateService>();

                  print('upd');
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Current version',
                              style: TextStyle(
                                  fontFamily: 'JetBrainsMono', fontSize: 16)),
                          const Text(currentVersion,
                              style: TextStyle(
                                  fontFamily: 'JetBrainsMono', fontSize: 16)),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('The latest version',
                              style: TextStyle(
                                  fontFamily: 'JetBrainsMono', fontSize: 16)),
                          Text(updateService.latestVersion ?? 'unknown',
                              style: TextStyle(
                                  fontFamily: 'JetBrainsMono', fontSize: 16)),
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
                              loading: updateService.state ==
                                  UpdateServiceState.loading,
                              text:
                                  updateService.state == UpdateServiceState.none
                                      ? 'Check updates'
                                      : (updateService.state ==
                                              UpdateServiceState.upgradable
                                          ? 'Update'
                                          : 'No updates'),
                              font: 'JetBrainsMono',
                              onClick: updateService.state !=
                                      UpdateServiceState.loading
                                  ? () {
                                      if (updateService.state ==
                                          UpdateServiceState.upgradable) {
                                        launch(source2url(source));
                                        return;
                                      }
                                      updateService.fetch();
                                    }
                                  : null,
                              roundedRadius: 8,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // todo as a component
                          // todo display when the button is disabled
                          Expanded(
                            child: Material(
                              color: Colors.deepPurple.shade100,
                              borderRadius: BorderRadius.circular(8),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                // splashColor: Colors.deepPurple.shade400.withOpacity(0.32),
                                // splashColor: Colors.deepPurple.shade300.withOpacity(0.3),
                                // hoverColor: Colors.deepPurple.shade300.withOpacity(0.2),
                                splashColor: Colors.deepPurple.shade300
                                    .withOpacity(0.28),
                                hoverColor: Colors.deepPurple.shade300
                                    .withOpacity(0.14),

                                onTap: (updateService.state ==
                                            UpdateServiceState.upgradable ||
                                        updateService.state ==
                                            UpdateServiceState.latest)
                                    ? () {
                                        openDialog(
                                            context,
                                            ChangelogDialog(
                                                updateService.markdown!));
                                      }
                                    : null,
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
                    ],
                  );
                },
              ),
              const SizedBox(height: 42),
              Text(
                  'Sharik is completely free with its code published on GitHub.\nEveryone is welcomed to contribute :>',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(context.l.fontComfortaa,
                      fontSize: 16)),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TransparentButton(
                      Icon(FeatherIcons.github,
                          size: 24, color: context.t.dividerColor),
                      () {},
                      TransparentButtonBackground.def),
                  const SizedBox(width: 4),
                  TransparentButton(
                    SvgPicture.asset(
                      'assets/icons/social/telegram.svg',
                      width: 23,
                      height: 23,
                      color: context.t.dividerColor,
                    ),
                    () {},
                    TransparentButtonBackground.def,
                  ),
                ],
              ),
              const SizedBox(height: 34),
              ListButton(
                  Text('Open Source Licenses',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 15,
                          color: Colors.grey.shade50,
                          letterSpacing: 0.1)), () {
                openDialog(context, LicensesDialog());
                // showLicensePage(context: context, applicationName: 'Sharik');
              }),
              const SizedBox(height: 22),
              Text('Contributors',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(context.l.fontComfortaa,
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              Column(
                  children:
                      contributors.map((e) => _ContributorCard(e)).toList()),
              const SizedBox(height: 22),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContributorCard extends StatelessWidget {
  final Contributor obj;

  const _ContributorCard(this.obj);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: ListButton(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(obj.name,
                    style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 16,
                        color: Colors.grey.shade50,
                        letterSpacing: 0.1)),
                Text(contributorType2string(obj.type),
                    style: GoogleFonts.poppins(
                        color: Colors.deepPurple.shade50,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 0.4)),
              ],
            ),
            () => launch('https://github.com/${obj.githubNickname}')));
  }
}
