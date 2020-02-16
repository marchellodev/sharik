import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';

import 'main.dart' as original_main;

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  original_main.main();
}
