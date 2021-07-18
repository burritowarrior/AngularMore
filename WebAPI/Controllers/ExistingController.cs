using System;
using Microsoft.AspNetCore.Mvc;
using Serilog;
using Serilog.Core;

namespace WebAPI.Controllers
{    
    [Route("api/[controller]")]
    [ApiController]
    public class ExistingController : ControllerBase    
    {
        // private readonly Serilog.Core.Logger _log;
        [HttpGet]
        [Route("rates/{lotNumber}")]
        public IActionResult GetRates(string lotNumber)
        {
            // IEnumerable<BaseRate>
            // > dotnet dev-certs https --trust

            // return BadRequest("An error has occurred...");

            // _log.Information("Inside rate retrieval");
            var dataLayer = new DAL.DataLayer();
            var rates = dataLayer.GetBaseRates(lotNumber);

            return Ok(rates);
        }

        [HttpGet]
        [Route("parkerprofile/{lotNumber}")]
        public async System.Threading.Tasks.Task<IActionResult> GetParkerProfile(string lotNumber) 
        {
            // https://stackoverflow.com/questions/60197270/jsonexception-a-possible-object-cycle-was-detected-which-is-not-supported-this

            try {
                var asyncLayer = new DAL.AsyncLayer();
                var results = await asyncLayer.GetParkerProfiles(lotNumber);
                // _log.Information("I have the information");

                return Ok(results);
            } catch (Exception ex) {
                // _log.Information($"An error occurred... {ex.Message}");
                return BadRequest(ex.Message);
            }

            
        }        
    }
}