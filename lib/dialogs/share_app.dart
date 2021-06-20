import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/buttons.dart';
import '../logic/sharing_object.dart';
import '../utils/helper.dart';

// review: done
// todo styling

class ShareAppDialog extends StatefulWidget {
  @override
  _ShareAppDialogState createState() => _ShareAppDialogState();
}

class _ShareAppDialogState extends State<ShareAppDialog> {
  bool _hideSystem = true;
  bool _hideLaunchLess = true;
  List<ApplicationWithIcon> apps = <ApplicationWithIcon>[];
  String _search = '';
  ApplicationWithIcon? selected;

  @override
  void initState() {
    getApps();
    super.initState();
  }

  Future<void> getApps() async {
    setState(() {
      selected = null;

      apps.clear();
    });

    final arr = await DeviceApps.getInstalledApplications(
      onlyAppsWithLaunchIntent: _hideLaunchLess,
      includeSystemApps: !_hideSystem,
      includeAppIcons: true,
    );

    setState(() {
      apps = arr.cast<ApplicationWithIcon>();
    });
  }

  @override
  Widget build(BuildContext context) {
    var _apps = <ApplicationWithIcon>[];
    if (_search.isEmpty) {
      _apps = apps;
    } else {
      // selected = null;
      for (final el in apps) {
        if (el.packageName.toLowerCase().contains(_search) ||
            el.appName.toLowerCase().contains(_search)) {
          _apps.add(el);
        }
      }
      if (selected != null && !_apps.contains(selected)) {
        selected = null;
      }
    }

    return AlertDialog(
      elevation: 0,
      insetPadding: const EdgeInsets.all(24),
      scrollable: true,
      content: SizedBox(
        width: double.maxFinite,
        child: Theme(
          data: context.t.copyWith(
            splashColor: context.t.dividerColor.withOpacity(0.08),
            highlightColor: Colors.transparent,
          ),
          child: Column(
            children: [
              CheckboxListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.zero,
                title: Text(context.l.selectAppHideSystem, style: GoogleFonts.getFont('Andika'),),
                value: _hideSystem,
                onChanged: (value) => setState(() {
                  _hideSystem = value!;
                  getApps();
                }),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Colors.deepPurple.shade400,
              ),
              CheckboxListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.zero,
                title: Text(context.l.selectAppHideNonLaunch, style: GoogleFonts.getFont('Andika'),),
                value: _hideLaunchLess,
                onChanged: (value) => setState(() {
                  _hideLaunchLess = value!;
                  getApps();
                }),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Colors.deepPurple.shade400,
              ),
              TextField(
                onChanged: (value) =>
                    setState(() => _search = value.toLowerCase()),
                decoration:
                    InputDecoration(hintText: context.l.selectAppSearch),
              ),
              const SizedBox(height: 14),
              for (final app in _apps)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: ListTile(
                    // todo colors
                    selectedTileColor: context.t.dividerColor.withOpacity(0.08),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.zero,
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Image.memory(app.icon),
                    ),
                    title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(app.appName,
                            style: GoogleFonts.getFont('Andika',
                                fontWeight: selected == app
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                                color: context.t.textTheme.bodyText1!.color))),
                    subtitle: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(app.packageName,
                            style: GoogleFonts.getFont('Andika',
                                color: context.t.textTheme.bodyText1!.color))),
                    onTap: () => setState(() => selected = app),
                    selected: selected == app,
                  ),
                ),
              if (_apps.isEmpty && _search.isEmpty)
                Center(
                    child: Container(
                        padding: const EdgeInsets.all(24),
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                                context.t.accentColor.withOpacity(0.8)))))
            ],
          ),
        ),
      ),
      actions: [
        DialogTextButton(context.l.generalClose, () {
          Navigator.of(context).pop();
        }),
        DialogTextButton(
            context.l.generalSend,
            selected == null
                ? null
                : () {
                    Navigator.of(context).pop(SharingObject(
                        type: SharingObjectType.app,
                        data: selected!.apkFilePath,
                        name: selected!.appName));
                  }),
      ],
    );
  }
}
