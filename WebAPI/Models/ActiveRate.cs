namespace WebAPI.Models
{
    public class ActiveRate
    {
        public string Description { get; set; }
        public decimal Amount { get; set; }
        public decimal Tax { get; set; }

        public decimal Rate => Amount + Tax;
    }
}