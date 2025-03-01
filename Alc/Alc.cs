// Copyright (c) 2025 Roger Brown.
// Licensed under the MIT License.

namespace RhubarbGeekNz.OracleConnection
{
    public class OracleConnectionFactory
    {
        static public System.Data.Common.DbConnection CreateInstance(string ConnectionString)
        {
            return new Oracle.ManagedDataAccess.Client.OracleConnection(ConnectionString);
        }
    }
}
