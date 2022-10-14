#!/bin/env bash

# This script regenerates all automatically generated files
# Usage: ./gen.sh (inside a project folder)

# Removing all flutter-generated files
flutter clean
flutter pub get

# Remove else TODO

# dart scripts/flags.dart

# Generating all translations & flags & everything related to texts
env TOKEN=a427f315cc2a88baf05f0fa745be4ba8ee4c1f5f27337fddb38ed14693c1612b18d688fce3104d59 dart scripts/crowdin.dart

# TODO .env file


