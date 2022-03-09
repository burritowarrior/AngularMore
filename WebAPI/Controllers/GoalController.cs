using System;
using Microsoft.AspNetCore.Mvc;
using Models.Miscellaneous;
using Serilog;
using Serilog.Core;

namespace WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class GoalController : ControllerBase
    {
        private readonly Logger _log;

        public GoalController()
        {
            _log = new LoggerConfiguration()
                .WriteTo.File(@"C:\logfiles\output_log.txt", shared: true, rollingInterval: RollingInterval.Day)
                .CreateLogger();
        }

        [HttpGet]
        [Route("allgoals")]
        public IActionResult GetAllGoals()
        {
            try {
                var gr = new DAL.GenericRepository<Goal>();               
                var Goals = gr.All("[MRP].[GetAllGoals]", null);

                _log.Write(Serilog.Events.LogEventLevel.Information, @"Successfully retrieved Goals");

                return Ok(Goals);
            } catch (Exception ex) {
                return BadRequest(ex.Message);
            }    
        }

        [HttpPost]
        [Route("addgoal")]
        public IActionResult AddNewGoal(Goal goal)
        {
            try {
                var gr = new DAL.GenericRepository<Goal>(false, true);               
                var success = gr.Add(goal, "CHG");

                _log.Write(Serilog.Events.LogEventLevel.Information, @"Successfully added new Goal");
                _log.Write(Serilog.Events.LogEventLevel.Information, $"New Identity: {success}");

                return Ok(success);
            } catch (Exception ex) {
                return BadRequest(ex.Message);
            }    
        }        
    }
}