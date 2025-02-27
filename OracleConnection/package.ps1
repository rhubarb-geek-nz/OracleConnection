#!/usr/bin/env pwsh
# Copyright (c) 2025 Roger Brown.
# Licensed under the MIT License.

param($ProjectName, $TargetFramework, $PublishDir, $ModuleId, $Version)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"
$compatiblePSEdition = $PSEdition
$PowerShellVersion = $PSVersionTable.PSVersion.ToString()
$RequireLicenseAcceptance = '$false'

If (($IsWindows -eq $null) -and ($PSEdition -eq 'Desktop'))
{
	$IsWindows = $true
}

trap
{
	throw $PSItem
}

function Get-SingleNodeValue([System.Xml.XmlDocument]$doc,[string]$path)
{
	return $doc.SelectSingleNode($path).FirstChild.Value
}

$xmlDoc = [System.Xml.XmlDocument](Get-Content "$ProjectName.csproj")

$ProjectUri = Get-SingleNodeValue $xmlDoc '/Project/PropertyGroup/PackageProjectUrl'
$Description = Get-SingleNodeValue $xmlDoc '/Project/PropertyGroup/Description'
$Author = Get-SingleNodeValue $xmlDoc '/Project/PropertyGroup/Authors'
$Copyright = Get-SingleNodeValue $xmlDoc '/Project/PropertyGroup/Copyright'
$AssemblyName = Get-SingleNodeValue $xmlDoc '/Project/PropertyGroup/AssemblyName'
$CompanyName = Get-SingleNodeValue $xmlDoc '/Project/PropertyGroup/Company'

$ModulePath = "$PublishDir/Modules/$ModuleId/$Version"

$null = New-Item -Path "$PublishDir/Modules" -ItemType Directory
$null = New-Item -Path "$PublishDir/Modules/$ModuleId" -ItemType Directory
$null = New-Item -Path "$ModulePath" -ItemType Directory
$null = New-Item -Path "$ModulePath/lib" -ItemType Directory

$NuGetPackages = "$HOME/.nuget/packages"

Copy-Item -Path "$NuGetPackages/oracle.manageddataaccess.core/$Version/LICENSE.txt" -Destination "$ModulePath/license.txt"
Copy-Item -Path "$NuGetPackages/oracle.manageddataaccess.core/$Version/info.txt" -Destination "$ModulePath"
$compatiblePSEdition = "Core"
$PowerShellVersion = "7.2"
$RequireLicenseAcceptance = '$true'

Get-ChildItem -Path $PublishDir -File -Filter 'Oracle*.dll' | Foreach-Object {
	Copy-Item -Path $_.FullName -Destination "$ModulePath/lib"
}

Copy-Item "$PublishDir/$AssemblyName.dll" $ModulePath
Copy-Item "$PublishDir/$AssemblyName.Alc.dll" "$ModulePath/lib"

If (-not($IsWindows))
{
	Get-ChildItem -Path $ModulePath -File | Foreach-Object {
		chmod -x $_.FullName
		If ( $LastExitCode -ne 0 )
		{
			Exit $LastExitCode
		}
	}
}

$moduleSettings = @{
	Path = "$PublishDir$ModuleId.psd1"
	RootModule = "$AssemblyName.dll"
	ModuleVersion = $Version
	Guid = '10cb2755-a167-4970-acad-5f637f6537c4'
	Author = $Author
	CompanyName = $CompanyName
	Copyright = $Copyright
	Description = $Description
	PowerShellVersion = $PowerShellVersion
	CompatiblePSEditions = @($compatiblePSEdition)
	FunctionsToExport = @()
	CmdletsToExport = @("New-$ProjectName")
	VariablesToExport = '*'
	AliasesToExport = @()
	ProjectUri = $ProjectUri
	RequireLicenseAcceptance = $true
}

New-ModuleManifest @moduleSettings

Import-PowerShellDataFile -LiteralPath "$PublishDir$ModuleId.psd1" | Export-PowerShellDataFile | Set-Content -LiteralPath "$ModulePath/$ModuleId.psd1"

Remove-Item "$PublishDir$ModuleId.psd1"

(Get-Content -LiteralPath '../README.md')[0..2] | Set-Content -Path "$ModulePath/README.md"
