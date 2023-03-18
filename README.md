# OracleConnection

Very simple `PowerShell` module for creating a connection to an `Oracle` database.

Use `package.ps1` to create the module.

Install by copying into a directory on the [PSModulePath](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_psmodulepath).

You can publish directly to a repository using [Publish-Module](https://learn.microsoft.com/en-us/powershell/module/powershellget/publish-module?view=powershell-7.3).

You can create a package using

```
$ nuget pack OracleConnection.netstandard2.1.nuspec
Attempting to build package from 'OracleConnection.netstandard2.1.nuspec'.
...
Successfully created package 'rhubarb-geek-nz.OracleConnection.3.21.90.nupkg'.
```

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
