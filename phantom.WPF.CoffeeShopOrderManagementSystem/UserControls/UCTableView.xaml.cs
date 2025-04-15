using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Configuration;
using System.Windows.Controls;
using phantom.CoffeeShopOrderManagementSystem.DataEntities;
using phantom.Core.Restful;

namespace phantom.WPF.CoffeeShopOrderManagementSystem.UserControls
{
    /// <summary>
    /// Interaction logic for UCTableView.xaml
    /// </summary>
    public partial class UCTableView : UserControl
    {
        public UCTableViewModel CurrentDataContext { get; set; } = new UCTableViewModel();

        public UCTableView()
        {
            InitializeComponent();
            this.DataContext = CurrentDataContext;
        }
    }

    public class UCTableViewModel : UCModelBase
    {
        private ObservableCollection<ShopTable> tables = new ObservableCollection<ShopTable>();

        public ObservableCollection<ShopTable> Tables
        {
            get => tables; set
            {
                tables = value;
                OnPropertyChanged(nameof(Tables));
            }
        }

        public UCTableViewModel()
        {
        }

        public async Task Initialize()
        {
#if DEBUG
            Thread.Sleep(1000); // Simulate a delay for debugging purposes
#endif
            var tables = await Globals.RestfulHelper.GetAysnc<IEnumerable<ShopTable>>("tables/load");
            Tables = new ObservableCollection<ShopTable>(tables!);
        }
    }
    public class UCModelBase : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler? PropertyChanged;
        internal void OnPropertyChanged(string propertyName)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}
