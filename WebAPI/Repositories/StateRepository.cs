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
    }
}