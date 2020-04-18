package main

import (
	"github.com/go-flutter-desktop/go-flutter"
	"github.com/go-flutter-desktop/plugins/path_provider"
	"github.com/go-flutter-desktop/plugins/url_launcher"
	file_picker "github.com/marchellodev/flutter_file_picker/go"
	"github.com/marchellodev/go_flutter_clipboard_manager"
)

var options = []flutter.Option{
	flutter.WindowInitialDimensions(420, 640),
	flutter.WindowDimensionLimits(420, 640, 420, 640),

	flutter.AddPlugin(&path_provider.PathProviderPlugin{
		VendorName:      "marchellodev",
		ApplicationName: "sharik",
	}),

	flutter.AddPlugin(&file_picker.FilePickerPlugin{}),

	flutter.AddPlugin(&url_launcher.UrlLauncherPlugin{}),
	flutter.AddPlugin(&clipboard_manager.ClipboardManagerPlugin{}),
}
