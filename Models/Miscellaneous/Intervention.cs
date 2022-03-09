using System;
using System.ComponentModel.DataAnnotations;

namespace Models.Miscellaneous
{
    public class Intervention
    {
        [Key]
        public int InterventionId { get; set; }
        public int GoalId { get; set; }
        public string InterventionReason { get; set; }
        public DateTime InterventionDate { get; set; }
        public DateTime DateEntered { get; set; }
    }

}