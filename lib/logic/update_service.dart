import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sharik/conf.dart';

class UpdateService extends ChangeNotifier {
  // todo change to master
  static const String url =
      'https://raw.githubusercontent.com/marchellodev/sharik/v3/CHANGELOG.md';

  String? markdown;
  String? latestVersion;
  UpdateServiceState state = UpdateServiceState.none;

  Future<void> fetch() async {
    state = UpdateServiceState.loading;
    notifyListeners();

    final req = await http.get(Uri.parse(url));

    if (req.statusCode != 200) {
      state = UpdateServiceState.none;
      notifyListeners();
      return;
    }

    markdown = req.body.replaceFirst('# Changelog\n', '');

    latestVersion = _parseLatestVersion();

    state = latestVersion == currentVersion
        ? UpdateServiceState.latest
        : UpdateServiceState.upgradable;

    notifyListeners();
  }

  String _parseLatestVersion() {
    if (markdown == null) {
      throw Exception('markdown is not defined');
    }

    for (final el in markdown!.split('\n')) {
      if (el.startsWith('##')) {
        var val = el.replaceFirst('## ', '');
        val = val.split(' ')[0];
        val = val.replaceFirst('v', '');
        return val;
      }
    }

    return 'error';
  }
}

enum UpdateServiceState { none, loading, upgradable, latest }
