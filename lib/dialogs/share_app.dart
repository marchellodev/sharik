import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:sharik/components/buttons.dart';
import 'package:sharik/models/file.dart';

import '../utils/helper.dart';

class ShareAppDialog extends StatefulWidget {
  @override
  _ShareAppDialogState createState() => _ShareAppDialogState();
}

class _ShareAppDialogState extends State<ShareAppDialog> {
  bool _hideSystem = true;
  bool _hideLaunchLess = true;
  List<Application> apps = <Application>[];
  String _search = '';
  int? selected;

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
      selected = null;
      for (final el in apps) {
        if (el.packageName.toLowerCase().contains(_search) ||
            el.appName.toLowerCase().contains(_search)) {
          _apps.add(el);
        }
      }
    }
    // todo decrease paddings but maintain style
    // todo add the dialog title
    // todo review widget structure (remove listviews)

    return AlertDialog(
      elevation: 0,
      insetPadding: const EdgeInsets.all(24),
      scrollable: true,
      content: SizedBox(
        // height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          children: [
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.l.selectAppHideSystem),
              value: _hideSystem,
              onChanged: (value) => setState(() {
                _hideSystem = value!;
                getApps();
              }),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: Colors.deepPurple.shade400,
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.l.selectAppHideNonLaunch),
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
              decoration: InputDecoration(hintText: context.l.selectAppSearch),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: _apps.length * 72,
              child: ListView.builder(
                  itemCount: _apps.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, e) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Image.memory(
                            (_apps[e] as ApplicationWithIcon).icon),
                        title: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(_apps[e].appName)),
                        subtitle: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              _apps[e].packageName,
                            )),
                        onTap: () => setState(() => selected = e),
                        selected: selected == e,
                      )),
            ),
            if (_apps.isEmpty && _search.isEmpty)
              Center(
                  child: Container(
                      padding: const EdgeInsets.all(24),
                      child: const CircularProgressIndicator()))
          ],
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
                    // todo pop with the model
                    Navigator.of(context).pop(FileModel(
                        type: FileTypeModel.app,
                        data: _apps[selected!].apkFilePath,
                        fileName: _apps[selected!].appName));
                  }),
      ],
    );
  }
}
