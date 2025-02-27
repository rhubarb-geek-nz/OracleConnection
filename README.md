# OracleConnection

Very simple `PowerShell` module for creating a connection to an `Oracle` database.

Build the modules with `dotnet`

```
dotnet publish OracleConnection.csproj --configuration Release
```

Install by copying the modules into a directory on the [PSModulePath](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_psmodulepath).

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
