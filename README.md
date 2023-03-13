# OracleConnection

Very simple `PowerShell` module for creating a connection to an `Oracle` database.

Build using the `package.ps1` script to create the `OracleConnection-netstandard2.1-3.21.90.zip` file.

```
$ unzip -l OracleConnection-netstandard2.1-3.21.90.zip
Archive:  OracleConnection-netstandard2.1-3.21.90.zip
  Length      Date    Time    Name
---------  ---------- -----   ----
     7652  09-30-2017 07:16   OracleConnection/LICENSE.LGPL3
     6467  07-28-2022 00:57   OracleConnection/LICENSE.Oracle
  4585608  01-11-2023 02:17   OracleConnection/Oracle.ManagedDataAccess.dll
     5120  03-13-2023 19:32   OracleConnection/OracleConnection.dll
      383  03-13-2023 19:32   OracleConnection/OracleConnection.psd1
---------                     -------
  4605230                     5 files
  ```

Install by unzipping into a directory on the [PSModulePath](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_psmodulepath)

Run the `test.ps1` to confirm it works.

```

BANNER
------
Oracle Database 11g Express Edition Release 11.2.0.2.0 - 64bit Production
PL/SQL Release 11.2.0.2.0 - Production
CORE	11.2.0.2.0	Production
TNS for Linux: Version 11.2.0.2.0 - Production
NLSRTL Version 11.2.0.2.0 - Production

```
The following scripts can be used to make formal packages for specific [RID](https://learn.microsoft.com/en-us/dotnet/core/rid-catalog).

| Script | RID | Framework | Installation Directory |
| ------ | --- | --------- | ---------------------- |
| makemsi.ps1 | win | net481 | c:\Program Files\WindowsPowerShell\Modules\OracleConnection |
| makemsi.ps1 | win | netstandard2.1 | c:\Program Files\PowerShell\Modules\OracleConnection |
| makeosx.ps1 | osx | netstandard2.1 | /usr/local/share/powershell/Modules/OracleConnection |
| makedeb.ps1 | linux | netstandard2.1 | /opt/microsoft/powershell/7/Modules/OracleConnection |
| makerpm.ps1 | linux | netstandard2.1 | /opt/microsoft/powershell/7/Modules/OracleConnection |

## Building MSI for Windows

Building requires [dotnet-sdk](https://dotnet.microsoft.com/en-us/download) and [WiX](https://wixtoolset.org).

Build the `netstandard2.1` version for PowerShell Core 7

```
D:\powershell-oracle>pwsh
PowerShell 7.3.3
PS D:\powershell-oracle> .\package.ps1
MSBuild version 17.5.0-preview-23061-01+040e2a90e for .NET
  Determining projects to restore...
  Restored D:\powershell-oracle\OracleConnection.csproj (in 659 ms).
  OracleConnection -> D:\powershell-oracle\bin\Release\netstandard2.1\OracleConnection.dll
  OracleConnection -> D:\powershell-oracle\bin\Release\netstandard2.1\publish\
PS D:\powershell-oracle> .\makemsi.ps1
OracleConnection.netstandard2.1.wxs
OracleConnection.netstandard2.1.wxs
```

Build the `net481` version for Windows PowerShell 5

```
D:\powershell-oracle>pwsh
PowerShell 7.3.3
PS D:\powershell-oracle> .\package.ps1 -Framework net481
MSBuild version 17.5.0-preview-23061-01+040e2a90e for .NET
  Determining projects to restore...
  Restored D:\powershell-oracle\OracleConnection.csproj (in 253 ms).
  OracleConnection -> D:\powershell-oracle\bin\Release\net481\OracleConnection.dll
  OracleConnection -> D:\powershell-oracle\bin\Release\net481\publish\
PS D:\powershell-oracle> .\makemsi.ps1
OracleConnection.net481.wxs
OracleConnection.net481.wxs
```

## Build `osx` package on macOS

```
% pwsh
PowerShell 7.3.3
PS /Users/rhubarb/powershell-oracle> ./package.ps1
MSBuild version 17.5.0-preview-23061-01+040e2a90e for .NET
  Determining projects to restore...
  Restored /Users/rhubarb/powershell-oracle/OracleConnection.csproj (in 660 ms).
  OracleConnection -> /Users/rhubarb/powershell-oracle/bin/Release/netstandard2.1/OracleConnection.dll
  OracleConnection -> /Users/rhubarb/powershell-oracle/bin/Release/netstandard2.1/publish/
PS /Users/rhubarb/powershell-oracle> ./makeosx.ps1                                                 
pkgbuild: Inferring bundle components from contents of root
pkgbuild: Using timestamp authority for signature
pkgbuild: Signing package with identity "Developer ID Installer: Roger Brown (S8EJ4SNLNS)"
pkgbuild: Adding certificate "Developer ID Certification Authority"
pkgbuild: Adding certificate "Apple Root CA"
pkgbuild: Wrote package to OracleConnection.pkg
productbuild: Using timestamp authority for signature
productbuild: Signing product with identity "Developer ID Installer: Roger Brown (S8EJ4SNLNS)"
productbuild: Adding certificate "Developer ID Certification Authority"
productbuild: Adding certificate "Apple Root CA"
productbuild: Wrote product to OracleConnection-3.21.90-osx.pkg
```

## Build `deb` on Debian or Ubuntu

```
$ pwsh
PowerShell 7.3.3
PS /home/bythesea/powershell-oracle> ./package.ps1
MSBuild version 17.3.2+561848881 for .NET
  Determining projects to restore...
  Restored /home/bythesea/powershell-oracle/OracleConnection.csproj (in 23.58 sec).
  OracleConnection -> /home/bythesea/powershell-oracle/bin/Release/netstandard2.1/OracleConnection.dll
  OracleConnection -> /home/bythesea/powershell-oracle/bin/Release/netstandard2.1/publish/
PS /home/bythesea/powershell-oracle> ./makedeb.ps1 -Maintainer foo@bar
dpkg-deb: building package 'rhubarb-geek-nz-oracleconnection' in 'rhubarb-geek-nz-oracleconnection_3.21.90_all.deb'.
```

## Build `rpm` on Fedora or Mariner 2.0

```
$ pwsh
PowerShell 7.3.3
PS /home/bythesea/powershell-oracle> ./package.ps1
MSBuild version 17.5.0-preview-23061-01+040e2a90e for .NET
  Determining projects to restore...
  Restored /home/bythesea/powershell-oracle/OracleConnection.csproj (in 17.16 sec).
  OracleConnection -> /home/bythesea/powershell-oracle/bin/Release/netstandard2.1/OracleConnection.dll
  OracleConnection -> /home/bythesea/powershell-oracle/bin/Release/netstandard2.1/publish/
PS /home/bythesea/powershell-oracle> ./makerpm.ps1 -Maintainer foo@bar
Processing files: rhubarb-geek-nz-OracleConnection-3.21.90-1.noarch
Provides: rhubarb-geek-nz-OracleConnection = 3.21.90-1
Requires(rpmlib): rpmlib(CompressedFileNames) <= 3.0.4-1 rpmlib(FileDigests) <= 4.6.0-1 rpmlib(PayloadFilesHavePrefix) <= 4.0-1
Checking for unpackaged file(s): /usr/lib/rpm/check-files /home/bythesea/powershell-oracle/root
Wrote: /home/bythesea/powershell-oracle/rpms/noarch/rhubarb-geek-nz-OracleConnection-3.21.90-1.noarch.rpm
```
