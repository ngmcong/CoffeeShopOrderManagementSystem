import 'dart:convert';

import 'package:coffeeshopordermanagementsystem/bottomnavigationbar.dart';
import 'package:coffeeshopordermanagementsystem/dataentities.dart';
import 'package:coffeeshopordermanagementsystem/detail.dart';
import 'package:coffeeshopordermanagementsystem/tables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  bool isEditing = false;

  Future<List<ShopTable>> _fetchShopTables() async {
    final url =
        Uri.parse('$httpAddress/tables/load'); // Replace with your API endpoint
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return await Future.wait(
            data.map((item) => ShopTable.fromJson(item)).toList());
      } else {
        throw Exception('Failed to load shop tables');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching shop tables: $e');
      }
    }
    return []; // Return an empty list in case of error
  }

  List<ShopTable>? tables;
  Future<void> _showTables() async {
    tables ??= await _fetchShopTables();
    if (!mounted) return; // Check if the widget is still mounted
    showDialog(
      context: context,
      builder: (context) => TableSelectionDialog(items: tables!),
    ).then((selectedItem) {
      if (selectedItem != null) {
        setState(() {
          this.selectedItem = selectedItem;
          _fetchTableProducts(selectedItem.id).then((products) {
            setState(() {
              tableProducts = products;
              isEditing = false; // Reset editing state after loading products
            });
          });
        });
      }
    });
  }

  List<Product> tableProducts = [];

  Future<List<Product>> _fetchTableProducts(int tableId) async {
    final url = Uri.parse(
        '$httpAddress/tables/loadproducts/$tableId'); // Replace with your API endpoint
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        var products =
            await Future.wait(data.map((item) async => Product.fromJson(item)));
        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching products: $e');
      }
    }
    return []; // Return an empty list in case of error
  }

  Future<void> _saveTableProducts() async {
    final url = Uri.parse(
        '$httpAddress/tables/OccupiedAndOrderning/${selectedItem!.id}'); // Replace with your API endpoint
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            tableProducts.map((product) => product.toJson()).toList()),
      );
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Table products saved successfully');
        }
        setState(() {
          isEditing = false; // Reset editing state after saving
        });
      } else {
        throw Exception('Failed to save table products');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving table products: $e');
      }
    }
  }

  List<ShopTable> generateShopTables() {
    return List.generate(
      20,
      (index) => ShopTable(
        id: index + 1,
        name: 'Table ${index + 1}',
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    tables = generateShopTables(); // Initialize the list of tables
  }

  @override
  Widget build(BuildContext context) {
    rootContext = context;
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
                itemCount: tables?.length ?? 0, // Number of tables
                itemBuilder: (context, index) {
                  final table = tables![index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedItem = table;
                        _fetchTableProducts(table.id).then((products) {
                          setState(() {
                            tableProducts = products;
                            isEditing = false; // Reset editing state
                          });
                        });
                      });
                    },
                    child: Card(
                      elevation: 4,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailPage(shopTable: table),
                              ),
                            );
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(table.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text(
                              'Status: ${table.status == ShopTableStatus.available ? 'Available' : 'Occupied'}',
                              style: TextStyle(
                                color: table.status == ShopTableStatus.available
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _showTables,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.select_all),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
