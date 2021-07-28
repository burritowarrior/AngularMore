using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Models;
using Models.Parker;

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
            var dataLayer = new DAL.DataLayer();
            var rates = dataLayer.GetBaseRates(lotNumber);

            return Ok(rates);
        }

        [HttpGet]
        [Route("parkerprofile/{lotNumber}")]
        public async Task<IActionResult> GetParkerProfile(string lotNumber) 
        {
            // https://stackoverflow.com/questions/60197270/jsonexception-a-possible-object-cycle-was-detected-which-is-not-supported-this

            try {
                var asyncLayer = new DAL.AsyncLayer();
                var results = await asyncLayer.GetParkerProfiles(lotNumber);
                 return Ok(results);
            } catch (Exception ex) {
                return BadRequest(ex.Message);
            }           
        }     

        [HttpGet]
        [Route("simpleparker/{parkerId}")]
        public IActionResult GetSimpleParker(string parkerId)
        {
            try {
                var gr = new DAL.GenericRepository<SimpleParker>();
                FluentParameter fp = new FluentParameter();
                fp.ParkerId(parkerId);
                
                var simpleParker = gr.FindById("[MRP].[SimpleParker]", fp.KeyData);
                 return Ok(simpleParker);
            } catch (Exception ex) {
                return BadRequest(ex.Message);
            }    
        }

        [HttpPost]
        [Route("InsertData")]
        public IActionResult InsertData(City simpleCity)
        {
            try {
                var gr = new DAL.GenericRepository<City>(true);
                var results = gr.Add(simpleCity);
                
                return Ok(simpleCity);
            } catch (Exception ex) {
                return BadRequest(ex.Message);
            }    
        }

        [HttpPatch]
        [Route("UpdateData")]
        public IActionResult Update(City simpleCity)
        {
            try {
                var gr = new DAL.GenericRepository<City>(true);
                var results = gr.Update(simpleCity);
                
                return Ok(simpleCity);
            } catch (Exception ex) {
                return BadRequest(ex.Message);
            }    
        }          
    }
}