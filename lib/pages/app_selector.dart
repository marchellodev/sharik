import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sharik/models/locale.dart';

import '../cast.dart';
import '../locale.dart';

class AppSelector extends StatefulWidget {
  final LocaleAdapter adapter;

  const AppSelector(this.adapter);

  @override
  _AppSelectorState createState() => _AppSelectorState();
}

class _AppSelectorState extends State<AppSelector> {
  bool _checkSystem = true;
  bool _checkLaunch = true;
  List<Application> apps;
  String _search;
  String _selected;

  @override
  void initState() {
    getApps();
    super.initState();
  }

  void getApps() {
    setState(() => apps = null);

    DeviceApps.getInstalledApplications(
            onlyAppsWithLaunchIntent: !_checkLaunch,
            includeSystemApps: !_checkSystem,
            includeAppIcons: true)
        .then((value) => setState(() => apps = value));
  }

  @override
  Widget build(BuildContext context) {
    var _apps = <Application>[];
    if (_search == null || _search.isEmpty) {
      _apps = apps;
    } else {
      for (final el in apps) {
        if (el.packageName.contains(_search) || el.appName.contains(_search)) {
          _apps.add(el);
        }
      }
    }

    return AlertDialog(
//      scrollable: true,
      content: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            CheckboxListTile(
              title: Text(L('Hide system apps', widget.adapter)),
              value: _checkSystem,
              onChanged: (value) => setState(() {
                _checkSystem = value;
                getApps();
              }),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              title: Text(L('Hide non-launchable apps', widget.adapter)),
              value: _checkLaunch,
              onChanged: (value) => setState(() {
                _checkLaunch = value;
                getApps();
              }),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            TextField(
              onChanged: (value) => setState(() => _search = value),
              decoration:
                  InputDecoration(hintText: L('Search', widget.adapter)),
            ),
            if (_apps != null)
              Column(
                children: _apps
                    .map((e) {
                      final app = cast<ApplicationWithIcon>(e);
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
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(L('Close', widget.adapter),
              style: GoogleFonts.getFont(L('Andika', widget.adapter))),
        ),
        FlatButton(
          onPressed: _selected == null
              ? null
              : () {
                  Navigator.of(context).pop(_selected);
                },
          child: Text(L('Send', widget.adapter),
              style: GoogleFonts.getFont(L('Andika', widget.adapter))),
        ),
      ],
    );
  }
}
