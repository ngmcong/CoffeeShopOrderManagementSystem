using System.Collections.ObjectModel;
using System.Windows.Controls;
using phantom.CoffeeShopOrderManagementSystem.DataEntities;

namespace phantom.WPF.CoffeeShopOrderManagementSystem.UserControls
{
    /// <summary>
    /// Interaction logic for UCOrderView.xaml
    /// </summary>
    public partial class UCOrderView : UserControl
    {
        public UCOrderView()
        {
            InitializeComponent();
        }
    }
    public class UCOrderViewModel : UCModelBase
    {
        private ObservableCollection<Order> _orders = new ObservableCollection<Order>();
        public ObservableCollection<Order> Orders
        {
            get => _orders; set
            {
                _orders = value;
                OnPropertyChanged(nameof(Orders));
            }
        }
    }
}