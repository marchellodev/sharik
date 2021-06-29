param(
  [Parameter(Mandatory=$True)]
  [string]$Path,
  [Parameter(Mandatory=$True)]
  [string]$Product,
  [Parameter(Mandatory=$True)]
  [string]$Version,
  [Parameter(Mandatory=$True)]
  [string]$executable,
  [string]$UpgradeGUID,
  [string]$Manufacturer = "Ed-IT Solutions MSI Creator",
  [string]$Contact = "System Administrator",
  [string]$HelpLink = "http://www.example.com",
  [string]$AboutLink = "http://www.example.com",
  [string]$DownloadLink = "http://www.example.com",
  [switch]$Desktop = $False,
  [string]$FileType = ""
)

function step{
  param(
    [Parameter(Mandatory=$True)]
    [string]$message
  )

  $stars = "*" * 60

  $msg = "*" + (" " * (29 - ($message.Length / 2))) + $message + " " * (29 - ($message.Length / 2)) + "*"

  Write-Host $stars
  Write-Host $msg
  Write-Host $stars
}

step -message "Starting Package Creator"

if(!$UpgradeGUID){
  Write-Host "No UpgradeGUID Provided"
  $UpgradeGUID = New-Guid
  Write-Host "To upgrade this package in the future use this guid:"
  $UpgradeGUID
}

$ProjectGUID = New-Guid

Write-Host "Product GUID $ProjectGUID"


step -message "Creating Installer.wixproj"

[xml]$installer = Get-Content "$PSScriptRoot\source\installer.wixproj"

Write-Host "Setting project information."

$installer.Project.PropertyGroup[0].OutputName = "$Product ($Version)"
$installer.Project.PropertyGroup[0].ProjectGuid = "$ProjectGUID"
$installer.Project.PropertyGroup[0].ProductVersion = $Version
$installer.Project.PropertyGroup[1].DefineConstants = "Debug;HarvestPath=$Path;ProductVersion=$Version"
$installer.Project.PropertyGroup[2].DefineConstants = "HarvestPath=$Path;ProductVersion=$Version"
$installer.Project.Target[0].HeatDirectory.Directory = $Path

Write-Host "Saving to .\build"

$installer.Save("$PSScriptRoot\build\installer.wixproj")

step -message "Creating Product.wxs"

$productwxs = New-Object xml
$productwxs.Load("$PSScriptRoot\source\product.wxs")

Write-Host "Setting product information."

$productwxs.Wix.Product.Name = $Product
$productwxs.Wix.Product.Version = $Version
$productwxs.Wix.Product.Manufacturer = $Manufacturer
$productwxs.Wix.Product.UpgradeCode = $UpgradeGUID

Write-Host "Creating directories."

$productwxs.Wix.Product.Directory.Directory[0].Directory.Name = $Product

$installDir = $productwxs.Wix.Product.Directory.Directory[0].Directory
$installDir.Component.File.Source = "$Path\$Executable"

$dirs = $Executable.split('\')
$i = 1

forEach($dir in $dirs){
  if($dir -notmatch '\.exe$'){
    $exeDir = $installDir.Clone()

    $component = $installDir.Component
    $installDir.RemoveChild($component) | Out-Null

    $exeDir.Id = "EXEDIR_$i"
    $exeDir.Name = $dir
    $installDir.appendChild($exeDir) | Out-Null
    $installDir = $exeDir
    $i = $i + 1
  }
}



Write-Host "Creating start menu shortcut."

$productwxs.Wix.Product.Directory.Directory[1].Component.Shortcut.Name = $Product
$productwxs.Wix.Product.Directory.Directory[1].Component.Shortcut.Description = $Product
$productwxs.Wix.Product.Directory.Directory[1].Component.Shortcut.Target = "[INSTALLDIR]$Executable"
$productwxs.Wix.Product.Directory.Directory[1].Component.RegistryValue.Key = "Software\$Product"

if($Desktop){
  Write-Host "Creating desktop shortcut"

  $desktopDirectory = $productwxs.Wix.Product.Directory.Directory[1].Clone()
  $desktopDirectory.Component.Shortcut.Id = "DesktopShortcut_001"
  $desktopDirectory.Component.Id = "DesktopShortcut.lnk"
  $desktopDirectory.Id = "DesktopFolder"
  $productwxs.Wix.Product.Directory.appendChild($desktopDirectory) | Out-Null

  $desktopRef = $productwxs.Wix.Product.Feature.ComponentRef[1].Clone()
  $desktopRef.Id = "DesktopShortcut.lnk"
  $productwxs.Wix.Product.Feature.appendChild($desktopRef) | Out-Null
}

$productwxs.Wix.Product.Icon.SourceFile = "$Path\$Executable"

$productwxs.Wix.Product.Feature.Title = $Product

Write-Host "Setting contact information."

$productwxs.Wix.Product.Property[0].Value = $Contact
$productwxs.Wix.Product.Property[1].Value = $HelpLink
$productwxs.Wix.Product.Property[3].Value = $AboutLink
$productwxs.Wix.Product.Property[4].Value = $DownloadLink

if($FileType){
  Write-Host "Associating $FileType with $Product"
  [xml]$assocDoc = Get-Content "$PSScriptRoot\source\filetype.wsx"
  $assoc = $assocDoc.Wix

  $productName = ($Product -replace '\s','') + "File"

  $assoc.ProgId.Id = $productName
  $assoc.ProgId.Description = $Product
  $assoc.ProgId.Extension.Id = $FileType

  $appendable = $productwxs.ImportNode($assoc, $True)

  $productwxs.Wix.Product.Directory.Directory[0].Directory.Component.appendChild($appendable.ProgId) | Out-Null
}

Write-Host "Saving to .\build"

$productwxs.Save("$PSScriptRoot\build\product.wxs")

step -message "Create Transform"

[xml]$transform = Get-Content "$PSScriptRoot\source\transform.xslt"

$exe = Split-Path -Path "$Path\$Executable" -Leaf -Resolve

$transform.stylesheet.key.match = "wix:Component[contains(wix:File/@Source, '$exe')]"

$transform.Save("$PSScriptRoot\build\transform.xslt")

step -message "Running WIX"

& "C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe" "$PSScriptRoot\build\installer.wixproj"

step -message "Complete!"

Write-Host "Your MSI Has been built."
Write-Host "Find it at $PSScriptRoot\build\Deploy\Release\$Product ($Version).msi"
Write-Host "Your Upgrade GUID is $UpgradeGUID"