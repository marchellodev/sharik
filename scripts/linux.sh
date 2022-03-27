#!/usr/bin/env bash

_build_raw(){
  echo "BUILDING A RAW LINUX APP:"
  flutter build linux --split-debug-info="${linux_folder}/debug-symbols" $keys | sed -e 's/^/>> /;'

  echo "LINUX APP BUILT SUCCESSFULLY"

  # copy build linux_folder to the release destination
  f="$linux_folder/sharik"
  mkdir -p "$f"
  rm -rf "$f/*"
  cp build/linux/x64/release/bundle/* "$f" -r
}

raw(){
  cd "$linux_folder"

  echo ""
  echo "COMPRESSING FOLDER INTO A ZIP FILE:"
  mkdir "raw"
  zip -r "raw/sharik_v${version}_linux.zip" sharik | sed -e 's/^/>> /;'
}

deb(){
  # TODO change version in deb's control file
  # TODO deb file app icon

  cp "$linux_folder/sharik" "scripts/packaging/deb/debian-x64/sharik/usr/lib/" -r

  cd "scripts/packaging/deb/debian-x64"

  echo "BUILDING DEB:"
  ./build.sh | sed -e 's/^/>> /;'

  echo "BUILT DEB SUCCESSFULLY"

  cd "../../../../"
  mkdir -p "$linux_folder/deb"
  cp "scripts/packaging/deb/debian-x64/sharik.deb" "$linux_folder/deb/sharik_v${version}_linux.deb"

  rm "scripts/packaging/deb/debian-x64/sharik/usr/lib/sharik" -rf
  rm "scripts/packaging/deb/debian-x64/sharik.deb" -rf
}

appimage(){
  echo "APPIMAGE"
  cp "$linux_folder/sharik/." "scripts/packaging/appimage/sharik.AppDir/app/" -r

  cd "scripts/packaging/appimage"

  echo "BUILDING APPIMAGE:"
  ./build.sh | sed -e 's/^/>> /;'

  echo "BUILT APPIMAGE SUCCESSFULLY"

  cd "../../../"
  mkdir -p "$linux_folder/appimage"
  cp "scripts/packaging/appimage/Sharik-x86_64.AppImage" "$linux_folder/appimage/sharik_v${version}_linux.AppImage"

  rm "scripts/packaging/appimage/sharik.AppDir/app" -rf
  mkdir "scripts/packaging/appimage/sharik.AppDir/app"
  rm "scripts/packaging/appimage/Sharik-x86_64.AppImage" -rf
}

flatpak(){
  echo "Packaging flatpak"

  cp "$linux_folder/sharik" "scripts/packaging/flatpak/" -r

  cd "scripts/packaging/flatpak"

  echo "BUILDING FLATPAK:"
  ./build.sh | sed -e 's/^/>> /;'
}


packaging=(raw deb appimage flatpak snap)
echo "Packaging (${packaging[*]}): "
read package


linux_folder="${build_folder}/linux"
keys="--dart-define platform=$platform --dart-define packaging=$package"
_build_raw

if test "$package" = "raw"; then
  raw
elif test "$package" = "deb"; then
  deb
elif test "$package" = "appimage"; then
  appimage
elif test "$package" = "flatpak"; then
  flatpak
fi

