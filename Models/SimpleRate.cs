using System;

namespace Models
{
    public class SimpleRate
    {
        public string LotNumber { get; set; }
        public string Description { get; set; }
        public decimal Amount { get; set; }        
        public string StallType { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public bool IsPortalRate { get; set; }      
    }
}