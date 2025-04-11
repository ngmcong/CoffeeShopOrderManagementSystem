using Microsoft.AspNetCore.Mvc;
using phantom.CoffeeShopOrderManagementSystem.DataEntities;

namespace phantom.CoffeeShopOrderManagementSystem.Service.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class TablesController : ControllerBase
    {
        public static List<ShopTable> tables = new List<ShopTable>();
        public async Task<IEnumerable<ShopTable>> Load()
        {
            tables = new List<ShopTable>();
            for (short i = 1; i <= 10; i++)
            {
                tables.Add(new ShopTable { Id = Convert.ToInt16(i - 1), Name = $"Table {i}" });
            }
            await Task.CompletedTask;
            return tables;
        }

        public async void OccupiedAndOrderning(short tableId)
        {
            var table = tables!.FirstOrDefault(t => t.Id == tableId)!;
            table.Status = ShopTableStatus.Orderning;
            table.Order = Convert.ToInt16(tables.Max(t => t.Order) + 1);
            tables.Where(t => t.Status == ShopTableStatus.Orderning).OrderBy(t => t.Order).Select((t, i) => t.Order = Convert.ToInt16(i + 1)).ToList();
            await Task.CompletedTask;
        }
    }
}
