import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../locale.dart';
import '../models/locale.dart';

class AppSelector extends StatefulWidget {
  //todo: remove callback
  final Function(String package) callback;
  final LocaleModel locale;

  AppSelector(this.callback, this.locale);

  @override
  _AppSelectorState createState() => _AppSelectorState();
}

class _AppSelectorState extends State<AppSelector> {
  bool checkSystem = true;
  bool checkLaunch = true;
  List<Application> apps;
  String search;
  String selected;

  @override
  void initState() {
    getApps();
    super.initState();
  }

  void getApps() {
    setState(() => apps = null);

    DeviceApps.getInstalledApplications(
            onlyAppsWithLaunchIntent: !checkLaunch,
            includeSystemApps: !checkSystem,
            includeAppIcons: true)
        .then((value) => setState(() => apps = value));
  }

  @override
  Widget build(BuildContext context) {
    var _apps = <Application>[];
    if (search == null || search.isEmpty) {
      _apps = apps;
    } else {
      apps.forEach((element) {
        if (element.packageName.contains(search) ||
            element.appName.contains(search)) _apps.add(element);
      });
    }

    return AlertDialog(
//      title: Text("Type some text asdf asdfhba sdfhbfipsadfhbapsdihfbp"),
      content: Container(
        width: double.maxFinite,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            CheckboxListTile(
              title: Text(L.get('Hide system apps', widget.locale)),
              value: checkSystem,
              onChanged: (value) => setState(() {
                checkSystem = value;
                getApps();
              }),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              title: Text(L.get('Hide non-launchable apps', widget.locale)),
              value: checkLaunch,
              onChanged: (value) => setState(() {
                checkLaunch = value;
                getApps();
              }),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            TextField(
              onChanged: (value) => setState(() => search = value),
              decoration:
                  InputDecoration(hintText: L.get('Search', widget.locale)),
            ),
            _apps != null
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: _apps.length,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, item) {
                      ApplicationWithIcon app = _apps[item];
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
                        onTap: () => setState(() => selected = app.packageName),
                        selected: selected == app.packageName,
                      );
                    })
                : Center(
                    child: Container(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator()))
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(L.get('Close', widget.locale)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(L.get('Send', widget.locale)),
          onPressed: selected == null
              ? null
              : () {
                  Navigator.of(context).pop();
                  widget.callback(selected);
                },
        ),
      ],
    );
  }
}
