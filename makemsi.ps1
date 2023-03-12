#!/usr/bin/env pwsh
#
#  Copyright 2023, Roger Brown
#
#  This file is part of rhubarb-geek-nz/OracleConnection.
#
#  This program is free software: you can redistribute it and/or modify it
#  under the terms of the GNU General Public License as published by the
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
	$ModuleName = "OracleConnection"
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

trap
{
	throw $PSItem
}

$env:SOURCEDIR="$ModuleName"
$env:ORACLEVERS=( Import-PowerShellDataFile "$ModuleName/$ModuleName.psd1" ).ModuleVersion

foreach ($List in @(
	@("no","D70D1292-B0EC-4850-95A1-064B6B4BD253","net481","x86","ProgramFilesFolder","21.9.0"),
	@("no","3CB5B7B0-E752-44DD-8B44-994AAEBD89F9","netstandard2.1","x86","ProgramFilesFolder","3.21.90"),
	@("yes","2BDA83D2-96F0-4DA7-86F6-EA6628F93699","net481","x64","ProgramFiles64Folder","21.9.0"),
	@("yes","311CE1FF-C530-43F3-B093-D44A6A673655","netstandard2.1","x64","ProgramFiles64Folder","3.21.90")
))
{
	$env:ORACLEISWIN64=$List[0]
	$env:ORACLEUPGRADECODE=$List[1]
	$env:ORACLEFRAMEWORK=$List[2]
	$env:ORACLEPLATFORM=$List[3]
	$env:ORACLEPROGRAMFILES=$List[4]

	If ( $env:ORACLEVERS -eq $List[5] )
	{
		$MSINAME = "$ModuleName-$env:ORACLEFRAMEWORK-$env:ORACLEVERS-$env:ORACLEPLATFORM.msi"

		foreach ($Name in "$MSINAME")
		{
			if (Test-Path "$Name")
			{
				Remove-Item "$Name"
			} 
		}

		& "${env:WIX}bin\candle.exe" -nologo "$ModuleName.$env:ORACLEFRAMEWORK.wxs"

		if ($LastExitCode -ne 0)
		{
			exit $LastExitCode
		}

		& "${env:WIX}bin\light.exe" -nologo -cultures:null -out "$MSINAME" "$ModuleName.$env:ORACLEFRAMEWORK.wixobj"

		if ($LastExitCode -ne 0)
		{
			exit $LastExitCode
		}
	}
}
