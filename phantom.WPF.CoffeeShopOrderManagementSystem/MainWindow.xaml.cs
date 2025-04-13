using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Configuration;
using System.Windows;
using Microsoft.AspNetCore.SignalR.Client;
using phantom.CoffeeShopOrderManagementSystem.DataEntities;
using phantom.Core.Restful;

namespace phantom.WPF.CoffeeShopOrderManagementSystem
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private HubConnection? _connection;
        public MainWindowModel CurrentDataContext { get; set; } = new MainWindowModel();

        private async Task ConnectAsync()
        {
            try
            {
#if DEBUG
                await Task.Delay(1000); // Simulate a delay for debugging purposes
#endif
                await _connection!.StartAsync();
                //Dispatcher.Invoke(() =>
                //{
                //    connectionStatus.Text = "Connected";
                //    connectButton.IsEnabled = false;
                //    sendButton.IsEnabled = true;
                //});
                //await _connection.InvokeAsync("SendMessage", "abc", "def");
            }
            catch
            {
                throw;
                //Dispatcher.Invoke(() =>
                //{
                //    connectionStatus.Text = $"Error connecting: {ex.Message}";
                //    connectButton.IsEnabled = true;
                //    sendButton.IsEnabled = false;
                //});
                //// Optionally retry connection after a delay
                //await Task.Delay(5000);
                //await ConnectAsync();
            }
        }
        private async void InitializeSignalR()
        {
            string? coffeeShopAddress = ConfigurationManager.ConnectionStrings["CoffeeShopAddress"]?.ConnectionString;
            _connection = new HubConnectionBuilder()
                .WithUrl($"{coffeeShopAddress!.Replace("/api", "")}/orderhub") // Replace with your SignalR server URL
                .Build();

            _connection.On<string, string>("ReceiveMessage", (user, message) =>
            {
                // This method is called by the server
                //Dispatcher.Invoke(() => // Ensure UI updates happen on the UI thread
                //{
                //    messagesList.Items.Add($"{user}: {message}");
                //});
                CurrentDataContext.Initialize();
            });

            _connection.Closed += async (error) =>
            {
                //Dispatcher.Invoke(() =>
                //{
                //    connectionStatus.Text = "Disconnected";
                //    connectButton.IsEnabled = true;
                //    sendButton.IsEnabled = false;
                //});
                //await Task.Delay(new Random().Next(0, 5) * 1000);
                //await ConnectAsync();
            };

            await ConnectAsync();
        }
        public MainWindow()
        {
            InitializeComponent();
            InitializeSignalR();
            this.DataContext = CurrentDataContext;
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            CurrentDataContext.Initialize();
        }

        override protected void OnClosing(System.ComponentModel.CancelEventArgs e)
        {
            base.OnClosing(e);
            if (_connection != null)
            {
                _ = _connection.DisposeAsync();
            }
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
#if DEBUG
            Thread.Sleep(1000); // Simulate a delay for debugging purposes
#endif
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