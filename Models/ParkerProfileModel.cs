using System.Collections.Generic;
using Models.Company;
using Models.Parker;

namespace Models
{
    public class ParkerProfileModel
    {
        public IEnumerable<ParkerProfile> ParkerProfiles { get; set; }
        public IEnumerable<CompanyList> CompanyList { get; set; }
    }
}