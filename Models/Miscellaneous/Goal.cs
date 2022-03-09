using System;
using System.ComponentModel.DataAnnotations;

namespace Models.Miscellaneous
{
    public class Goal
    {
        [Key]
        public int GoalId { get; set; }
        public string Problem { get; set; }
        public string DesiredGoal { get; set; }
        public DateTime GoalDate { get; set; }
        public string Barrier { get; set; }
        public DateTime DateEntered { get; set; }
        
        // interventions: Intervention[];
    }
}