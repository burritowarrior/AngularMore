using Microsoft.AspNetCore.Mvc;
using WebAPI.Interfaces;

namespace WebAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class StateController : ControllerBase
    {
        private IStateRepository _stateRepository;

        public StateController(IStateRepository stateRepository)
        {
            _stateRepository = stateRepository;
        }

        [HttpGet]
        [Route("getallstates")]
        public IActionResult GetStates()
        {
            var stateData = _stateRepository.GetAll();

            return Ok(stateData);
        } 
    }
}