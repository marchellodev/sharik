# Create Msi Installer from Folder

Creat Wix Installer from Folder does exactly what is says on the tin. Pass it a folder (and some other options) and it will use Wix to create a deployable MSI from that folder.

The original use case for this was Scratch 3 but it can be used to create an MSI from any folder that contains an executable. It won't create any required registry so this can only be used to create MSIs for software that runs from a folder.

## Requirements

To use this script you need the following tools installed on your machine:

 - .Net Framework 4.0.30319 (with msbuild)
 - [Wix Toolset](http://wixtoolset.org/releases/)

## Usage

|Option|Required|Default|About|
|:-----|:------:|:------|:----|
|Path|Yes|Null|The folder to create the MSI from|
|Product|Yes|Null|The name to give the product. Used for Program Files folder, Desktop/Start Menu shortcut & others.|
|Version|Yes|Null|The Version to report to AD etc...|
|Executable|Yes|Null|The name of the exe inside `Path`. e.g. `App.exe` or `bin\app.exe`|
|UpgradeGUID|No|Generated at Runtime|Supply the UpgradeGUID that was outputted when you generated the first version of the MSI.|
|Manufacturer|No|Ed-IT Solutions MSI Creator|The manufacturer to set.|
|Contact|No|System Administrator|Who should the user contact for help.|
|HelpLink|No|http://www.example.com|Where should the user go for help.|
|AboutLink|No|http://www.example.com|Where can the user get more information about this product.|
|DownloadLink|No|http://www.example.com|Where can the user download this app.|
|Desktop|No|_false_|Set this flag if you would like a desktop shortcut to be created as well.|
|FileType|No||Associate a file type with this product.|

Create a new MSI for Scratch 3:
```
.\create-msi-installer-from-folder.ps1 -Path "C:\Users\adam\AppData\Local\Programs\scratch-desktop" -Product "Scratch 3 Desktop" -Version "1.2.1" -executable "Scratch Desktop.exe"
```

During that process an upgrade GUID will have been outputed, when creating a new versions MSI suppy it to the script.

```
.\create-msi-installer-from-folder.ps1 -Path "C:\Users\adam\AppData\Local\Programs\scratch-desktop" -Product "Scratch 3 Desktop" -Version "1.2.2" -executable "Scratch Desktop.exe" -UpgradeGUID "foo"
```

These commands will create `.\build\Deploy\Release\Scratch 3 Desktop (1.2.1).msi` and `.\build\Deploy\Release\Scratch 3 Desktop (1.2.2).msi`

## Contributing

We welcome pull requests and suggestions to this script.
