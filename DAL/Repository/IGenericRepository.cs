using System.Collections.Generic;

namespace DAL.Repository
{
    public interface IGenericRepository<T> where T : class
    {
        IEnumerable<T> All(string procedure, Dictionary<string, object> propParameters);
        T FindById(string procedure, Dictionary<string, object> propParameters);
        bool Add(T entity);
        // void Delete(T entity);
        void Update(T entity);
        T FindById(int Id); 
    }
};