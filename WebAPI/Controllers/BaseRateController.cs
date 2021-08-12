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
                return BadRequest(new { Status = false, Message = ex.Message });
            }   

            return Ok(new { Status = true, Message = "Item successfully inserted" }); 
        }        
    }
}