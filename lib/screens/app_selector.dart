import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/helper.dart';

class AppSelector extends StatefulWidget {
  @override
  _AppSelectorState createState() => _AppSelectorState();
}

class _AppSelectorState extends State<AppSelector> {
  bool _checkSystem = true;
  bool _checkLaunch = true;
  List<Application> apps = <Application>[];
  String _search = '';
  String? _selected;

  @override
  void initState() {
    getApps();
    super.initState();
  }

  Future<void> getApps() async {
    setState(() => apps = []);

    final arr = await DeviceApps.getInstalledApplications(
        onlyAppsWithLaunchIntent: !_checkLaunch,
        includeSystemApps: !_checkSystem,
        includeAppIcons: true);

    setState(() {
      apps = arr;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _apps = <Application>[];
    if (_search.isEmpty) {
      _apps = apps;
    } else {
      for (final el in apps) {
        if (el.packageName.toLowerCase().contains(_search) ||
            el.appName.toLowerCase().contains(_search)) {
          _apps.add(el);
        }
      }
    }
    // todo decrease paddings but maintain style
    return AlertDialog(
//      scrollable: true,
      content: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            CheckboxListTile(
              title: Text(context.l!.selectAppHideSystem),
              value: _checkSystem,
              onChanged: (value) => setState(() {
                _checkSystem = value!;
                getApps();
              }),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              title: Text(context.l!.selectAppHideNonLaunch),
              value: _checkLaunch,
              onChanged: (value) => setState(() {
                _checkLaunch = value!;
                getApps();
              }),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            TextField(
              onChanged: (value) =>
                  setState(() => _search = value.toLowerCase()),
              decoration: InputDecoration(hintText: context.l!.selectAppSearch),
            ),
            if (_apps.isNotEmpty)
              Column(
                children: _apps
                    .map((e) {
                      final app = cast<ApplicationWithIcon>(e)!;
                      return ListTile(
                        leading: Image.memory(app.icon),
                        title: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(app.appName)),
                        subtitle: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              app.packageName,
                            )),
                        onTap: () =>
                            setState(() => _selected = app.packageName),
                        selected: _selected == app.packageName,
                      );
                    })
                    .toList()
                    .cast<Widget>(),
              )
            else
              Center(
                  child: Container(
                      padding: const EdgeInsets.all(24),
                      child: const CircularProgressIndicator()))
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(context.l!.generalClose,
              style: GoogleFonts.getFont(context.l!.fontAndika)),
        ),
        TextButton(
          onPressed: _selected == null
              ? null
              : () {
                  Navigator.of(context).pop(_selected);
                },
          child: Text(context.l!.generalSend,
              style: GoogleFonts.getFont(context.l!.fontAndika)),
        ),
      ],
    );
  }
}
