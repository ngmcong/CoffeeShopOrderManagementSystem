namespace phantom.CoffeeShopOrderManagementSystem.DataEntities
{
    public class Payment
    {
        public int Id { get; set; } = 0;
        public short TableId { get; set; } = 0;
        public string? SessionId;
        public decimal Amount { get; set; }
    }
}
