using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using DAL.Repository;
using Dapper;

namespace DAL
{
    public class GenericRepository<T> : IGenericRepository<T> where T : class
    {
        private IEnumerable<T> dto;
        private string _connectionString = @"";

        public GenericRepository()
        {
            _connectionString = @"Server=TITANIA\SQLSTD2017;Database=AcePark;User Id=aceparkuser;Password=aceparkuser;";
        }

        public IEnumerable<T> All(string id)
        {
            using var sqlConn = new SqlConnection(_connectionString);
            sqlConn.Open();
            var procedure = "[MRP].[SimpleParker]";
            var values = new { LotNumber = id };

            return sqlConn.Query<T>(procedure, values, commandType: CommandType.StoredProcedure).AsList<T>();
        }

        public T FindById(string procedure, Dictionary<string, object> propParameters)
        {
            using var sqlConn = new SqlConnection(_connectionString);
            sqlConn.Open();

            var theParams = new DynamicParameters();
            foreach  (KeyValuePair<string, object> kvp in propParameters) {
                theParams.Add($"@{kvp.Key}", kvp.Value);
            }

            return sqlConn.QueryFirst<T>(procedure, theParams, commandType: CommandType.StoredProcedure);
        }
    }
}