import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../components/buttons.dart';
import '../components/logo.dart';
import '../components/page_router.dart';
import '../conf.dart';
import '../dialogs/open_dialog.dart';
import '../dialogs/tracking_consent.dart';
import '../logic/theme.dart';
import '../utils/helper.dart';

// todo tweak colors
// todo checkboxes look weird

class SettingsScreen extends StatelessWidget {
  final _globalKey = GlobalKey();

  void _exit(BuildContext context) {
    SharikRouter.navigateTo(_globalKey, Screens.home, RouteDirection.left);
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
                  child: SizedBox(height: 22),
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
                Theme(
                  data: context.t.copyWith(
                    splashColor: context.t.dividerColor.withOpacity(0.08),
                    highlightColor: Colors.transparent,
                  ),
                  child: LayoutBuilder(builder: (context, constraints) {
                    if (constraints.maxWidth < 720) {
                      return Column(
                        children: [
                          _appearanceSection(context),
                          const SizedBox(height: 24),
                          _privacySection(context),
                        ],
                      );
                    } else {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _appearanceSection(context)),
                          const SizedBox(width: 24),
                          Expanded(child: _privacySection(context)),
                        ],
                      );
                    }
                  }),
                ),
                const SizedBox(height: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appearanceSection(BuildContext context) {
    final box = Hive.box<String>('strings');
    const transition = 'disable_transition_effects';
    const blur = 'disable_blur';

    return Column(
      children: [
        Text(context.l.settingsAppearance,
            textAlign: TextAlign.center,
            style: GoogleFonts.getFont(context.l.fontComfortaa,
                fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 14),
        ListTile(
            hoverColor: context.t.dividerColor.withOpacity(0.04),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: const Icon(LucideIcons.sun),
            onTap: () {
              context.read<ThemeManager>().change();
            },
            title: Text(
              context.l.settingsTheme,
              style: GoogleFonts.getFont(context.l.fontAndika),
            ),
            trailing: Text(
              context.watch<ThemeManager>().name(context),
              style: GoogleFonts.getFont(context.l.fontComfortaa),
            )),
        const SizedBox(height: 8),
        ListTile(
          hoverColor: context.t.dividerColor.withOpacity(0.04),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          leading: const Icon(LucideIcons.move),
          onTap: () {
            box.put(transition,
                box.get(transition, defaultValue: '0')! == '0' ? '1' : '0');
          },
          title: Text(
            context.l.settingsDisableScreenTransitions,
            style: GoogleFonts.getFont(context.l.fontAndika),
          ),
          trailing: StreamBuilder<BoxEvent>(
              stream: box.watch(key: transition),
              initialData: BoxEvent(
                  transition, box.get(transition, defaultValue: '0'), false),
              builder: (_, snapshot) => Checkbox(
                    value: snapshot.data!.value as String == '1',
                    onChanged: (val) {
                      box.put(transition, val! ? '1' : '0');
                    },
                    activeColor: Colors.deepPurple.shade300,
                  )),
        ),
        const SizedBox(height: 8),
        ListTile(
          hoverColor: context.t.dividerColor.withOpacity(0.04),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          leading: const Icon(LucideIcons.palette),
          onTap: () {
            box.put(blur, box.get(blur, defaultValue: '0')! == '0' ? '1' : '0');
          },
          title: Text(
            context.l.settingsDisableBlur,
            style: GoogleFonts.getFont(context.l.fontAndika),
          ),
          trailing: StreamBuilder<BoxEvent>(
              stream: box.watch(key: blur),
              initialData:
                  BoxEvent(blur, box.get(blur, defaultValue: '0'), false),
              builder: (_, snapshot) => Checkbox(
                    value: snapshot.data!.value as String == '1',
                    onChanged: (val) {
                      box.put(blur, val! ? '1' : '0');
                    },
                    activeColor: Colors.deepPurple.shade300,
                  )),
        ),
      ],
    );
  }

  Widget _privacySection(BuildContext context) {
    final box = Hive.box<String>('strings');

    return Column(
      children: [
        Text(context.l.settingsPrivacy,
            textAlign: TextAlign.center,
            style: GoogleFonts.getFont(context.l.fontComfortaa,
                fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 14),
        ListTile(
            hoverColor: context.t.dividerColor.withOpacity(0.04),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: const Icon(LucideIcons.pieChart),
            onTap: () {
              openDialog(context, const TrackingConsentDialog());
            },
            title: Text(
              context.l.settingsDisableTracking,
              style: GoogleFonts.getFont(context.l.fontAndika),
            ),
            trailing: StreamBuilder<BoxEvent>(
              stream: box.watch(key: 'tracking'),
              initialData: BoxEvent(
                  'tracking', box.get('tracking', defaultValue: '1'), false),
              builder: (context, data) => Switch(
                  value: data.data!.value == '0',
                  activeColor: Colors.deepPurple.shade200,
                  onChanged: (_) {
                    openDialog(context, const TrackingConsentDialog());
                  }),
            )),
      ],
    );
  }
}
