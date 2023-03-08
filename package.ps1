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

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"
$BINDIR = "bin/Release/netstandard2.1/publish"

trap
{
	throw $PSItem
}

foreach ($Name in "obj", "bin", "OracleConnection", "OracleConnection.zip")
{
	if (Test-Path "$Name")
	{
		Remove-Item "$Name" -Force -Recurse
	} 
}

dotnet publish OracleConnection.csproj --configuration Release

If ( $LastExitCode -ne 0 )
{
	Exit $LastExitCode
}

$null = New-Item -Path "OracleConnection" -ItemType Directory

foreach ($Filter in "Oracle*", "LICENSE*") {
	Get-ChildItem -Path "$BINDIR" -Filter $Filter | Foreach-Object {
		Copy-Item -Path $_.FullName -Destination "OracleConnection"
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

Copy-Item -Path "$NuGetPackages/oracle.manageddataaccess.core/3.21.90/LICENSE.txt" -Destination "OracleConnection/LICENSE.Oracle"

If (-not($IsWindows))
{
	Get-ChildItem -Path "OracleConnection" -File | Foreach-Object {
		chmod -x $_.FullName
		If ( $LastExitCode -ne 0 )
		{
			Exit $LastExitCode
		}
	}
}
else
{
	$content = [System.IO.File]::ReadAllText("OracleConnection/LICENSE.LGPL3")

	$content.Replace("`u{000D}`u{000A}","`u{000A}") | Out-File "OracleConnection/LICENSE.LGPL3" -Encoding Ascii -NoNewLine
}

$uk = New-Object system.globalization.cultureinfo('en-GB')

$date = [Datetime]::ParseExact('09/30/2017 07:16:26 +00:00', 'MM/dd/yyyy HH:mm:ss zzz', $uk)

Get-ChildItem ""OracleConnection/LICENSE.LGPL3 | Foreach-Object {$_.LastWriteTime = $date}

Compress-Archive -Path "OracleConnection" -DestinationPath "OracleConnection.zip"
