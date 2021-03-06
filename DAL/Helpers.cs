using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;

namespace DAL
{
    public static class Helpers
    {
        public static string GenerateInsertStatement<T>(this T item, string schema = "dbo")
        {
            var props = item.GetType().GetProperties();
            var colNames = props.Select(s => s.Name).ToArray();

            
            var sb = new StringBuilder();
            foreach (var prop in props)
            {
                var attributeValue = (KeyAttribute[])prop.GetCustomAttributes(typeof(KeyAttribute), false);
                var opResults = attributeValue.Length > 0;
                if (opResults) {
                    colNames = colNames.Where(s => s != prop.Name).ToArray();
                } else {
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
            }
            
            var fieldClause = string.Join(", ", colNames); 
            var chars = new char[] { ',', ' ' };
            var sql = $"INSERT INTO {schema}.{item.GetType().Name} ({fieldClause}) VALUES ({sb.ToString().Trim(chars)})";
            
            return sql;
        }

        public static string GenerateUpdateStatement<T>(this T item, string schema = "dbo")
        {
            var props = item.GetType().GetProperties();
            var colNames = props.Select(s => s.Name).ToArray();
            var statements = new List<string>();

            var initialSql = $"UPDATE {schema}.{item.GetType().Name} SET ";
            
            foreach (var val in props)
            {
                var attributeValue = (KeyAttribute[])val.GetCustomAttributes(typeof(KeyAttribute), false);
                var results = attributeValue.Length > 0 
                    ? ResolveType(val.Name, val.PropertyType.ToString(), val.GetValue(item, null), true)
                    : ResolveType(val.Name, val.PropertyType.ToString(), val.GetValue(item, null));
                statements.Add(results);
            }

            var whatever = statements.Where(s => !s.StartsWith("WHERE")).Select(t => $"{t}, ").ToArray();
            var kookoo = string.Join(' ', whatever).Trim(new [] { ' ', ',' });
            var whereClause = statements.FirstOrDefault(s => s.StartsWith("WHERE"));

            return $"{initialSql} {kookoo} {whereClause}";
        }

        public static string GenerateDeleteStatement<T>(this T item, string schema = "dbo")
        {
            var props = item.GetType().GetProperties();
            var colNames = props.Select(s => s.Name).ToArray();
            var statements = new List<string>();

            var initialSql = $"DELETE FROM {schema}.{item.GetType().Name} ";
            statements.Add(initialSql);

            foreach (var val in props)
            {
                var attributeValue = (KeyAttribute[])val.GetCustomAttributes(typeof(KeyAttribute), false);
                if (attributeValue.Length > 0) {
                    var results = ResolveType(val.Name, val.PropertyType.ToString(), val.GetValue(item, null), true);
                    statements.Add(results);
                }
            }

            var sb = new StringBuilder();

            // C# Extension Method: StringBuilder - AppendJoin
            var query = sb.AppendJoin(" ", statements.ToArray()).ToString();            

            return query;
        }

        private static string ResolveType(string propertyName, string propertyType, object value, bool isKeyValue = false)
        {
            if (propertyType == "System.Int32" || propertyType == "System.Int64" || propertyType == "System.Decimal")
            {
                return isKeyValue ? $"WHERE {propertyName} = {value}" : $"{propertyName} = {value}";
            }
            
            if (propertyType == "System.Boolean")
            {
                var oneOrZero = value.ToString() == "True" ? 1 : 0;
                return isKeyValue ? $"WHERE {propertyName} = {oneOrZero}" : $"{propertyName} = {oneOrZero}";
            }			

            return isKeyValue ? $"WHERE {propertyName} = '{value}'" : $"{propertyName} = '{value}'";
        }   
    }
}