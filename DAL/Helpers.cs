using System;
using System.Linq;
using System.Text;

namespace DAL
{
    public static class Helpers
    {
        public static string GenerateSqlStatement<T>(this T item)
        {
            var props = item.GetType().GetProperties();
            var colNames = props.Select(s => s.Name).ToArray();
            var fieldClause = string.Join(", ", colNames); 
            
            var sb = new StringBuilder();
            foreach (var prop in props)
            {
                Console.WriteLine(prop.PropertyType.Name);
                var currentPropertyType = prop.PropertyType.Name;
                if (currentPropertyType == "Int32")
                {
                    sb.Append($"{prop.GetValue(item)}, ");
                }

                if (currentPropertyType == "Decimal")
                {
                    sb.Append($"{prop.GetValue(item)}, ");
                }

                if (currentPropertyType == "Boolean")
                {
                    var results = false;
                    _ = Boolean.TryParse(prop.GetValue(item).ToString(), out results);
                    var booleanValue = (results) ? 1 : 0;
                    sb.Append($"{booleanValue}, ");
                }

                if (currentPropertyType == "String") {
                    sb.Append($"'{prop.GetValue(item)}', ");
                }
                
                if (currentPropertyType == "DateTime") {
                    var dtValue = Convert.ToDateTime(prop.GetValue(item)).ToString("MM-dd-yyyy HH:mm:ss");
                    sb.Append($"'{dtValue}', ");
                }
            }
            
            var chars = new char[] { ',', ' ' };
            var sql = $"INSERT INTO {item.GetType().Name} ({fieldClause}) VALUES ({sb.ToString().Trim(chars)})";
            
            return sql;
        }        
    }
}