using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using WebAPI.Interfaces;
using WebAPI.Models;

namespace WebAPI.Repositories
{
    public class StateRepository : IStateRepository
    {
        private string _developmentString = @"Server=TITANIA\SQLSTD2017;Database=Development;User Id=aceparkuser;Password=aceparkuser;";
        private string _query = "SELECT StateName, Abbreviation, Capital, [Population], Area, DateEntered, DateRank FROM StatesMeta";
        public IEnumerable<StatesMeta> GetAll()
        {
            var statesData = new List<StatesMeta>();

            using (var sqlConnection = new SqlConnection(_developmentString))
            using (var sqlCommand = new SqlCommand(_query, sqlConnection))
            {
                sqlConnection.Open();
                var reader = sqlCommand.ExecuteReader();
                if (reader.HasRows) {
                    while (reader.Read()) {
                        var state = new StatesMeta 
                        {
                            StateName = reader["StateName"].ToString(),
                            Abbreviation = reader["Abbreviation"].ToString(),
                            Capital = reader["Capital"].ToString(),
                            Population = Convert.ToInt32(reader["Population"].ToString()),
                            Area = Convert.ToInt32(reader["Area"].ToString()),
                            DateEntered = Convert.ToDateTime(reader["DateEntered"].ToString()),
                            DateRank = Convert.ToInt32(reader["DateRank"].ToString())
                        };

                        statesData.Add(state);
                    }
                }
            }

            return statesData;
        }

        public StatesMeta GetStateByAbbreviation(string abbreviation)
        {
            var statesData = new StatesMeta();
            var _query = "SELECT StateName, Abbreviation, Capital, [Population], Area, DateEntered, DateRank FROM StatesMeta WHERE Abbreviation = @Abbreviation";

            using (var sqlConnection = new SqlConnection(_developmentString))
            using (var sqlCommand = new SqlCommand(_query, sqlConnection))
            {
                sqlConnection.Open();
                sqlCommand.Parameters.Add("@Abbreviation", System.Data.SqlDbType.VarChar, 12).Value = abbreviation;

                var reader = sqlCommand.ExecuteReader();
                if (reader.HasRows) {
                    while (reader.Read()) {
                        statesData = new StatesMeta 
                        {
                            StateName = reader["StateName"].ToString(),
                            Abbreviation = reader["Abbreviation"].ToString(),
                            Capital = reader["Capital"].ToString(),
                            Population = Convert.ToInt32(reader["Population"].ToString()),
                            Area = Convert.ToInt32(reader["Area"].ToString()),
                            DateEntered = Convert.ToDateTime(reader["DateEntered"].ToString()),
                            DateRank = Convert.ToInt32(reader["DateRank"].ToString())
                        };
                    }
                }
            }

            return statesData;
        }

        public int AddNewState(StatesMeta state)
        {
            var rowsAffected = 0;

            using (var sqlConnection = new SqlConnection(_developmentString))
            using (var sqlCommand = new SqlCommand("InsertStatesMeta", sqlConnection))
            {
                sqlConnection.Open();
                sqlCommand.CommandType = System.Data.CommandType.StoredProcedure;

                sqlCommand.Parameters.Add("@StateName", System.Data.SqlDbType.VarChar, 64).Value = state.StateName;
                sqlCommand.Parameters.Add("@Abbreviation", System.Data.SqlDbType.VarChar, 12).Value = state.Abbreviation;
                sqlCommand.Parameters.Add("@Capital", System.Data.SqlDbType.VarChar, 64).Value = state.Capital;
                sqlCommand.Parameters.Add("@Population", System.Data.SqlDbType.Int).Value = state.Population;
                sqlCommand.Parameters.Add("@Area", System.Data.SqlDbType.Int).Value = state.Area;
                sqlCommand.Parameters.Add("@DateEntered", System.Data.SqlDbType.DateTime).Value = state.DateEntered;
                sqlCommand.Parameters.Add("@DateRank", System.Data.SqlDbType.Int).Value = state.DateRank;

                rowsAffected = sqlCommand.ExecuteNonQuery();
            }

            return rowsAffected;

        }
    }
}