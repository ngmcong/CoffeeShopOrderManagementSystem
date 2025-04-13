using System.ComponentModel;
using System.Configuration;
using System.Windows;
using Microsoft.AspNetCore.SignalR.Client;
using phantom.WPF.CoffeeShopOrderManagementSystem.UserControls;

namespace phantom.WPF.CoffeeShopOrderManagementSystem
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window, INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler? PropertyChanged;
        internal void OnPropertyChanged(string propertyName)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
        private HubConnection? _connection;
        private System.Windows.Controls.UserControl? _mainContentControl;
        public System.Windows.Controls.UserControl? MainContentControl
        {
            get => _mainContentControl; set
            {
                _mainContentControl = value;
                OnPropertyChanged(nameof(MainContentControl));
            }
        }

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
                Dispatcher.Invoke(() => // Ensure UI updates happen on the UI thread
                {
                    if (MainContentControl.DataContext is UCOrderViewModel)
                    {
                        (MainContentControl.DataContext as UCOrderViewModel)!.Initialize();
                    }
                });
            });

            //_connection.Closed += async (error) =>
            //{
            //    //Dispatcher.Invoke(() =>
            //    //{
            //    //    connectionStatus.Text = "Disconnected";
            //    //    connectButton.IsEnabled = true;
            //    //    sendButton.IsEnabled = false;
            //    //});
            //    //await Task.Delay(new Random().Next(0, 5) * 1000);
            //    //await ConnectAsync();
            //};

            await ConnectAsync();
        }

        public MainWindow()
        {
            InitializeComponent();
            this.DataContext = this;
            InitializeSignalR();
            Globals.MainWindow = this;
            MainContentControl = new UCOrderView();
            (MainContentControl.DataContext! as UCOrderViewModel)!.Initialize();
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
}