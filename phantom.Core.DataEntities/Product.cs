﻿namespace phantom.CoffeeShopOrderManagementSystem.DataEntities
{
    public class Product
    {
        public short Id { get; set; } = 0;
        public string? Name { get; set; }
        public decimal Price { get; set; } = 0;
        public string? ImageUrl { get; set; }
        public short Qty { get; set; } = 0;
        public short OccupiedQty { get; set; } = 0;
    }
}