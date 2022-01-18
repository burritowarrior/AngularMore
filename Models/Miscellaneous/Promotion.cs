using System;
using System.ComponentModel.DataAnnotations;

namespace Models.Miscellaneous 
{
    public class Promotion
    {
        [Key]
        public int PromotionId { get; set; } 
        public string LotNumber { get; set; }
        public string PromotionName { get; set; } 
        public DateTime StartDate { get; set; } 
        public DateTime EndDate { get; set; } 
        public string CreatedBy { get; set; } 
        public DateTime DateEntered { get; set; } 
    }
}
