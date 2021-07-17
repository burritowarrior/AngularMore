using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using Dapper;
using Models;

namespace DAL
{
    public class DataLayer
    {
        private string _connectionString = @"";

        public DataLayer()
        {
            _connectionString = @"Data Source=TITANIA\SQLSTD2017;Initial Catalog=AcePark;User Id=aceparkuser;Password=aceparkuser";
        }

        public List<BaseRate> GetBaseRates(string lotNumber)
        {
            using var sqlConn = new SqlConnection(_connectionString);
            sqlConn.Open();
            var rates = sqlConn.Query<BaseRate>($"SELECT BaseRateId, LotNumber, ParkingStallType, " +
                                                "RateNumber, [Description], StartDate, EndDate, Amount, ChildBaseRateId, " +
                                                "Username, DateEntered, IsAvailable, RateType, " +
                                                "IsPortalRate, MarketRateId, IsCleaned, NewRateNumber, " +
                                                $"IsRowLocked FROM [MRP].[vw_Rates] WHERE LotNumber = '{lotNumber}'").ToList();

            return rates;
        }
    }
}
