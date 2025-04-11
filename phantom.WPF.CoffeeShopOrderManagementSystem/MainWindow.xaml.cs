using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Configuration;
using System.Windows;
using phantom.CoffeeShopOrderManagementSystem.DataEntities;
using phantom.Core.Restful;

namespace phantom.WPF.CoffeeShopOrderManagementSystem
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindowModel CurrentDataContext { get; set; } = new MainWindowModel();
        public MainWindow()
        {
            InitializeComponent();
            this.DataContext = CurrentDataContext;
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            CurrentDataContext.Initialize();
        }
    }

    public class MainWindowModel : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler? PropertyChanged;
        private void OnPropertyChanged(string propertyName)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }

        private ObservableCollection<ShopTable> tables = new ObservableCollection<ShopTable>();

        public ObservableCollection<ShopTable> Tables
        {
            get => tables; set
            {
                tables = value;
                OnPropertyChanged(nameof(Tables));
            }
        }

        public MainWindowModel()
        {
        }

        public void Initialize()
        {
            string? coffeeShopAddress = ConfigurationManager.ConnectionStrings["CoffeeShopAddress"]?.ConnectionString;
            if (coffeeShopAddress == null)
            {
                // Handle the null case appropriately, e.g., log an error or throw an exception  
                throw new InvalidOperationException("Connection string 'YourDatabaseName' is not configured.");
            }
            RestfulHelper restfulHelper = new RestfulHelper();
            restfulHelper.BaseUrl = coffeeShopAddress;
            var tables = restfulHelper.GetAysnc<IEnumerable<ShopTable>>("tables/load");
            Tables = new ObservableCollection<ShopTable>(tables!);
        }
    }
}

namespace phantom.WPF.CoffeeShopOrderManagementSystem.DataEntities
{
    public class Table // Changed from internal to public
    {
        public string? Name { get; set; }
    }
}