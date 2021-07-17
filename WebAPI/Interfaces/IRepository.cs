using System.Collections.Generic;
using WebAPI.Models;

namespace WebAPI.Interfaces
{
    // https://medium.com/falafel-software/implement-step-by-step-generic-repository-pattern-in-c-3422b6da43fd
    public interface IRepository<T> where T : IEntity
    {
        IEnumerable<T> List { get; }
        void Add(T entity);
        void Delete(T entity);
        void Update(T entity);
        T FindById(int Id);        
    }
}