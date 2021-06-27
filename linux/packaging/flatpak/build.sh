# First, copy the `flutter build linux` output to this folder

rm -rf build-dir/

flatpak-builder --user --install build-dir dev.marchello.Sharik.yml
flatpak run dev.marchello.Sharik
