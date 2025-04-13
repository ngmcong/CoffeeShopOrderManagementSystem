using System.Collections.ObjectModel;
using System.Configuration;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using phantom.CoffeeShopOrderManagementSystem.DataEntities;
using phantom.Core.Restful;

namespace phantom.WPF.CoffeeShopOrderManagementSystem.UserControls
{
    /// <summary>
    /// Interaction logic for UCOrderView.xaml
    /// </summary>
    public partial class UCOrderView : UserControl
    {
        public UCOrderViewModel CurrentDataContext { get; set; } = new UCOrderViewModel();
        public UCOrderView()
        {
            InitializeComponent();
            this.DataContext = CurrentDataContext;
        }
    }

    public class UCOrderViewModel : UCModelBase
    {
        public OrderPrepareButtonClickCommand OnOrderPrepareButtonClickCommand { get; }
        private ObservableCollection<Order> _orders = new ObservableCollection<Order>();
        public ObservableCollection<Order> Orders
        {
            get => _orders; set
            {
                _orders = value;
                OnPropertyChanged(nameof(Orders));
            }
        }
        private IEnumerable<ShopTable>? _tables;

        public UCOrderViewModel()
        {
            OnOrderPrepareButtonClickCommand = new OrderPrepareButtonClickCommand(this);
        }

        public void Initialize()
        {
#if DEBUG
            Thread.Sleep(1000); // Simulate a delay for debugging purposes
#endif
            var orders = Globals.RestfulHelper.GetAysnc<IEnumerable<Order>>("tables/loadOrders")?.ToList() ?? new List<Order>();
            _tables = _tables ?? Globals.RestfulHelper.GetAysnc<IEnumerable<ShopTable>>("tables/load");
            (from o in orders
             join t in _tables! on o.TableId equals t.Id
             select new { o, t }).ToList().ForEach(x => x.o.TableName = x.t.Name);
            Orders = new ObservableCollection<Order>(orders);
        }

        public void OnOrderClicked(Order order)
        {
        }
    }

    // Your custom ICommand implementation
    public class OrderPrepareButtonClickCommand : ICommand
    {
        private readonly UCOrderViewModel _viewModel;

        public OrderPrepareButtonClickCommand(UCOrderViewModel viewModel)
        {
            _viewModel = viewModel;
        }

        public event EventHandler? CanExecuteChanged
        {
            add { CommandManager.RequerySuggested += value; }
            remove { CommandManager.RequerySuggested -= value; }
        }

        public bool CanExecute(object? parameter)
        {
            // Add your logic to determine if the command can execute
            return true; // For simplicity, always allow execution in this example
        }

        public void Execute(object? parameter)
        {
            if (parameter is Order selectedItem)
            {
                _viewModel.OnOrderClicked(selectedItem);
            }
        }
    }
}