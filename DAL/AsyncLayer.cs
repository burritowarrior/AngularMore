using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;
using Dapper;
using Models;
using Models.Company;

namespace DAL
{
    public class AsyncLayer
    {
        private string _connectionString = @"";

        public AsyncLayer()
        {
            _connectionString = @"Data Source=TITANIA\SQLSTD2017;Initial Catalog=AcePark;User Id=aceparkuser;Password=aceparkuser";
        }

        public async Task<ParkerProfileModel> GetParkerProfiles(string lotNumber)
        {
            // > dotnet dev-certs https --trust

            await using var sqlConn = new SqlConnection(_connectionString);
            sqlConn.Open();
            var procedure = "[MRP].[usp_GetParkerProfile]";
            var values = new { LotNumber = lotNumber };
            // var results = sqlConn.Query(procedure, values, commandType: CommandType.StoredProcedure);

            var result =
                await sqlConn.QueryMultipleAsync(procedure, values, commandType: CommandType.StoredProcedure);

            var parkerProfileModel = new ParkerProfileModel
            {
                ParkerProfiles = await result.ReadAsync<Models.Parker.ParkerProfile>(),
                CompanyList = await result.ReadAsync<CompanyList>()
            };

            return parkerProfileModel;

            // return sqlConn.Query<ParkerProfileModel>("[MRP].[usp_GetParkerProfile]", values, commandType: CommandType.StoredProcedure);
        }

    }
}