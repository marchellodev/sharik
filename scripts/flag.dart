import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:color/color.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

// flags should be 80% translucent

// todo: flags with gradient are not supported:
// bz - belize
// fk - falkland islands
// gs - south georgia
// gt - guatemala
// mx - mexico [critical cause spanish]
// ni - nicaragua
// vg - british virgin islands

const dirName = '_tmp_flags';

// todo: maybe more?
const svgColorAttributes = ['fill', 'stroke'];

// light lowest -> highest
const colorMap = ['D1C4E9', 'B39DDB', '9575CD', '7E57C2', '673AB7'];

Future<void> main() async {
  await downloadAll();
  processAll();
}

Future<void> processAll() async {
  final files = Directory(dirName).listSync();

  for (final file in files) {
    final contents = await File(file.path).readAsString();
    print('processing ${file.path.split('/').last}');

    final processed = await processSingle(contents);
    await File(file.path.replaceAll('.svg', '_new.svg'))
        .writeAsString(processed);
    // break;
  }
}

class ColorChangeEntry {
  final String colorName;
  late Color color;

  ColorChangeEntry(this.colorName) {
    final c = ColorParser().parse(colorName);
    if (c == null) {
      throw Exception('Unknown color format: $colorName');
    }
    color = c;
  }

  // @override
  // String toString() =>
  //     'ColorChangeEntry(originalColorValue: $originalColorValue, originalColorParsed: $originalColorParsed, newColor: $newColor)';
  @override
  String toString() => '$colorName - ${color.toHexColor()}';
}

// todo: do not cut off extra from 6, but specify a critical point (ex. <50) and merge according to it instead
Future<String> processSingle(String svg) async {
  final document = XmlDocument.parse(svg);

  final els = document.descendantElements.toList();

  final colors = <ColorChangeEntry>[];

  // find all colors
  for (final el in els) {

    // making default blacks explicit
    if(el.name.toString() == 'svg' && el.getAttribute('fill') == null){
      el.setAttribute('fill', '000');
    }


    for (final attr in svgColorAttributes) {
      final attrValue = el.getAttribute(attr);
      if (attrValue != null && attrValue != 'none') {
        if (colors.where((element) => element.colorName == attrValue).isEmpty) {
          colors.add(ColorChangeEntry(attrValue));
        }
      }
    }
  }

  // final distinctColors2 =
  //     colors.map((e) => e.color).toSet().map((e) => e.toHexColor()).toList();
  // print(distinctColors2);

  var merges = 0;
  // merging colors
  while (colors.map((e) => e.color).toSet().length > 5) {
    final distanceMap =
        <MapEntry<Color, Color>, double>{};

    // different formats ==
    final uniqueColors = colors.map((e) => e.color).toSet().toList();
    // create a comparison list
    for (var i = 0; i < uniqueColors.length; i++) {
      for (var j = i + 1; j < uniqueColors.length; j++) {
        final a = uniqueColors.elementAt(i);
        final b = uniqueColors.elementAt(j);
        // assert(a.color != b.color);
        final distance = _colorDistance(a, b);
        distanceMap[MapEntry(a, b)] = distance;
      }
    }

    final sortedDistanceMap =
        SplayTreeMap<MapEntry<Color, Color>, double>.from(
      distanceMap,
      (key1, key2) => distanceMap[key1]!.compareTo(distanceMap[key2]!),
    );

    // as we support max 6 colors, all others should be merged
    final toMerge = sortedDistanceMap.entries.first;
    final a = toMerge.key.key;
    final b = toMerge.key.value;
    final average = _averageColor(a, b);

    for(final color in colors){
      if(color.color == a || color.color == b){
        color.color = average;
      }
    }
    // colors.whe((element) => element == a).color = average;
    // colors.firstWhere((element) => element == b).color = average;

    merges++;
    // print(colors.map((e) => e.color).toSet().length);

  }

  print(merges);

  // print(colors);
  // print(sortedDistanceMap);
  // print(colors);

  // match those colors to the palette
  // order 6 colors by lightness & assign a shade of purple to each color
  final distinctColors =
      colors.map((e) => e.color).toSet().map((e) => e.toHexColor()).toList();
  // print(distinctColors);

  // ordering them by lightness
  // l: -100: black; 100: white
  final distinctColorsLightnessMap = distinctColors.map((e) => MapEntry(e, e.toCielabColor().l)).toList()..sort((a, b) => b.value.compareTo(a.value));
  final distinctColorsByLightness = distinctColorsLightnessMap.map((e) => e.key).toList();

  for(final color in colors){
    var index = distinctColorsByLightness.indexOf(color.color.toHexColor());

    if(distinctColorsByLightness.length == 2){
      if(index == 1){
        index = 4;
       }
    } else if(distinctColorsByLightness.length == 3){
      if(index == 1){
        index = 2;
      }
      if(index == 2){
        index = 4;
      }
    } else if(distinctColorsByLightness.length == 4){
      if(index == 2){
        index = 3;
      }
      if(index == 3){
        index = 4;
      }
    }

    final newColor = colorMap[index];
    color.color = ColorParser().parse(newColor)!;
  }

  // print(distinctColorsByLightness);


  // apply the colors
  for (final el in els) {
    for (final attr in svgColorAttributes) {
      final attrValue = el.getAttribute(attr);
      if (attrValue != null && attrValue != 'none') {
        final color =
            colors.firstWhere((element) => element.colorName == attrValue);
        el.setAttribute(attr, '#${color.color.toHexColor()}');
      }
    }
  }

  // print(document);
  return document.toString();
}

Color _averageColor(Color a, Color b) {
  final cielabA = a.toCielabColor();
  final cielabB = b.toCielabColor();

  final avgL = (cielabA.l + cielabB.l) / 2;
  final avgA = (cielabA.a + cielabB.a) / 2;
  final avgB = (cielabA.b + cielabB.b) / 2;

  final average = CielabColor(avgL, avgA, avgB);

  return average;
}

double _colorDistance(Color a, Color b) {
  // https://en.wikipedia.org/wiki/Color_difference#CIELAB_%CE%94E*
  // CIE76 - the most basic formula, at least for now
  final cielabA = a.toCielabColor();
  final cielabB = b.toCielabColor();

  return sqrt(
    pow(cielabA.l - cielabB.l, 2) +
        pow(cielabA.a - cielabB.a, 2) +
        pow(cielabA.b - cielabB.b, 2),
  );
}

Future<void> downloadAll() async {
  if (await Directory(dirName).exists()) {
    await Directory(dirName).delete(recursive: true);
  }
  await Directory(dirName).create();

  const apiGetAllFiles =
      'https://api.github.com/repos/lipis/flag-icons/git/trees/main?recursive=1';
  final response = await http.get(Uri.parse(apiGetAllFiles));
  final allFiles =
      ((jsonDecode(response.body) as Map)['tree'] as List).cast<Map>();

  for (final file in allFiles) {
    if (!(file['path'] as String).startsWith('flags/4x3/')) {
      continue;
    }

    final fileUrl =
        'https://raw.githubusercontent.com/lipis/flag-icons/main/${file['path']}';

    final response = (await http.get(Uri.parse(fileUrl))).body;

    if (response.toLowerCase().contains('gradient')) {
      // todo: gradient support
      print('skipping ${file['path']} due to gradient');
      continue;
    }

    File(
      '$dirName/${(file['path'] as String).split('/').last}',
    ).writeAsStringSync(response);

    print(fileUrl);
  }

  print('downloaded successfully');
}
