#!/bin/sh

raw(){
  echo "BUILDING A RAW LINUX APP:"
#  flutter build linux --split-debug-info="${folder}/debug-symbols" $keys | sed -e 's/^/>> /;'

  echo "LINUX APP BUILT SUCCESSFULLY"

  # copy build folder to the release destination
  f="$folder/sharik"
  mkdir -p "$f"
  rm -rf "$f/*"
  cp build/linux/x64/release/bundle/* "$f" -r
}

packaging=(raw deb)
echo "Packaging (${packaging[*]}): "
read package


folder="${buildfolder}/linux"
keys="--dart-define platform=$platform --dart-define packaging=$package"

echo "flutter build linux --split-debug-info='${folder}/debug-symbols' $keys"

if test "$package" = "raw"; then
  raw
  cd "$folder"

  echo ""
  echo "COMPRESSING FOLDER INTO A ZIP FILE:"
  zip -r "sharik_v${version}_linux.zip" sharik | sed -e 's/^/>> /;'

elif test "$package" = "deb"; then
  # TODO change version in deb's control file
  raw

  cp "$folder/sharik" "scripts/packaging/deb/debian-x64/sharik/usr/lib/" -r

  cd "scripts/packaging/deb/debian-x64"

  echo "BUILDING DEB:"
  ./build.sh | sed -e 's/^/>> /;'

  echo "BUILT DEB SUCCESSFULLY"

  cd "../../../../"
  mkdir -p "$folder/deb"
  cp "scripts/packaging/deb/debian-x64/sharik.deb" "$folder/deb/sharik_v${version}_linux.deb"

  rm "scripts/packaging/deb/debian-x64/sharik/usr/lib/sharik" -rf
  rm "scripts/packaging/deb/debian-x64/sharik.deb" -rf
fi

