using System;
using Microsoft.AspNetCore.Mvc;
using Models.Miscellaneous;
using Serilog;
using Serilog.Core;

namespace WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PromotionController : ControllerBase
    {
        private readonly Logger _log;

        public PromotionController()
        {
            _log = new LoggerConfiguration()
                .WriteTo.File(@".\output_log.txt", shared: true, rollingInterval: RollingInterval.Day)
                .CreateLogger();
        }

        [HttpGet]
        [Route("allpromotions")]
        public IActionResult GetAllPromotions()
        {
            try {
                var gr = new DAL.GenericRepository<Promotion>();               
                var promotions = gr.All("[MRP].[GetAllPromotions]", null);

                _log.Write(Serilog.Events.LogEventLevel.Information, @"Successfully retrieved promotions");

                return Ok(promotions);
            } catch (Exception ex) {
                return BadRequest(ex.Message);
            }    
        }

        [HttpPost]
        [Route("addpromotion")]
        public IActionResult AddNewPromotion(Promotion promotion)
        {
            try {
                var gr = new DAL.GenericRepository<Promotion>();               
                var success = gr.Add(promotion, "MRP");

                _log.Write(Serilog.Events.LogEventLevel.Information, @"Successfully added new promotion");
                _log.Write(Serilog.Events.LogEventLevel.Information, $"New Identity: {success}");

                return Ok(success);
            } catch (Exception ex) {
                return BadRequest(ex.Message);
            }    
        }

        [HttpDelete]
        [Route("deletepromotion")]
        
        public IActionResult DeleteOnePromotion(Promotion promotion)
        {
            try {
                var gr = new DAL.GenericRepository<Promotion>();               
                gr.Delete(promotion, "MRP");

                return Ok(promotion);
            } catch (Exception ex) {
                return BadRequest(ex.Message);
            }    
        }
    }
}