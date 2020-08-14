start_time=$(date +%s)

flutter packages pub run build_runner build
#dpkg-buildpackage -b --force-sign

flutter channel stable
flutter upgrade
flutter clean
flutter build apk --split-per-abi
flutter build appbundle

flutter channel beta
flutter upgrade
flutter clean
rm go/build -rf
hover bumpversion

hover build linux --docker
hover build linux-appimage --docker
hover build linux-deb --docker
hover build linux-rpm --docker
hover build linux-pkg --docker

hover build windows --docker
hover build windows-msi --docker

hover build darwin --docker
hover build darwin-dmg --docker
hover build darwin-pkg --docker


end_time=$(date +%s)

echo execution time was $(expr "$end_time" - "$start_time") s.



