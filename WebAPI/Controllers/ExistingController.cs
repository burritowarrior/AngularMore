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
            var dataLayer = new DAL.DataLayer();
            var rates = dataLayer.GetBaseRates(lotNumber);

            return Ok(rates);
        }        
    }
}