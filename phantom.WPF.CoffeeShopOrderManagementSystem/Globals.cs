﻿using System.Configuration;
using phantom.Core.Restful;
using phantom.WPF.CoffeeShopOrderManagementSystem.UserControls;

namespace phantom.WPF.CoffeeShopOrderManagementSystem
{
    internal class Globals
    {
        private static string? coffeeShopAddress = null;
        public static string CoffeeShopAddress
        {
            get
            {
                if (coffeeShopAddress == null)
                {
                    coffeeShopAddress = ConfigurationManager.ConnectionStrings["CoffeeShopAddress"]?.ConnectionString ?? string.Empty;
                }
                return coffeeShopAddress!;
            }
        }
        private static RestfulHelper? restfulHelper;
        public static RestfulHelper RestfulHelper
        {
            get
            {
                if (restfulHelper == null)
                {
                    restfulHelper = new RestfulHelper();
                    restfulHelper.BaseUrl = CoffeeShopAddress;
                }
                return restfulHelper!;
            }
        }
        public static MainWindow? MainWindow;
        public static async void LoadUCOrderView()
        {
            MainWindow!.MainContentControl = new UCOrderView();
            await (MainWindow.MainContentControl.DataContext! as UCOrderViewModel)!.Initialize();
        }
    }
}
