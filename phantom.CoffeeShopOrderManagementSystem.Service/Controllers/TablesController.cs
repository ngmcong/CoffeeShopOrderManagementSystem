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

        private static List<ShopTable>? _shopTables;
        public static List<ShopTable> ShopTables
        {
            get
            {
                if (_shopTables == null)
                {
                    _shopTables = new List<ShopTable>();
                    for (short i = 1; i <= 10; i++)
                    {
                        _shopTables.Add(new ShopTable { Id = Convert.ToInt16(i - 1), Name = $"Bàn {i}" });
                    }
                }
                return _shopTables!;
            }
        }
        public static List<Order> Orders = new List<Order>();
        private static List<Payment> _payment = new List<Payment>();

        public async Task<IEnumerable<ShopTable>> Load()
        {
            await Task.CompletedTask;
            return ShopTables;
        }

        [HttpGet("{tableId}")]
        public async Task<IEnumerable<Product>?> LoadProducts(short tableId)
        {
            if ((ShopTables?.Count() > 0) == false) await Load();
            var table = ShopTables!.FirstOrDefault(x => x.Id == tableId);
            var nowDate = DateTime.Now.Date;
            var products = Orders.Where(x => x.TableId == tableId && x.SessionId == table!.SessionId).SelectMany(x => x.Products!);
            var outModels = (from p in products
                             join dp in ProductsController.Products on p.Id equals dp.Id
                             where p.Qty > 0
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

        [HttpGet]
        public async Task<IEnumerable<Order>> LoadOrders()
        {
            await Task.CompletedTask;
            return Orders.Where(x => x.Status == OrderStatus.New);
        }

        [HttpGet("{tableId}")]
        public async Task<IEnumerable<Product>?> LoadOrderProducts(short tableId)
        {
            await Task.CompletedTask;
            return Orders.Where(x => x.Status == OrderStatus.New && x.TableId == tableId)?.SelectMany(x => x.Products!);
        }

        private bool IsEqualOrderProduct(Product p1, Product p2)
        {
            return p1.Id == p2.Id && p1.Option1Value == p2.Option1Value && p1.SelectedPrice?.Price == p2.SelectedPrice?.Price;
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
            if ((ShopTables?.Count() > 0) == false) await Load();
            var table = ShopTables!.FirstOrDefault(t => t.Id == tableId)!;
            if (table.Status == ShopTableStatus.Available || table.Status == ShopTableStatus.Reserved)
            {
                var guid = Guid.NewGuid().ToString().Replace("-", "");
                table.SessionId = guid;
            }
            table.Status = ShopTableStatus.Orderning;
            table.Order = Convert.ToInt16(ShopTables!.Max(t => t.Order) + 1);
            ShopTables!.Where(t => t.Status == ShopTableStatus.Orderning).OrderBy(t => t.Order).Select((t, i) => t.Order = Convert.ToInt16(i + 1)).ToList();


            // Edit order items
            if (products.Any(x => x.Qty < 0))
            {
                lock (Orders)
                {
                    var currentOrders = Orders.Where(x => x.Status == OrderStatus.New
                        && x.SessionId == table.SessionId).ToList();
                    var editProducts = products.Where(x => x.Qty < 0).ToList();
                    while (editProducts!.Count() > 0)
                    {
                        var item = editProducts.FirstOrDefault()!;
                        var order = currentOrders.FirstOrDefault(x => x.Products!.Any(p => p.Qty > 0 && IsEqualOrderProduct(p, item)));
                        if (order == null)
                        {
                            throw new Exception("Không tìm thấy dữ liệu thực hiện.");
                        }
                        var product = order.Products!.FirstOrDefault(x => x.Qty > 0 && IsEqualOrderProduct(x, item));
                        if (product == null)
                        {
                            throw new Exception("Không tìm thấy dữ liệu thực hiện.");
                        }
                        var minQty = Convert.ToInt16(Math.Min(product.Qty, -1 * item.Qty));
                        product.Qty -= minQty;
                        item.Qty += minQty;
                        if (item.Qty == 0)
                        {
                            editProducts.Remove(item);
                        }
                    }
                    var emptyOrders = currentOrders.Where(x => x.Products!.All(p => p.Qty == 0)).ToList();
                    foreach (var order in emptyOrders)
                    {
                        order.Status = OrderStatus.Done;
                    }
                }
            }
            // Add new order
            if (products.Any(x => x.Qty > 0))
            {
                var order = Orders.FirstOrDefault(x => x.TableId == tableId && x.Employee == employee && x.Status == OrderStatus.New
                    && x.SessionId == table.SessionId);
                if (order == null)
                {
                    lock (Orders)
                    {
                        var nowDate = DateTime.Now.Date;
                        var oId = Orders?.Count() == 0 ? 0 : Orders!.Max(x => x.Id);
                        order = new Order
                        {
                            Id = oId + 1,
                            Code = $"{nowDate.ToString("dd")}{(Orders!.Count(x => x.Date == nowDate) + 1).ToString("000")}",
                            Date = nowDate,
                            Employee = employee,
                            Status = OrderStatus.New,
                            TableId = tableId,
                            SessionId = table.SessionId,
                        };
                        Orders!.Add(order);
                    }
                }
                if (order!.Products == null) order!.Products = new List<Product>();
                order!.Products!.AddRange(products.Where(x => x.Qty > 0));
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
            }

            Globals.SaveOrdersToFile();

            await _hubContext.Clients.All.SendAsync("ReceiveMessage", "User", "Đã có cập nhật đặt món");

            await Task.CompletedTask;
            return new APIRetVal();
        }

        [HttpPost("{tableId}")]
        public async Task<APIRetVal> Payment(short tableId, [FromBody] string employee)
        {
            var table = ShopTables.FirstOrDefault(x => x.Id == tableId && x.Status != ShopTableStatus.Available);
            if (table == null) return new APIRetVal { Code = 1, Message = "Không tìm thấy dữ liệu thanh toán." };
            var orders = Orders.Where(x => x.SessionId == table.SessionId);
            if ((orders?.Count() > 0) == false || orders.Any(x => x.Status != OrderStatus.Done)) return new APIRetVal { Code = 1, Message = "Tồn tại món chưa được giao." };

            lock (orders)
                lock (_payment)
                {
                    _payment.Add(new DataEntities.Payment
                    {
                        Id = _payment?.Count > 0 ? _payment.Max(x => x.Id) + 1 : 1,
                        SessionId = table.SessionId,
                        TableId = table.Id,
                        Amount = orders.Where(x => x.SessionId == table.SessionId).SelectMany(x => x.Products!).Sum(x => x.Qty * x.SelectedPrice!.Price),
                    });
                }
            table.SessionId = null;
            table.Status = ShopTableStatus.Available;

            Globals.SaveOrdersToFile();

            await Task.CompletedTask;
            return new APIRetVal();
        }

        [HttpPost]
        public async Task CompleteOrder([FromBody] int orderId)
        {
            lock (Orders)
            {
                var order = Orders.FirstOrDefault(x => x.Id == orderId && x.Status != OrderStatus.Done);
                if (order == null) throw new Exception("Không tìm thấy dữ liệu thực hiện.");
                order.Status = OrderStatus.Done;
            }
            await Task.CompletedTask;
            await _hubContext.Clients.All.SendAsync("ReceiveMessage", "User", "Đã hoàn tất phiếu gói món");
            Globals.SaveOrdersToFile();
        }

        [HttpPost]
        public async Task InProgressOrder([FromBody] int orderId)
        {
            lock (Orders)
            {
                var order = Orders.FirstOrDefault(x => x.Id == orderId && x.Status != OrderStatus.Done);
                if (order == null) throw new Exception("Không tìm thấy dữ liệu thực hiện.");
                order.Status = OrderStatus.Progress;
            }
            await Task.CompletedTask;
            await _hubContext.Clients.All.SendAsync("ReceiveMessage", "User", "Đã hoàn tất phiếu gói món");
            Globals.SaveOrdersToFile();
        }
    }
    public class APIRetVal
    {
        public short Code { get; set; }
        public string Message { get; set; } = "Thành công";
        public object? Data { get; set; }
    }
}