using System;
using Microsoft.AspNetCore.Mvc;
using Models;
using Serilog;
using Serilog.Core;
using WebAPI.Models;

namespace WebAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CompanyController : ControllerBase
    {
        private readonly Logger _log;
        // private readonly bool _useDevelopmentDatabase;

        public CompanyController()
        {
            _log = new LoggerConfiguration()
                .WriteTo.File(@"C:\inetpub\logs\WebAPI\output_log.txt", shared: true, rollingInterval: RollingInterval.Day)
                .CreateLogger();
            // _useDevelopmentDatabase = true;
        }

        [HttpGet]
        [Route("simplecompany/{lotNumber}")]
        public IActionResult GetSimpleCompany(string lotNumber)
        {
            try {
                var gr = new DAL.GenericRepository<SimpleCompany>();
                FluentParameter fp = new FluentParameter().LotNumber(lotNumber);
                
                var simpleParker = gr.All("[MRP].[GetCompaniesByLot]", fp.KeyData);
                return Ok(simpleParker);
            } catch (Exception ex) {
                return BadRequest(ex.Message);
            }    
        }

        [HttpGet]
        [Route("rates/{lotNumber}/{companyId}")]
        public IActionResult GetRatesByLotCompany(string lotNumber, string companyId)
        {
            try {
                var gr = new DAL.GenericRepository<ActiveRate>();
                FluentParameter fp = new FluentParameter().LotNumber(lotNumber).CompanyId(companyId);
                
                var activeRates = gr.All("[MRP].[GetActiveRatesByCompany]", fp.KeyData);
                return Ok(activeRates);
            } catch (Exception ex) {
                return BadRequest(ex.Message);
            }    
        }

        [HttpGet]
        [Route("allrates/{lotNumber}")]
        public IActionResult GetRatesByLot(string lotNumber)
        {
            try {
                var gr = new DAL.GenericRepository<Models.BaseRate>();
                FluentParameter fp = new FluentParameter().LotNumber(lotNumber);
                
                var activeRates = gr.All("[MRP].[GetRatesByLotNumber]", fp.KeyData);
                return Ok(activeRates);
            } catch (Exception ex) {
                return BadRequest(ex.Message);
            }    
        } 

        [HttpPost]
        [Route("addnewcompany")]
        public IActionResult InsertCompany(SimpleCompany newCompany)
        {
            try {
                var gr = new DAL.GenericRepository<SimpleCompany>(false);
                var results = gr.AddObject(newCompany, "[DEV].[AddCompany]", "DEV");

                _log.Write(Serilog.Events.LogEventLevel.Information, @"Successfully added new company");
                _log.Information("This is awesome...");
                
                return Ok(newCompany);
            } catch (Exception ex) {
                _log.Write(Serilog.Events.LogEventLevel.Information, $@"Error: {ex.StackTrace} ");
                return BadRequest(ex.Message + " - " + ex.StackTrace);
            }    
        }
    }
}