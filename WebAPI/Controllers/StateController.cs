using Microsoft.AspNetCore.Mvc;
using WebAPI.Interfaces;
using WebAPI.Models;

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

        [HttpGet]
        [Route("getstate/{abbreviation}")]
        public IActionResult GetStateByAbbreviation(string abbreviation)
        {
            var stateData = _stateRepository.GetStateByAbbreviation(abbreviation);

            return Ok(stateData);
        }

        [HttpPost]
        [Route("addstate")]
        public IActionResult UpdateStatesMeta(StatesMeta state)
        {
            var rowsAffected = _stateRepository.AddNewState(state);
            return Ok(state);
        }

        [HttpDelete]
        [Route("deletestate/{abbreviation}")]
        public IActionResult RemoveState(string abbreviation)
        {
            var rowsAffected = _stateRepository.DeleteState(abbreviation);

            return Ok(rowsAffected);
        }
    }
}