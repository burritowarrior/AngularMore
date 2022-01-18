using System;

namespace WebAPI.Models
{
    public class ActiveRate
    {
        public string Description { get; set; }
        public decimal Amount { get; set; }
        public decimal Tax { get; set; }

        public decimal Rate => Amount + Tax;
    }

    public class BaseRate : ActiveRate
    {
        public string CompanyId { get; set; }
        public string StallType { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
    }
}