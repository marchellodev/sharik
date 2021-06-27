import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../components/buttons.dart';
import '../components/logo.dart';
import '../components/page_router.dart';
import '../conf.dart';
import '../dialogs/changelog.dart';
import '../dialogs/licenses.dart';
import '../dialogs/open_dialog.dart';
import '../dialogs/policy.dart';
import '../logic/services/update_service.dart';
import '../utils/helper.dart';

// todo styles
// todo check fonts for consistency

// review: done
class AboutScreen extends StatelessWidget {
  final _updateService = UpdateService();
  final _globalKey = GlobalKey();

  void _exit(BuildContext context){
    SharikRouter.navigateTo(
         _globalKey, Screens.home, RouteDirection.left);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: Scaffold(
        body: WillPopScope(
          onWillPop: () {
           _exit(context);
            return Future.value(false);
          },
          child: GestureDetector(
            onHorizontalDragEnd: (DragEndDetails details) {
              if ((details.primaryVelocity ?? 0) > 0) {
              _exit(context);
              }
            },
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                const SafeArea(
                  bottom: false,
                  left: false,
                  right: false,
                  child: SizedBox(
                    height: 22,
                  ),
                ),
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
                          const Icon(LucideIcons.chevronLeft, size: 28),
                          () => _exit(context),
                          TransparentButtonBackground.def,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                LayoutBuilder(builder: (context, constraints) {
                  if (constraints.maxWidth < 720) {
                    return Column(
                      children: [
                        updatingLinksButtonsSection(context),
                        const SizedBox(height: 24),
                        contributorsSection(context),
                      ],
                    );
                  } else {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: updatingLinksButtonsSection(context)),
                        const SizedBox(width: 24),
                        Expanded(child: contributorsSection(context)),
                      ],
                    );
                  }
                }),
                const SizedBox(height: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // todo rename stuff similarly in other files
  Widget updatingLinksButtonsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ChangeNotifierProvider.value(
          value: _updateService,
          builder: (ctx, _) {
            ctx.watch<UpdateService>();

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(context.l.aboutInstalledVersion,
                        style: GoogleFonts.jetBrainsMono(fontSize: 16)),
                    Text(currentVersion,
                        style: GoogleFonts.jetBrainsMono(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(context.l.aboutLatestVersion,
                        style: GoogleFonts.jetBrainsMono(fontSize: 16)),
                    Text(
                        _updateService.latestVersion ??
                            context.l.aboutLatestVersionUnknown,
                        style: GoogleFonts.jetBrainsMono(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        height: 40,
                        loading:
                            _updateService.state == UpdateServiceState.loading,
                        text: _updateService.state == UpdateServiceState.none
                            ? context.l.aboutCheckForUpdates
                            : (_updateService.state ==
                                    UpdateServiceState.upgradable
                                ? context.l.aboutUpdate
                                : context.l.aboutNoUpdates),
                        font: 'JetBrains Mono',
                        fontSize: 16,
                        onClick:
                            _updateService.state != UpdateServiceState.loading
                                ? () {
                                    if (_updateService.state ==
                                        UpdateServiceState.upgradable) {
                                      launch(source2url(source));
                                      return;
                                    }
                                    _updateService.fetch();
                                  }
                                : null,
                        roundedRadius: 8,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // todo as a component
                    // todo styling
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: Material(
                          color: (_updateService.state ==
                                      UpdateServiceState.upgradable ||
                                  _updateService.state ==
                                      UpdateServiceState.latest)
                              ? Colors.deepPurple.shade100
                              : Colors.deepPurple.shade100.withOpacity(0.8),

                          // color: Colors.deepPurple.shade200,
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            // splashColor: Colors.deepPurple.shade400.withOpacity(0.32),
                            // splashColor: Colors.deepPurple.shade300.withOpacity(0.3),
                            // hoverColor: Colors.deepPurple.shade300.withOpacity(0.2),
                            splashColor:
                                Colors.deepPurple.shade300.withOpacity(0.28),
                            hoverColor:
                                Colors.deepPurple.shade300.withOpacity(0.14),

                            onTap: (_updateService.state ==
                                        UpdateServiceState.upgradable ||
                                    _updateService.state ==
                                        UpdateServiceState.latest)
                                ? () {
                                    openDialog(
                                        context,
                                        ChangelogDialog(
                                            _updateService.markdown!));
                                  }
                                : null,
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              child: Text(
                                context.l.aboutChangelog,
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 16,
                                  color: (_updateService.state ==
                                              UpdateServiceState.upgradable ||
                                          _updateService.state ==
                                              UpdateServiceState.latest)
                                      ? Colors.deepPurple.shade700
                                      : Colors.deepPurple.shade700
                                          .withOpacity(0.8),
                                ),
                              ),
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
        Text(context.l.aboutSharikText,
            textAlign: TextAlign.center,
            style: GoogleFonts.getFont(context.l.fontComfortaa, fontSize: 16)),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TransparentButton(
                Icon(LucideIcons.github,
                    size: 24, color: context.t.dividerColor), () {
              launch('https://github.com/marchellodev/sharik');
            }, TransparentButtonBackground.def),
            const SizedBox(width: 4),
            TransparentButton(
              Icon(LucideIcons.twitter,
                  size: 24, color: context.t.dividerColor),
              () {
                launch('https://twitter.com/sharik_foss');
              },
              TransparentButtonBackground.def,
            ),
            const SizedBox(width: 4),
            TransparentButton(
              Icon(LucideIcons.languages,
                  size: 24, color: context.t.dividerColor),
                  () {
                launch('https://crowdin.com/project/sharik');
              },
              TransparentButtonBackground.def,
            ),
          ],
        ),
        const SizedBox(height: 26),
        ListButton(
            Text(context.l.aboutOpenSourceLicenses,
                textAlign: TextAlign.center,
                style: GoogleFonts.jetBrainsMono(
                    fontSize: 15,
                    color: Colors.grey.shade50,
                    letterSpacing: 0.1)), () {
          openDialog(context, LicensesDialog());
          // showLicensePage(context: context, applicationName: 'Sharik');
        }),
        const SizedBox(height: 12),
        ListButton(
            Text(context.l.aboutTrackingPolicy,
                textAlign: TextAlign.center,
                style: GoogleFonts.jetBrainsMono(
                    fontSize: 15,
                    color: Colors.grey.shade50,
                    letterSpacing: 0.1)), () async {
          final file = await rootBundle.loadString('tracking_policy.md');

          openDialog(
              context,
              PolicyDialog(
                  markdown: file,
                  name: context.l.aboutTrackingPolicy,
                  url:
                      'https://github.com/marchellodev/sharik/blob/master/tracking_policy.md'));
        }),
        const SizedBox(height: 12),
        ListButton(
            Text(context.l.aboutPrivacyPolicy,
                textAlign: TextAlign.center,
                style: GoogleFonts.jetBrainsMono(
                    fontSize: 15,
                    color: Colors.grey.shade50,
                    letterSpacing: 0.1)), () async {
          final file = await rootBundle.loadString('privacy_policy.md');

          openDialog(
              context,
              PolicyDialog(
                  markdown: file,
                  name: context.l.aboutPrivacyPolicy,
                  url:
                      'https://github.com/marchellodev/sharik/blob/master/privacy_policy.md'));
        }),
      ],
    );
  }

  // todo should `Column` be replaced with `List<Widget>`?
  Widget contributorsSection(BuildContext context) {
    return Column(
      children: [
        Text(context.l.aboutContributors,
            textAlign: TextAlign.center,
            style: GoogleFonts.getFont(context.l.fontComfortaa,
                fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 14),
        Column(children: contributors.map((e) => _ContributorCard(e)).toList())
      ],
    );
  }
}

class _ContributorCard extends StatelessWidget {
  final Contributor _obj;

  const _ContributorCard(this._obj);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: ListButton(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_obj.name,
                    style: GoogleFonts.jetBrainsMono(
                        fontSize: 16,
                        color: Colors.grey.shade50,
                        letterSpacing: 0.1)),
                Text(contributorType2string(_obj.type),
                    style: GoogleFonts.poppins(
                        color: Colors.deepPurple.shade50,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 0.4)),
              ],
            ),
            () => launch('https://github.com/${_obj.githubNickname}')));
  }
}
