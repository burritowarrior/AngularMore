using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebAPI.Models
{
    public class Goal
    {
        public int GoalId { get; set; }
        public string Problem { get; set; }
        public string ProgramGoal { get; set; }
        public DateTime GoalDate { get; set; }
        public string Barrier { get; set; }
    }
}