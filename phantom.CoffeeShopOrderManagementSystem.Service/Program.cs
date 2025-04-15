using System.Text.Json;
using phantom.CoffeeShopOrderManagementSystem.DataEntities;
using phantom.CoffeeShopOrderManagementSystem.Service;
using phantom.CoffeeShopOrderManagementSystem.Service.Controllers;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddSignalR();

var app = builder.Build();

app.MapControllers();
app.MapHub<OrderHub>("/orderhub");

Globals.OrderFilePath = $@"Db\{DateTime.Now.ToString("yyMMdd")}.Order.json";
if (Directory.Exists($@"Db") == false) Directory.CreateDirectory($@"Db");
if (File.Exists(Globals.OrderFilePath))
{
    using (var fileStream = new FileStream(Globals.OrderFilePath, FileMode.Open, FileAccess.Read))
    using (var streamReader = new StreamReader(fileStream))
    {
        var streamContent = streamReader.ReadToEnd();
        TablesController.Orders = JsonSerializer.Deserialize<List<Order>>(streamContent)!;
        if (TablesController.Orders?.Any(x => x.Status != OrderStatus.Done) == true)
        {
            var tableIds = TablesController.Orders.Where(x => x.Status != OrderStatus.Done).GroupBy(x => new { x.TableId, x.SessionId })
                .Select(x => new { x.Key.TableId, x.Key.SessionId });
            foreach (var id in tableIds)
            {
                var table = TablesController.ShopTables!.FirstOrDefault(x => x.Id == id.TableId)!;
                table.SessionId = id.SessionId;
                table.Status = ShopTableStatus.Occupied;
            }
        }
        streamReader.Close();
        streamReader.Dispose();
        fileStream.Close();
        fileStream.Dispose();
    }
}

app.Run();