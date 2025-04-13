using System.Windows.Controls;
using phantom.CoffeeShopOrderManagementSystem.DataEntities;

namespace phantom.WPF.CoffeeShopOrderManagementSystem.UserControls
{
    /// <summary>
    /// Interaction logic for UCProgressOrder.xaml
    /// </summary>
    public partial class UCProgressOrder : UserControl
    {
        public UCProgressOrderModel CurrentDataContext { get; set; } = new UCProgressOrderModel();
        public UCProgressOrder(Order order)
        {
            InitializeComponent();
            this.DataContext = CurrentDataContext;
            this.CurrentDataContext.Order = order;
        }
    }

    public class UCProgressOrderModel : UCModelBase
    {
        private Order? _order;
        public Order? Order
        {
            get => _order; set
            {
                _order = value;
                OnPropertyChanged(nameof(Order));
            }
        }
    }
}
