using phantom.CoffeeShopOrderManagementSystem.Service.Controllers;

namespace phantom.CoffeeShopOrderManagementSystem.Service
{
    public class Globals
    {
        public static string OrderFilePath =string.Empty;
        public static void SaveOrdersToFile()
        {
            try
            {
                using (var fileStream = new FileStream(Globals.OrderFilePath, FileMode.OpenOrCreate, FileAccess.ReadWrite))
                using (var streamWriter = new StreamWriter(fileStream))
                {
                    streamWriter.Write(Newtonsoft.Json.JsonConvert.SerializeObject(TablesController.Orders));
                    streamWriter.Close();
                    streamWriter.Dispose();
                    fileStream.Close();
                    fileStream.Dispose();
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                throw; // Re-throwing the exception without modifying the stack trace
            }
        }
    }
}
