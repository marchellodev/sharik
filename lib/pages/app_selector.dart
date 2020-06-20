import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

import '../locale.dart';
import '../models/app.dart';

class AppSelector extends StatefulWidget {
  final LocaleAdapter adapter;

  AppSelector(this.adapter);

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
      apps.forEach((element) {
        if (element.packageName.contains(_search) ||
            element.appName.contains(_search)) _apps.add(element);
      });
    }

    return AlertDialog(
//      scrollable: true,
      content: Container(
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
            _apps != null
                ? Column(
                    children: _apps
                        .map((e) {
                          ApplicationWithIcon app = e;
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
                : Center(
                    child: Container(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator()))
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(L('Close', widget.adapter)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(L('Send', widget.adapter)),
          onPressed: _selected == null
              ? null
              : () {
                  Navigator.of(context).pop(_selected);
                },
        ),
      ],
    );
  }
}
