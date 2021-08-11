using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Models;

namespace WebAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BaseRateController : ControllerBase
    {
        [HttpPost]
        [Route("InsertData")]
        public IActionResult InsertData(SimpleRate simpleCity)
        {
            try {
                var gr = new DAL.GenericRepository<SimpleRate>(true);
                var results = gr.Add(simpleCity);
                
            } catch (Exception ex) {
                return BadRequest(ex.Message);
            }   

            return Ok(simpleCity); 
        }        
    }
}