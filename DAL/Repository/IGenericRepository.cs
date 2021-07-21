using System.Collections.Generic;

namespace DAL.Repository
{
    public interface IGenericRepository<T> where T : class
    {
        IEnumerable<T> All(string id);
        T FindById(string procedure, Dictionary<string, object> propParameters);
        // void Add(T entity);
        // void Delete(T entity);
        // void Update(T entity);
        // T FindById(int Id); 
    }
}