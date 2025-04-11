using Microsoft.AspNetCore.Mvc;
using phantom.CoffeeShopOrderManagementSystem.DataEntities;

namespace phantom.CoffeeShopOrderManagementSystem.Service.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class ProductsController : ControllerBase
    {
        public static List<Product> tables = new List<Product>();
        public async Task<IEnumerable<Product>> Load()
        {
            tables = new List<Product>();
            for (short i = 1; i <= 10; i++)
            {
                tables.Add(new Product { Id = Convert.ToInt16(i - 1), Name = $"Product {i}", Price = 35000 });
            }
            await Task.CompletedTask;
            return tables;
        }
    }
}
