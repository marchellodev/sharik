package main

import (
	"github.com/go-flutter-desktop/go-flutter"
	"github.com/go-flutter-desktop/plugins/path_provider"
	"github.com/go-flutter-desktop/plugins/shared_preferences"
	"github.com/go-flutter-desktop/plugins/url_launcher"
	"github.com/marchellodev/go_flutter_clipboard_manager"
	file_picker "github.com/miguelpruivo/flutter_file_picker/go"
)

var options = []flutter.Option{
	flutter.WindowInitialDimensions(420, 640),
	flutter.WindowDimensionLimits(420, 640, 420, 640),

	flutter.AddPlugin(&path_provider.PathProviderPlugin{
		VendorName:      "marchellodev",
		ApplicationName: "sharik",
	}),

	flutter.AddPlugin(&shared_preferences.SharedPreferencesPlugin{
		VendorName:      "marchellodev",
		ApplicationName: "sharik",
	}),
	flutter.AddPlugin(&file_picker.FilePickerPlugin{}),

	flutter.AddPlugin(&url_launcher.UrlLauncherPlugin{}),
	flutter.AddPlugin(&clipboard_manager.ClipboardManagerPlugin{}),
}
