namespace phantom.CoffeeShopOrderManagementSystem.DataEntities
{
    public enum OrderStatus
    {
        New,
        Progress,
        Done
    }
    public class Order
    {
        public int Id { get; set; } = 0;
        public string? Name { get; set; }
        public string? Code { get; set; }
        public string? Employee { get; set; }
        public OrderStatus Status { get; set; } = OrderStatus.New;
        public short TableId { get; set; } = 0;
        public DateTime? Date;
        public List<Product>? Products { get; set; }
        public string? SessionId;
        public string? TableName { get; set; }
    }
}
