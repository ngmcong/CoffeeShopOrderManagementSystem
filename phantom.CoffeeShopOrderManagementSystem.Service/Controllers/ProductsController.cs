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
            products.AddRange(new List<Product> {
                new Product {
                    Id = 0,
                    Name = "Phin sữa",
                    ImageUrl = "https://lh5.googleusercontent.com/proxy/mKkslN1cub9LuNidq3LlU-R51N0FBkuT_dlIiCRZZjufA6zBA4U_1mvG1hUbW5XHYDbzK6TRbY0zcN5Da-cuklAGGfYlRrolBwk9ntNlxWI2DE12PRTE9xiROiH-UKoCwXpqxOUAWqf2v6EFDtu7Pw",
                    Option1 = new List<string> { "Đá", "Nóng" },
                    Prices = new List<ProductPrice> {
                        new ProductPrice { Id = 0, Name = "Nhỏ", Price = 29000 },
                        new ProductPrice { Id = 1, Name = "Vừa", Price = 35000 },
                        new ProductPrice { Id = 2, Name = "Lớn", Price = 39000 },
                    },
                },
                new Product {
                    Id = 1,
                    Name = "Phin đen",
                    ImageUrl = "https://lh3.googleusercontent.com/proxy/DQFjDcLwm2ItQIadZBnwl3f97nFWKVXoYiMYJmz_CZAu6eJe1P2DCvY8SeLZN4vN1WHKM5kopO3V0dikyVrjI8yyvsj8c4m_6AhzFLn0GNduMEuEVn6aIckjQN08JkQ1LuEPmhYDqRmASILu3FIhqNzLnRsYdO0zIw",
                    Option1 = new List<string> { "Đá", "Nóng" },
                    Prices = new List<ProductPrice> {
                        new ProductPrice { Id = 0, Name = "Nhỏ", Price = 29000 },
                        new ProductPrice { Id = 1, Name = "Vừa", Price = 35000 },
                        new ProductPrice { Id = 2, Name = "Lớn", Price = 39000 },
                    },
                },
                new Product {
                    Id = 2,
                    Name = "Bạc xỉu",
                    ImageUrl = "https://product.hstatic.net/200000825425/product/bac_xiu_05fe000a791b476eaf54760ce04b9709_master.png",
                    Option1 = new List<string> { "Đá", "Nóng" },
                    Prices = new List<ProductPrice> {
                        new ProductPrice { Id = 0, Name = "Nhỏ", Price = 29000 },
                        new ProductPrice { Id = 1, Name = "Vừa", Price = 35000 },
                        new ProductPrice { Id = 2, Name = "Lớn", Price = 39000 },
                    },
                },
                new Product {
                    Id = 3,
                    Name = "Trà sen vàng",
                    ImageUrl = "https://product.hstatic.net/200000825425/product/tra_sen_vang_87af75e559f24fd182849d49c0619db5.png",
                    Option1 = new List<string> { "Đá", "Nóng" },
                    Prices = new List<ProductPrice> {
                        new ProductPrice { Id = 0, Name = "Nhỏ", Price = 29000 },
                        new ProductPrice { Id = 1, Name = "Vừa", Price = 35000 },
                        new ProductPrice { Id = 2, Name = "Lớn", Price = 39000 },
                    },
                },
                new Product {
                    Id = 4,
                    Name = "Trà đào",
                    ImageUrl = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTuXCEyLs4SHE9Q5d30gEzJ0__h2g7XTUhAiA&s",
                    Option1 = new List<string> { "Đá", "Nóng" },
                    Prices = new List<ProductPrice> {
                        new ProductPrice { Id = 0, Name = "Nhỏ", Price = 29000 },
                        new ProductPrice { Id = 1, Name = "Vừa", Price = 35000 },
                        new ProductPrice { Id = 2, Name = "Lớn", Price = 39000 },
                    },
                },
                new Product {
                    Id = 5,
                    Name = "Trà vải",
                    ImageUrl = "https://www.pullscoffee.com/wp-content/uploads/2024/08/ly-1.png",
                    Option1 = new List<string> { "Đá", "Nóng" },
                    Prices = new List<ProductPrice> {
                        new ProductPrice { Id = 0, Name = "Nhỏ", Price = 29000 },
                        new ProductPrice { Id = 1, Name = "Vừa", Price = 35000 },
                        new ProductPrice { Id = 2, Name = "Lớn", Price = 39000 },
                    },
                },
                new Product {
                    Id = 6,
                    Name = "Trà đậu đỏ",
                    ImageUrl = "https://cdn.tgdd.vn/Files/2021/08/13/1374929/tu-lam-tra-sua-dau-do-don-gian-tai-nha-ngon-hon-ngoai-quan-202108131135137369.jpg",
                    Option1 = new List<string> { "Đá", "Nóng" },
                    Prices = new List<ProductPrice> {
                        new ProductPrice { Id = 0, Name = "Nhỏ", Price = 29000 },
                        new ProductPrice { Id = 1, Name = "Vừa", Price = 35000 },
                        new ProductPrice { Id = 2, Name = "Lớn", Price = 39000 },
                    },
                },
                new Product {
                    Id = 7,
                    Name = "Cookies & Cream",
                    ImageUrl = "https://www.highlandscoffee.com.vn/vnt_upload/product/06_2023/HLC_New_logo_5.1_Products__COOKIES_FREEZE.jpg",
                    Prices = new List<ProductPrice> {
                        new ProductPrice { Id = 0, Name = "Nhỏ", Price = 29000 },
                        new ProductPrice { Id = 1, Name = "Vừa", Price = 35000 },
                        new ProductPrice { Id = 2, Name = "Lớn", Price = 39000 },
                    },
                },
                new Product {
                    Id = 8,
                    Name = "Nước tắc",
                    ImageUrl = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTflLCb0KJQt2y7PtA7yU_ZTUfcVRxHv_huow&s",
                    Option1 = new List<string> { "Đá", "Nóng" },
                    Prices = new List<ProductPrice> {
                        new ProductPrice { Id = 0, Name = "Nhỏ", Price = 29000 },
                        new ProductPrice { Id = 1, Name = "Vừa", Price = 35000 },
                        new ProductPrice { Id = 2, Name = "Lớn", Price = 39000 },
                    },
                },
                new Product {
                    Id = 9,
                    Name = "Sô cô la đá xay",
                    ImageUrl = "https://mcdonalds.vn/uploads/2018/mccafe/icedchoco.png",
                    Prices = new List<ProductPrice> {
                        new ProductPrice { Id = 0, Name = "Nhỏ", Price = 29000 },
                        new ProductPrice { Id = 1, Name = "Vừa", Price = 35000 },
                        new ProductPrice { Id = 2, Name = "Lớn", Price = 39000 },
                    },
                },
                new Product {
                    Id = 10,
                    Name = "Chanh đá",
                    ImageUrl = "https://file.hstatic.net/200000260805/article/da_chanh_mat_ong_dac_san_viet_6042cdd8b4484958a78ca66ed0e23507.jpg",
                    Prices = new List<ProductPrice> {
                        new ProductPrice { Id = 0, Name = "Nhỏ", Price = 29000 },
                        new ProductPrice { Id = 1, Name = "Vừa", Price = 35000 },
                        new ProductPrice { Id = 2, Name = "Lớn", Price = 39000 },
                    },
                },
                new Product {
                    Id = 11,
                    Name = "Chanh dây đá viên",
                    ImageUrl = "https://www.highlandscoffee.com.vn/vnt_upload/product/HLCPOSTOFFICE_DRAFT/PNG_FINAL/3_MENU_NGUYEN_BAN/Chanh_Da_Vien.jpg",
                    Prices = new List<ProductPrice> {
                        new ProductPrice { Id = 0, Name = "Nhỏ", Price = 29000 },
                        new ProductPrice { Id = 1, Name = "Vừa", Price = 35000 },
                        new ProductPrice { Id = 2, Name = "Lớn", Price = 39000 },
                    },
                },
            });
            await Task.CompletedTask;
            return products;
        }
    }
}
