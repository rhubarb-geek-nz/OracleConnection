# OracleConnection

Very simple `PowerShell` module for creating a connection to an `Oracle` database.

Build using the `package.ps1` script to create the `OracleConnection.zip` file.

```
$ unzip -l OracleConnection.zip
Archive:  OracleConnection.zip
  Length      Date    Time    Name
---------  ---------- -----   ----
     7652  03-08-2023 07:55   OracleConnection/LICENSE.LGPL3
     6468  03-08-2023 07:55   OracleConnection/LICENSE.Oracle
  4585608  01-11-2023 02:17   OracleConnection/Oracle.ManagedDataAccess.dll
    12113  03-08-2023 07:55   OracleConnection/OracleConnection.deps.json
     5120  03-08-2023 07:55   OracleConnection/OracleConnection.dll
     8956  03-08-2023 07:55   OracleConnection/OracleConnection.pdb
      385  03-07-2023 19:31   OracleConnection/OracleConnection.psd1
---------                     -------
  4626302                     7 files
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
