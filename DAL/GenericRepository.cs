using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using DAL.Repository;
using Dapper;

namespace DAL
{
    // https://blog.zhaytam.com/2019/03/14/generic-repository-pattern-csharp/
    public class GenericRepository<T> : IGenericRepository<T>, IGenericObjectRepository<T> where T : class
    {
        private string _connectionString = @"";
        private string _developmentString = @"Server=TITANIA\SQLSTD2017;Database=Development;User Id=aceparkuser;Password=aceparkuser;";
        private string _awString = @"Server=TITANIA\SQLSTD2017;Database=AdventureWorks;User Id=awuser;Password=awuser;";

        public  GenericRepository(bool useDevelopmentDatabase = false)
        {
            _connectionString = @"Server=TITANIA\SQLSTD2017;Database=AcePark;User Id=aceparkuser;Password=aceparkuser;";

            if (useDevelopmentDatabase)
            {
                _connectionString = _developmentString;
            }
        }


        #region IGenericRepository
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

            // var whatever = sqlConn.QueryAsync<T>(procedure, theParams,  commandType: CommandType.StoredProcedure);

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
        public bool Add(T entity, string schema = "dbo")
        {
            int rowsAffected = 0;
            using (IDbConnection db = new SqlConnection(_connectionString))
            {
                var sqlQuery = entity.GenerateInsertStatement<T>(schema);
                rowsAffected = db.Execute(sqlQuery, entity);
            }

            return rowsAffected > 0;
        }

        public bool Update(T entity, string schema = "dbo")
        {
            int rowsAffected = 0;
            using (IDbConnection db = new SqlConnection(_connectionString))
            {
                var sqlQuery = entity.GenerateUpdateStatement<T>(schema);
                rowsAffected = db.Execute(sqlQuery, entity);
            }

            return rowsAffected > 0;
        }

        public T FindById(int id, string procedure, bool useAWConnection = false)
        {
            using var sqlConn = useAWConnection
                ? new SqlConnection(_awString) : new SqlConnection(_connectionString);
            sqlConn.Open();

            var theParams = new DynamicParameters();
            theParams.Add("@Id", id);

            return sqlConn.QueryFirst<T>(procedure, theParams, commandType: CommandType.StoredProcedure);
        }

        public void Delete(T entity, string schema = "dbo")
        {
            int rowsAffected = 0;
            using (IDbConnection db = new SqlConnection(_connectionString))
            {
                var sqlQuery = entity.GenerateDeleteStatement<T>(schema);
                rowsAffected = db.Execute(sqlQuery, entity);
            }
        }
        #endregion
        
        #region IGenericObjectRepository
        public bool AddObject(T entity, string procedure, string schema = "dbo")
        {
            int rowsAffected = 0;
            Type objType = typeof(T);

            using (IDbConnection db = new SqlConnection(_connectionString))
            {
                DynamicParameters dp = new DynamicParameters();

                foreach (var p in objType.GetProperties())
                {
                    dp.Add(p.Name, p.GetValue(entity));
                }

                db.Execute(procedure, dp, commandType: CommandType.StoredProcedure);
            }

            return rowsAffected > 0;
        }
        #endregion
    }
}