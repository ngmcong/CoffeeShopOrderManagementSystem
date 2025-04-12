using Microsoft.AspNetCore.Mvc;
using phantom.CoffeeShopOrderManagementSystem.DataEntities;

namespace phantom.CoffeeShopOrderManagementSystem.Service.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class TablesController : ControllerBase
    {
        public static List<ShopTable> _tables = new List<ShopTable>();
        public static Dictionary<short, List<Product>> _products = new Dictionary<short, List<Product>>();

        public async Task<IEnumerable<ShopTable>> Load()
        {
            _tables = new List<ShopTable>();
            for (short i = 1; i <= 10; i++)
            {
                _tables.Add(new ShopTable { Id = Convert.ToInt16(i - 1), Name = $"Table {i}" });
            }
            await Task.CompletedTask;
            return _tables;
        }

        [HttpGet("{tableId}")]
        public async Task<IEnumerable<Product>?> LoadProducts(short tableId)
        {
            await Task.CompletedTask;
            var dict = _products?.FirstOrDefault(x => x.Key == tableId);
            return dict?.Value;
        }

        [HttpPost("{tableId}")]
        public async Task OccupiedAndOrderning([FromBody] IEnumerable<Product> products, short tableId)
        {
            if ((_tables?.Count() > 0) == false) await Load();
            var table = _tables!.FirstOrDefault(t => t.Id == tableId)!;
            table.Status = ShopTableStatus.Orderning;
            table.Order = Convert.ToInt16(_tables!.Max(t => t.Order) + 1);
            _tables!.Where(t => t.Status == ShopTableStatus.Orderning).OrderBy(t => t.Order).Select((t, i) => t.Order = Convert.ToInt16(i + 1)).ToList();
            if (_products.ContainsKey(tableId) != true) _products.Add(tableId, new List<Product>());
            _products[tableId] = (from p in products
                                  join op in _products[tableId] on p.Id equals op.Id into lop
                                  from op in lop.DefaultIfEmpty()
                                  select new Product
                                  {
                                      Id = p.Id,
                                      Qty = p.Qty,
                                      OccupiedQty = op?.OccupiedQty ?? 0,
                                      ImageUrl = p.ImageUrl,
                                      Name = p.Name,
                                  }).ToList();
            await Task.CompletedTask;
        }
    }
}