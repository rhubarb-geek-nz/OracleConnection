#!/usr/bin/env pwsh
#
#  Copyright 2023, Roger Brown
#
#  This file is part of rhubarb-geek-nz/OracleConnection.
#
#  This program is free software: you can redistribute it and/or modify it
#  under the terms of the GNU Lesser General Public License as published by the
#  Free Software Foundation, either version 3 of the License, or (at your
#  option) any later version.
# 
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>
#

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

$NuGetPackages = "$HOME/.nuget/packages"

switch ($TargetFramework)
{
	'net481' {
		Copy-Item -Path "$NuGetPackages/oracle.manageddataaccess/$Version/LICENSE.txt" -Destination "$ModulePath/license.txt"
		Copy-Item -Path "$NuGetPackages/oracle.manageddataaccess/$Version/info.txt" -Destination "$ModulePath"
		$compatiblePSEdition = "Desktop"
		$PowerShellVersion = "5.1"
		$RequireLicenseAcceptance = '$true'
	}
	'netstandard2.1' {
		Copy-Item -Path "$NuGetPackages/oracle.manageddataaccess.core/$Version/LICENSE.txt" -Destination "$ModulePath/license.txt"
		Copy-Item -Path "$NuGetPackages/oracle.manageddataaccess.core/$Version/info.txt" -Destination "$ModulePath"
		$compatiblePSEdition = "Core"
		$PowerShellVersion = "7.2"
		$RequireLicenseAcceptance = '$true'
	}
}

Get-ChildItem -Path $PublishDir -File -Filter 'Oracle*.dll' | Foreach-Object {
	Copy-Item -Path $_.FullName -Destination $ModulePath
}

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

@"
@{
	RootModule = '$AssemblyName.dll'
	ModuleVersion = '$Version'
	GUID = '10cb2755-a167-4970-acad-5f637f6537c4'
	Author = '$Author'
	CompanyName = '$CompanyName'
	Copyright = '$Copyright'
	Description = '$Description'
	CompatiblePSEditions = @('$compatiblePSEdition')
	PowerShellVersion = '$PowerShellVersion'
	FunctionsToExport = @()
	CmdletsToExport = @('New-$ProjectName')
	VariablesToExport = '*'
	AliasesToExport = @()
	PrivateData = @{
		PSData = @{
			ProjectUri = '$ProjectUri'
			RequireLicenseAcceptance = $RequireLicenseAcceptance
			LicenseUri = 'https://aka.ms/deprecateLicenseUrl'
		}
	}
}
"@ | Set-Content -Path "$ModulePath/$ModuleId.psd1"

(Get-Content "./README.md")[0..2] | Set-Content -Path "$ModulePath/README.md"
