start_time=$(date +%s)

#go list -m -u all

flutter channel beta
flutter upgrade
flutter clean
flutter build apk --split-per-abi
flutter build appbundle

flutter channel master
flutter upgrade
flutter clean
hover bumpversion

hover build linux
hover build linux-appimage
hover build linux-deb
hover build linux-rpm
hover build linux-snap

hover build windows
hover build windows-msi

hover build darwin
hover build darwin-bundle
hover build darwin-dmg
hover build darwin-pkg


end_time=$(date +%s)

echo execution time was $(expr "$end_time" - "$start_time") s.