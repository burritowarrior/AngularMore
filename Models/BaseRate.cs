using System;

namespace Models
{
    public class BaseRate
    {
        public int BaseRateId { get; set; }
        public string LotNumber { get; set; }
        public int StallTypeId { get; set; }
        public int RateNumber { get; set; }
        public string Description { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public decimal Amount { get; set; }
        public int ChildBaseRateId { get; set; }
        public string Username { get; set; }
        public DateTime DateEntered { get; set; }
        public bool IsAvailable { get; set; }
        public string RateType { get; set; }
        public bool IsPortalRate { get; set; }
        public int MarketRateId { get; set; }
        public bool IsCleaned { get; set; }
        public int NewRateNumber { get; set; }
        public bool IsRowLocked { get; set; }
    }
}