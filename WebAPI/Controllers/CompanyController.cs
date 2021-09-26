using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Models;
using WebAPI.Models;

namespace WebAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CompanyController : ControllerBase
    {
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
    }
}