#!/usr/bin/env bash

platforms=(linux win android)
build_folder="release_build"

# WORKING DIR
if test -f "../pubspec.yaml"; then
  cd ..
elif ! test -f "pubspec.yaml"; then
  echo "unable to locate project folder" >&2
  exit 1
fi

# todo parse version from the yaml file (or ask for it)
version="3.2"

# PLATFORM
# echo "Platform (${platforms[*]}): "
# read platform
platform="linux"


echo "RUNNING FLUTTER CLEAN:"
flutter clean | sed -e 's/^/>> /;'


if test "$platform" = "linux"; then
  source "scripts/linux.sh"
fi
