using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace Models.Miscellaneous
{
    public class Login
    {
        [Key]   
        public int Id { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string EmployeeName { get; set; }
        public string City { get; set; }
        public string Department { get; set; }
    }
}