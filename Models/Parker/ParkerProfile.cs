using System;

namespace Models.Parker
{
    public class ParkerProfile
    {
        public string ParkerId { get; set; }
        public string ParkingStallType { get; set; }
        public string LotNumber { get; set; }
        public string CompanyId { get; set; }
        public string CompanyName { get; set; }
        public string LastName { get; set; }
        public string FirstName { get; set; }
        public string Address { get; set; }
        public string AddressLine { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string ZipCode { get; set; }
        public string Phone { get; set; }
        public string EmailAddress { get; set; }
        public string Active { get; set; }
        public string CardNumber { get; set; }
        public string PayType { get; set; }
        public int RateNumber { get; set; }
        public decimal Rate { get; set; }
        public bool TaxExempt { get; set; }
        public string DeliveryType { get; set; }
        public string ParkerPayType { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string Group { get; set; }        
    }
}