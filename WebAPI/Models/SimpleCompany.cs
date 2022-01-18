using System;

namespace WebAPI.Models
{
    public class SimpleCompany
    {
        public string LotNumber { get; set; }
        public string CompanyId { get; set; }
        public string CompanyName { get; set; }
        public string Address { get; set; }
        public string AddressLine { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string ZipCode { get; set; }
        public string Phone { get; set; }
        public string Contact { get; set; }
        public string EmailAddress { get; set; }
        public DateTime StartDate { get; set; }
        public string DeliveryType { get; set; }
        public string Active { get; set; }
    }
}