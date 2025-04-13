namespace phantom.CoffeeShopOrderManagementSystem.DataEntities
{
    public enum ShopTableStatus
    {
        Available,
        Reserved,
        Occupied,
        Orderning,
    }
    public class ShopTable
    {
        public short Id { get; set; } = 0;
        public string? Name { get; set; }
        public ShopTableStatus Status { get; set; } = ShopTableStatus.Available;
        public short Order { get; set; } = 0;
        public string? SessionId;
    }
}
