using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers
{    
    [Route("api/[controller]")]
    [ApiController]
        public class ExistingController : ControllerBase
    {
        [HttpGet]
        [Route("rates/{lotNumber}")]
        public IActionResult GetRates(string lotNumber)
        {
            // IEnumerable<BaseRate>
            // > dotnet dev-certs https --trust

            // return BadRequest("An error has occurred...");

            // _log.Information("Inside rate retrieval");

            // using var sqlConn = new SqlConnection(_connectionString);
            // sqlConn.Open();
            // var rates = sqlConn.Query<BaseRate>($"SELECT BaseRateId, LotNumber, ParkingStallType, " +
            //                                     "RateNumber, [Description], StartDate, EndDate, Amount, ChildBaseRateId, " +
            //                                     "Username, DateEntered, IsAvailable, RateType, " +
            //                                     "IsPortalRate, MarketRateId, IsCleaned, NewRateNumber, " +
            //                                     $"IsRowLocked FROM [MRP].[vw_Rates] WHERE LotNumber = '{lotNumber}'").ToList();

            var dataLayer = new DAL.DataLayer();
            var rates = dataLayer.GetBaseRates(lotNumber);

            return Ok(rates);
        }        
    }
}