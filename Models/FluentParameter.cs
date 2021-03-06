using System.Collections.Generic;

namespace Models
{
    public class FluentParameter
    {
        public Dictionary<string, object> KeyData = new Dictionary<string, object>();
        private Parameter parameter = new Parameter();

        public FluentParameter LotNumber(string lotNumber)
        {
            var propertyName = nameof(parameter.LotNumber);
            parameter.LotNumber = lotNumber;
            if (!KeyData.ContainsKey(propertyName)) KeyData[propertyName] = lotNumber;
            return this;
        }

        public FluentParameter ParkerId(string parkerId)
        {
            var propertyName = nameof(parameter.ParkerId);
            if (!KeyData.ContainsKey(propertyName)) KeyData[propertyName] = parkerId;
            parameter.ParkerId = parkerId;
            return this;
        }

        public FluentParameter CompanyId(string companyId)
        {
            var propertyName = nameof(parameter.CompanyId);
            if (!KeyData.ContainsKey(propertyName)) KeyData[propertyName] = companyId;            
            parameter.CompanyId = companyId;
            return this;
        }

        public FluentParameter LoadUsualSuspects(string lotNumber, string companyId)
        {
            var propertyCompanyId = nameof(parameter.CompanyId);
            var propertyLotNumber = nameof(parameter.LotNumber);

            if (!KeyData.ContainsKey(propertyLotNumber)) KeyData[propertyLotNumber] = lotNumber;
            if (!KeyData.ContainsKey(propertyCompanyId)) KeyData[propertyCompanyId] = companyId; 

            parameter.LotNumber = propertyLotNumber;           
            parameter.CompanyId = propertyCompanyId;
            return this;
        }
    }
}