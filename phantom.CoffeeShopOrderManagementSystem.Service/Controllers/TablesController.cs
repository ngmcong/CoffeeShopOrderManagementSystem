using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using phantom.CoffeeShopOrderManagementSystem.DataEntities;

namespace phantom.CoffeeShopOrderManagementSystem.Service.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class TablesController : ControllerBase
    {
        private readonly IHubContext<OrderHub> _hubContext; // Replace ChatHub with your Hub class
        public TablesController(IHubContext<OrderHub> hubContext)
        {
            _hubContext = hubContext;
        }

        private static List<ShopTable> _tables = new List<ShopTable>();
        private static List<Order> _orders = new List<Order>();

        public async Task<IEnumerable<ShopTable>> Load()
        {
            if (_tables == null || _tables.Count == 0)
            {
                _tables = new List<ShopTable>();
                for (short i = 1; i <= 10; i++)
                {
                    _tables.Add(new ShopTable { Id = Convert.ToInt16(i - 1), Name = $"Bàn {i}" });
                }
            }
            await Task.CompletedTask;
            return _tables;
        }

        [HttpGet("{tableId}")]
        public async Task<IEnumerable<Product>?> LoadProducts(short tableId)
        {
            if ((_tables?.Count() > 0) == false) await Load();
            var table = _tables!.FirstOrDefault(x => x.Id == tableId);
            var nowDate = DateTime.Now.Date;
            var products = _orders.Where(x => x.TableId == tableId && x.SessionId == table!.SessionId).SelectMany(x => x.Products!);
            var outModels = (from p in products
                             join dp in ProductsController.Products on p.Id equals dp.Id
                             select new { p, dp }).Select(x =>
                             {
                                 var model = x.dp;
                                 model.Qty = x.p.Qty;
                                 model.SelectedPrice = x.p.SelectedPrice;
                                 model.Option1Value = x.p.Option1Value;
                                 return model;
                             });
            await Task.CompletedTask;
            return outModels;
        }

        public async Task<IEnumerable<Order>> LoadOrders()
        {
            await Task.CompletedTask;
            return _orders;
        }

        private string Base64Decode(string base64EncodedData)
        {
            var base64EncodedBytes = System.Convert.FromBase64String(base64EncodedData);
            return System.Text.Encoding.UTF8.GetString(base64EncodedBytes);
        }
        [HttpPost("{tableId}")]
        public async Task<APIRetVal> OccupiedAndOrderning(short tableId, [FromBody] IEnumerable<Product> products
            , [FromQuery] string employee)
        {
            employee = Base64Decode(employee);
            if (products.Any(x => string.IsNullOrEmpty(x.Option1Value) || (x.SelectedPrice?.Price > 0) == false))
            {
                return new APIRetVal { Code = 1, Message = "Không đủ thông tin cần thiết" };
            }
            if ((_tables?.Count() > 0) == false) await Load();
            var table = _tables!.FirstOrDefault(t => t.Id == tableId)!;
            if (table.Status == ShopTableStatus.Available || table.Status == ShopTableStatus.Reserved)
            {
                var guid = Guid.NewGuid().ToString().Replace("-", "");
                table.SessionId = guid;
            }
            table.Status = ShopTableStatus.Orderning;
            table.Order = Convert.ToInt16(_tables!.Max(t => t.Order) + 1);
            _tables!.Where(t => t.Status == ShopTableStatus.Orderning).OrderBy(t => t.Order).Select((t, i) => t.Order = Convert.ToInt16(i + 1)).ToList();

            var order = _orders.FirstOrDefault(x => x.TableId == tableId && x.Employee == employee && x.Status == OrderStatus.New
                && x.SessionId == table.SessionId);
            if (order == null)
            {
                lock (_orders)
                {
                    var nowDate = DateTime.Now.Date;
                    var oId = _orders?.Count() == 0 ? 0 : _orders!.Max(x => x.Id);
                    order = new Order
                    {
                        Id = oId + 1,
                        Code = $"{nowDate.ToString("dd")}{(_orders!.Count(x => x.Date == nowDate) + 1).ToString("000")}",
                        Date = nowDate,
                        Employee = employee,
                        Status = OrderStatus.New,
                        TableId = tableId,
                        SessionId = table.SessionId,
                    };
                    _orders!.Add(order);
                }
            }
            if (order!.Products == null) order!.Products = new List<Product>();
            order!.Products!.AddRange(products);
            var grp = from p in order!.Products
                      group p by new { p.Id, p.Option1Value, p.SelectedPrice?.Price } into gp
                      select new { gp.Key.Id, gp.Key.Option1Value, gp.Key.Price, Qty = gp.Sum(x => x.Qty) };
            order!.Products = (from gp in grp
                               join p in ProductsController.Products on gp.Id equals p.Id
                               select new { p, gp }).Select(x =>
                               {
                                   var model = x.p;
                                   model.Qty = Convert.ToInt16(x.gp.Qty);
                                   model.Option1Value = x.gp.Option1Value;
                                   model.SelectedPrice = x.p.Prices!.FirstOrDefault(c => c.Price == x.gp.Price);
                                   return model;
                               }).ToList();

            await Task.CompletedTask;

            await _hubContext.Clients.All.SendAsync("ReceiveMessage", "User", "Đã có cập nhật đặt món");

            return new APIRetVal();
        }
    }
    public class APIRetVal
    {
        public short Code { get; set; }
        public string Message { get; set; } = "Thành công";
        public object? Data { get; set; }
    }
}