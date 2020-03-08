start_time=$(date +%s)


flutter clean
flutter build apk --split-per-abi
flutter build appbundle

hover bumpversion

hover build linux
hover build linux-appimage
hover build linux-deb
hover build linux-rpm
hover build linux-snap

hover build linux-windows
hover build linux-msi

hover build darwin
hover build darwin-bundle
hover build darwin-dmg
hover build darwin-pkg


end_time=$(date +%s)

echo execution time was $(expr "$end_time" - "$start_time") s.