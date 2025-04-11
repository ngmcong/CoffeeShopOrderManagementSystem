import 'package:coffeeshopordermanagementsystem/dataentities.dart';
import 'package:coffeeshopordermanagementsystem/products.dart';
import 'package:coffeeshopordermanagementsystem/tables.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ShopTable? selectedItem;

  void _showTables() {
    List<ShopTable> items = [
      ShopTable(id: 1, name: 'Table 1'),
      ShopTable(id: 2, name: 'Table 2'),
      ShopTable(id: 3, name: 'Table 3'),
    ];
    showDialog(
      context: context,
      builder: (context) => TableSelectionDialog(items: items),
    ).then((selectedItem) {
      if (selectedItem != null) {
        setState(() {
          this.selectedItem = selectedItem;
        });
      }
    });
  }

  void _showProducts() {
    List<Product> items = [
      Product(id: 1, name: 'Espresso', price: 30000),
      Product(id: 2, name: 'Cappuccino', price: 35000),
      Product(id: 3, name: 'Latte', price: 40000),
      Product(id: 4, name: 'Americano', price: 25000),
      Product(id: 5, name: 'Mocha', price: 45000),
      Product(id: 6, name: 'Macchiato', price: 38000),
      Product(id: 7, name: 'Flat White', price: 37000),
      Product(id: 8, name: 'Affogato', price: 42000),
      Product(id: 9, name: 'Cold Brew', price: 32000),
      Product(id: 10, name: 'Iced Coffee', price: 28000),
    ];
    showDialog(
      context: context,
      builder: (context) => ProductSelectionDialog(items: items),
    ).then((selectedItem) {
      if (selectedItem != null) {
        setState(() {
          Product product = selectedItem;
          setState(() {
            if (products.any((p) => p.id == product.id)) {
              // If the product already exists, increase its quantity
              products.firstWhere((p) => p.id == product.id).qty++;
            } else {
              products.add(selectedItem);
            }
          });
        });
      }
    });
  }

  List<Product> products = [
    Product(id: 1, name: 'Espresso', price: 30000),
    Product(id: 2, name: 'Cappuccino', price: 35000),
    Product(id: 3, name: 'Latte', price: 40000),
    Product(id: 4, name: 'Americano', price: 25000),
    Product(id: 5, name: 'Mocha', price: 45000),
  ];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Number of columns
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: products.length, // Number of products
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    elevation: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(product.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('Price: ${product.price} VND'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Qty: ${product.qty}',
                                style: const TextStyle(fontSize: 14)),
                            Text('Amount: ${product.qty * product.price} VND',
                                style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Text(
              'Total Amount: ${products.fold<int>(0, (sum, product) => sum + (product.price.toInt() * product.qty))} VND',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              selectedItem?.name ?? 'No table selected',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Table',
          ),
        ],
        currentIndex: 0, // Set the current selected index
        selectedItemColor: Colors.deepPurple,
        onTap: (int index) {
          // Handle button tap
          switch (index) {
            case 0:
              // Navigate to Home
              break;
            case 1:
              // Navigate to Menu
              _showProducts();
              break;
            case 2:
              // Navigate to Tables
              _showTables();
              break;
          }
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _showTables,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.select_all),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
