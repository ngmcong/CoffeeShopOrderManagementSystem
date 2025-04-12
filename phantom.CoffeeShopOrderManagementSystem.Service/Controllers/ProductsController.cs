using Microsoft.AspNetCore.Mvc;
using phantom.CoffeeShopOrderManagementSystem.DataEntities;

namespace phantom.CoffeeShopOrderManagementSystem.Service.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class ProductsController : ControllerBase
    {
        public static List<Product> products = new List<Product>();
        public async Task<IEnumerable<Product>> Load()
        {
            products = new List<Product>();
            for (short i = 1; i <= 12; i++)
            {
                products.Add(new Product
                {
                    Id = Convert.ToInt16(i - 1),
                    Name = $"Product {i}",
                    Price = 35000,
                    ImageUrl = "https://static.vecteezy.com/system/resources/thumbnails/041/643/200/small_2x/ai-generated-a-cup-of-coffee-and-a-piece-of-coffee-bean-perfect-for-food-and-beverage-related-designs-or-promoting-cozy-moments-png.png",
                });
            }
            await Task.CompletedTask;
            return products;
        }
    }
}
