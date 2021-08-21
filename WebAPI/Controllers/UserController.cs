using System;
using Microsoft.AspNetCore.Mvc;
using Models;

namespace WebAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        [HttpGet]
        [Route("alltheusers")]
        public IActionResult GetUsers()
        {
            try {
                var users = new DAL.GenericRepository<User>(true);
                var userData = users.All("[GetAllUsers]");
                return Ok(userData);
            } catch (Exception ex) {
                return BadRequest(ex.Message);
            }
        }
    }
}