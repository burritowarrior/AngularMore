using System.ComponentModel.DataAnnotations;

namespace Models
{
    public class City
    {
        [Key]
	    public int CityId { get; set; }
        public string Name { get; set; }
        public string State { get; set; }
        public string Population { get; set; }
    }
}