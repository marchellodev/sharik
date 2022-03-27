# First, copy the `flutter build linux` output to this folder
# Also, make sure to have installed `flatpak` and `flatpak-builder`

# flatpak install org.freedesktop.Platform/x86_64/
# flatpak install org.freedesktop.Sdk/x86_64/

rm -rf build-dir/

flatpak-builder --user --install build-dir dev.marchello.Sharik.yml
flatpak run dev.marchello.Sharik
