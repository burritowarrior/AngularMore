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
    public class LoginController : ControllerBase
    {
        private readonly Logger _log;
        private readonly bool _useDevelopmentDatabase;

        public LoginController()
        {
            _log = new LoggerConfiguration()
                .WriteTo.File(@".\output_log.txt", shared: true, rollingInterval: RollingInterval.Day)
                .CreateLogger();
            _useDevelopmentDatabase = true;
        }

        [HttpGet]
        [Route("alllogins")]
        public IActionResult GetAllLogins()
        {
            try {
                var gr = new DAL.GenericRepository<Login>(_useDevelopmentDatabase);               
                var promotions = gr.All("[DEV].[GetAllLogins]", null);

                _log.Write(Serilog.Events.LogEventLevel.Information, @"Successfully retrieved logins");

                return Ok(promotions);
            } catch (Exception ex) {
                return BadRequest(ex.Message);
            }    
        }

        [HttpPost]
        [Route("addlogin")]
        public IActionResult AddNewLogin(Login login)
        {
            try {
                var gr = new DAL.GenericRepository<Login>(_useDevelopmentDatabase);               
                var success = gr.Add(login, "DEV");

                _log.Write(Serilog.Events.LogEventLevel.Information, @"Successfully added new promotion");

                return Ok(login);
            } catch (Exception ex) {
                return BadRequest(ex.Message);
            }    
        }

        [HttpDelete]
        [Route("deletelogin")]
        
        public IActionResult DeleteOnePromotion(Login login)
        {
            try {
                var gr = new DAL.GenericRepository<Login>(_useDevelopmentDatabase);               
                gr.Delete(login, "DEV");

                return Ok(login);
            } catch (Exception ex) {
                return BadRequest(ex.Message);
            }    
        }
    }
}