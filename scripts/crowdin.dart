import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:http/http.dart' as http;

const projectId = 458738;
const apiUrl = 'https://api.crowdin.com/api/v2/projects/$projectId';

String getToken() => Platform.environment['TOKEN']!;

// todo
// - change list of languages in the app
// - translations for stores & f-droid

void main() async {
  await clearCurrentTranslations();
  // final id = await buildTranslations();
  const id = 48;
  await applyTranslationsArb(id);

  // running 'flutter clean' & 'flutter pub get'
  await Process.run('flutter', ['clean']);
  await Process.run('flutter', ['pub', 'get']);

  await updateLanguageConfig();
}

Future<void> updateLanguageConfig() async {
  var code =
      '/// GENERATED USING scripts/crowdin.dart | DO NOT EDIT MANUALLY\n\n';

  // imports
  // import 'package:flutter_gen/gen_l10n/app_localizations_zh.dart';

  final files = Directory('.dart_tool/flutter_gen/gen_l10n').listSync();
  for (final file in files) {
    final name = file.path.split('/').last;
    code += "import 'package:flutter_gen/gen_l10n/$name';\n";
  }

  File('lib/gen/languages.dart').writeAsStringSync(code);
}

Future<void> clearCurrentTranslations() async {
  final dir = Directory('locales');
  final files = await dir.list().toList();

  for (final file in files) {
    if (file.path.contains('app_en.arb')) {
      continue;
    }

    await file.delete();
  }

  print('current translations cleared');
}

Future<int> buildTranslations() async {
  final buildReq = await http.post(
    Uri.parse('$apiUrl/translations/builds'),
    body: jsonEncode({}),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${getToken()}',
    },
  );

  final buildId = jsonDecode(buildReq.body)['data']['id'] as int;
  print('building project translations (id $buildId)');

  var built = false;

  while (!built) {
    await Future.delayed(const Duration(seconds: 1));
    final buildStatus = await http.get(
      Uri.parse('$apiUrl/translations/builds/$buildId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${getToken()}',
      },
    );

    final status = jsonDecode(buildStatus.body)['data']['status'] as String;

    if (status == 'finished') {
      built = true;
    }
  }

  return buildId;
}

// todo it would be cool to display diff [for changelog] after applying translations
Future<void> applyTranslationsArb(int buildId) async {
  print('downloading project translations (id $buildId)');

  final buildDownload = await http.get(
    Uri.parse('$apiUrl/translations/builds/$buildId/download'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${getToken()}',
    },
  );

  final buildFile = jsonDecode(buildDownload.body)['data']['url'] as String;

  final buildFileRaw = (await http.get(Uri.parse(buildFile))).bodyBytes;

  final inputStream = InputStream(buildFileRaw);
  final archive = ZipDecoder().decodeBuffer(inputStream);

  for (final file in archive.files) {
    if (!file.isFile) {
      continue;
    }

    if (!file.name.contains('arb')) {
      // todo handle store.csv & contributors.csv
      continue;
    }

    // fr/fr_FR.arb
    var fileName = file.name.split('/')[0];
    fileName = fileName.replaceAll('-', '_');

    var contents = utf8.decode(file.content as List<int>);
    contents = contents.replaceAll(
      '"@@locale": "en",',
      '',
      // '"@@locale": "$locale",',
    );

    // fa_IR.arb
    // Exception: Multiple arb files with the same 'id' locale detected.
    // id_ID.arb
    File('locales/app_$fileName.arb').writeAsStringSync(contents);

    if (fileName.contains('_')) {
      final newFileName = fileName.split('_')[0];
      File('locales/app_$newFileName.arb').writeAsStringSync('{}');
    }
  }

  // not deleting this empty file causes a build error
  File('locales/app_tlh.arb').deleteSync();
}
