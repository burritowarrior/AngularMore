using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Models.Miscellaneous;
using Serilog;
using Serilog.Core;

namespace WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class InterventionController : ControllerBase
    {
        private readonly Logger _log;

        public InterventionController()
        {
            _log = new LoggerConfiguration()
                .WriteTo.File(@"C:\logfiles\output_log.txt", shared: true, rollingInterval: RollingInterval.Day)
                .CreateLogger();
        }

        [HttpGet]
        [Route("allinterventions")]
        public IActionResult GetAllInterventions()
        {
            try {
                var gr = new DAL.GenericRepository<Intervention>();               
                var Goals = gr.All("[MRP].[GetAllInterventions]", null);

                _log.Write(Serilog.Events.LogEventLevel.Information, @"Successfully retrieved Goals");

                return Ok(Goals);
            } catch (Exception ex) {
                return BadRequest(ex.Message);
            }    
        }

        [HttpPost]
        [Route("addintervention")]
        public IActionResult AddNewIntervention(Intervention intervention)
        {
            try {
                var gr = new DAL.GenericRepository<Intervention>(false, true);               
                var success = gr.Add(intervention, "CHG");

                _log.Write(Serilog.Events.LogEventLevel.Information, @"Successfully added new Goal");
                _log.Write(Serilog.Events.LogEventLevel.Information, $"New Identity: {success}");

                return Ok(success);
            } catch (Exception ex) {
                return BadRequest(ex.Message);
            }    
        } 
    }
}