using System.Collections.Generic;
using WebAPI.Models;

namespace WebAPI.Interfaces
{
    public interface IStateRepository
    {
        IEnumerable<StatesMeta> GetAll();
        StatesMeta GetStateByAbbreviation(string abbreviation);

        int AddNewState(StatesMeta state);
    }
}