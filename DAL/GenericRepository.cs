using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using DAL.Repository;
using Dapper;

namespace DAL
{
    public class GenericRepository<T> : IGenericRepository<T> where T : class
    {
         private string _connectionString = @"";
        private string _developmentString = @"Server=TITANIA\SQLSTD2017;Database=Development;User Id=aceparkuser;Password=aceparkuser;";

        public GenericRepository(bool useDevelopmentDatabase = false)
        {
            _connectionString = @"Server=TITANIA\SQLSTD2017;Database=AcePark;User Id=aceparkuser;Password=aceparkuser;";

            if (useDevelopmentDatabase)
            {
                _connectionString = _developmentString;
            }
        }

        public IEnumerable<T> All(string procedure, Dictionary<string, object> propParameters = null)
        {
            using var sqlConn = new SqlConnection(_connectionString);
            sqlConn.Open();

            var theParams = propParameters == null ? null : new DynamicParameters();
            if (theParams != null)
            {
                foreach (KeyValuePair<string, object> kvp in propParameters)
                {
                    theParams.Add($"@{kvp.Key}", kvp.Value);
                }
            }

            return sqlConn.Query<T>(procedure, theParams, commandType: CommandType.StoredProcedure).AsList<T>();
        }

        public T FindById(string procedure, Dictionary<string, object> propParameters)
        {
            using var sqlConn = new SqlConnection(_connectionString);
            sqlConn.Open();

            var theParams = new DynamicParameters();
            foreach (KeyValuePair<string, object> kvp in propParameters)
            {
                theParams.Add($"@{kvp.Key}", kvp.Value);
            }

            return sqlConn.QueryFirst<T>(procedure, theParams, commandType: CommandType.StoredProcedure);
        }
        public bool Add(T entity)
        {
            int rowsAffected = 0;
            using (IDbConnection db = new SqlConnection(_connectionString))
            {
                var sqlQuery = entity.GenerateInsertStatement<T>();
                rowsAffected = db.Execute(sqlQuery, entity);
            }

            return rowsAffected > 0;
        }

        public bool Update(T entity)
        {
            int rowsAffected = 0;
            using (IDbConnection db = new SqlConnection(_connectionString))
            {
                var sqlQuery = entity.GenerateUpdateStatement<T>();
                rowsAffected = db.Execute(sqlQuery, entity);
            }

            return rowsAffected > 0;
        }

        public T FindById(int Id)
        {
            throw new System.NotImplementedException();
        }
    }
}