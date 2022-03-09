using System.Collections.Generic;

namespace DAL.Repository
{
    public interface IGenericRepository<T> where T : class
    {
        IEnumerable<T> All(string procedure, Dictionary<string, object> propParameters);
        T FindById(string procedure, Dictionary<string, object> propParameters);
        int Add(T entity, string schema = "dbo");
        void Delete(T entity, string schema = "dbo");
        bool Update(T entity, string schema = "dbo");
        T FindById(int Id, string procedure, bool useAWConnection = false); 
    }

    public interface IGenericObjectRepository<T> where T : class
    {
        bool AddObject(T entity, string procedure, string schema = "dbo");
    }
}