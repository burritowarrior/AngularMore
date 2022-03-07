using System;
using Microsoft.AspNetCore.Mvc;
using Models.Miscellaneous;
using Serilog;
using Serilog.Core;

namespace WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ProgramController : ControllerBase
    {
        private readonly Logger _log;

        public ProgramController()
        {
            _log = new LoggerConfiguration()
                .WriteTo.File(@".\output_log.txt", shared: true, rollingInterval: RollingInterval.Day)
                .CreateLogger();
        }

        [HttpGet]
        [Route("allprograms")]
        public IActionResult GetAllPrograms()
        {
            try {
                var gr = new DAL.GenericRepository<AllProgram>(false, true);               
                var programs = gr.All("[CHG].[GetAllPrograms]", null);

                _log.Write(Serilog.Events.LogEventLevel.Information, @"Successfully retrieved promotions");

                return Ok(programs);
            } catch (Exception ex) {
                return BadRequest(ex.Message);
            }    
        }        
    }
}