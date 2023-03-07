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

Get-ChildItem -Path "$BINDIR" -Filter "Oracle*" | Foreach-Object {
	Copy-Item -Path $_.FullName -Destination "OracleConnection"
}

[string]$text = (Invoke-WebRequest -Uri "https://www.nuget.org/packages/Oracle.ManagedDataAccess.Core/3.21.90/License").Content

$preOffset = $text.IndexOf('<pre class')

$endOffset = $text.IndexOf('</pre>',$preOffset)

$pre = $text.Substring($preOffset,$endOffset-$preOffset+6)

$xmlDoc = [System.Xml.XmlDocument]($pre)

$xmlDoc.DocumentElement.FirstChild.Value | Out-File -FilePath "OracleConnection/LICENSE.Oracle"

$null = Invoke-WebRequest -Uri "https://www.gnu.org/licenses/lgpl-3.0.txt" -OutFile "OracleConnection/LICENSE.LGPL3"

Compress-Archive -Path "OracleConnection" -DestinationPath "OracleConnection.zip"
