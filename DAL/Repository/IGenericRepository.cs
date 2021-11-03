using System.Collections.Generic;

namespace DAL.Repository
{
    public interface IGenericRepository<T> where T : class
    {
        IEnumerable<T> All(string procedure, Dictionary<string, object> propParameters);
        T FindById(string procedure, Dictionary<string, object> propParameters);
        bool Add(T entity, string schema = "dbo");
        void Delete(T entity, string schema = "dbo");
        bool Update(T entity, string schema = "dbo");
        T FindById(int Id); 
    }
};