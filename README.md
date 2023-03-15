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
