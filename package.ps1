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

param(
	$Framework = 'netstandard2.1'
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"
$BINDIR = "bin/Release/$Framework/publish"
$ModuleName = 'OracleConnection'

trap
{
	throw $PSItem
}

$xmlDoc = [System.Xml.XmlDocument](Get-Content "$ModuleName.$Framework.nuspec")

$Version = $xmlDoc.SelectSingleNode("/package/metadata/version").FirstChild.Value
$CompanyName = $xmlDoc.SelectSingleNode("/package/metadata/authors").FirstChild.Value
$ModuleId = $xmlDoc.SelectSingleNode("/package/metadata/id").FirstChild.Value

foreach ($Name in "obj", "bin", "$ModuleId", "$ModuleId.$Version.nupkg")
{
	if (Test-Path "$Name")
	{
		Remove-Item "$Name" -Force -Recurse
	} 
}

dotnet publish $ModuleName.csproj --configuration Release --framework $Framework

If ( $LastExitCode -ne 0 )
{
	Exit $LastExitCode
}

$null = New-Item -Path "$ModuleId" -ItemType Directory

foreach ($Filter in "Oracle*", "LICENSE*") {
	Get-ChildItem -Path "$BINDIR" -Filter $Filter | Foreach-Object {
		if ((-not($_.Name.EndsWith('.pdb'))) -and (-not($_.Name.EndsWith('.deps.json'))))
		{
			Copy-Item -Path $_.FullName -Destination "$ModuleId"
		}
	}
}

If ($IsWindows)
{
	$NuGetPackages = "$Env:USERPROFILE/.nuget/packages"
}
else
{
	$NuGetPackages = "$Env:HOME/.nuget/packages"
}

switch ($Framework)
{
	'net481' {
		Copy-Item -Path "$NuGetPackages/oracle.manageddataaccess/$Version/LICENSE.txt" -Destination "$ModuleId/LICENSE.Oracle"
		}
	'netstandard2.1' {
		Copy-Item -Path "$NuGetPackages/oracle.manageddataaccess.core/$Version/LICENSE.txt" -Destination "$ModuleId/LICENSE.Oracle"
		}
}

If ($IsWindows)
{
	$content = [System.IO.File]::ReadAllText("$ModuleId/LICENSE.LGPL3")

	$content.Replace("`u{000D}`u{000A}","`u{000A}") | Out-File "$ModuleId/LICENSE.LGPL3" -Encoding Ascii -NoNewLine
}
else
{
	Get-ChildItem -Path "$ModuleId" -File | Foreach-Object {
		chmod -x $_.FullName
		If ( $LastExitCode -ne 0 )
		{
			Exit $LastExitCode
		}
	}
}

$date = [Datetime]::ParseExact('09/30/2017 07:16:26', 'MM/dd/yyyy HH:mm:ss', $null)

Get-ChildItem "$ModuleId/LICENSE.LGPL3" | Foreach-Object {$_.LastWriteTime = $date}

@"
@{
	RootModule = '$ModuleName.dll'
	ModuleVersion = '$Version'
	GUID = '10cb2755-a167-4970-acad-5f637f6537c4'
	Author = 'Roger Brown'
	CompanyName = 'rhubarb-geek-nz'
	Copyright = '(c) Roger Brown. All rights reserved.'
	FunctionsToExport = @()
	CmdletsToExport = @('New-$ModuleName')
	VariablesToExport = '*'
	AliasesToExport = @()
	PrivateData = @{
		PSData = @{
		}
	}
}
"@ | Set-Content -Path "$ModuleId/$ModuleId.psd1"

(Get-Content "./README.md")[0..2] | Set-Content -Path "$ModuleId/README.md"

nuget pack "$ModuleName.$Framework.nuspec"

If ( $LastExitCode -ne 0 )
{
	Exit $LastExitCode
}
