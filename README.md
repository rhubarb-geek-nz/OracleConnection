# OracleConnection

Very simple `PowerShell` module for creating a connection to an `Oracle` database.

Build using the `package.ps1` script to create the `rhubarb-geek-nz.OracleConnection.3.21.90.nupkg` file.

```
$ unzip -l rhubarb-geek-nz.OracleConnection.3.21.90.nupkg
Archive:  rhubarb-geek-nz.OracleConnection.3.21.90.nupkg
  Length      Date    Time    Name
---------  ---------- -----   ----
      522  03-16-2023 04:50   _rels/.rels
      784  03-16-2023 04:50   rhubarb-geek-nz.OracleConnection.nuspec
      103  03-16-2023 03:50   README.md
     7652  09-30-2017 05:16   LICENSE.LGPL3
     6467  07-27-2022 22:57   LICENSE.Oracle
     5120  03-16-2023 03:50   OracleConnection.dll
  4585608  01-11-2023 01:17   Oracle.ManagedDataAccess.dll
      383  03-16-2023 03:50   rhubarb-geek-nz.OracleConnection.psd1
      712  03-16-2023 04:50   [Content_Types].xml
      675  03-16-2023 04:50   package/services/metadata/core-properties/4d03c99a6b994d8f971d7e292f64fee7.psmdcp
---------                     -------
  4608026                     10 files
```

Install by unzipping into a directory on the [PSModulePath](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_psmodulepath)

Create a database

```
$ docker run --detach --publish 1521:1521 --name oracle-xe orangehrm/oracle-xe-11g
```

When it is up and running, login

```
$ sqlplus sys/oracle@localhost:1521 as sysdba
```

Then create a user

```
SQL> CREATE USER Scott IDENTIFIED BY tiger;

SQL> GRANT CREATE SESSION TO Scott;
```

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
