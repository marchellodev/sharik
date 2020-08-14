package main

import (
	"github.com/go-flutter-desktop/go-flutter"
	"github.com/go-flutter-desktop/plugins/package_info"
	"github.com/go-flutter-desktop/plugins/path_provider"
	"github.com/go-flutter-desktop/plugins/url_launcher"
	"github.com/marchellodev/sharik_wrapper/go"
	filePicker "github.com/miguelpruivo/flutter_file_picker/go"
)

var options = []flutter.Option{
	flutter.WindowInitialDimensions(440, 680),
	//flutter.WindowDimensionLimits(420, 640, 420, 640),

	flutter.AddPlugin(&path_provider.PathProviderPlugin{
		VendorName:      "marchellodev",
		ApplicationName: "sharik",
	}),

	flutter.AddPlugin(&filePicker.FilePickerPlugin{}),

	flutter.AddPlugin(&url_launcher.UrlLauncherPlugin{}),
	flutter.AddPlugin(&package_info.PackageInfoPlugin{}),
	flutter.AddPlugin(&sharik_wrapper.SharikWrapperPlugin{}),
}
