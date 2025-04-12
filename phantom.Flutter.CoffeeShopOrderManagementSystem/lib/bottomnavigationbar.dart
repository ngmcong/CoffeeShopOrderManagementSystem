import 'package:coffeeshopordermanagementsystem/dataentities.dart';
import 'package:coffeeshopordermanagementsystem/order.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
BottomNavigationBar CustomBottomNavigationBar() {
  return BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.menu_book),
        label: 'Order',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Settings',
      ),
    ],
    currentIndex: 0, // Set the current selected index
    selectedItemColor: Colors.deepPurple,
    onTap: (int index) {
      // Handle button tap
      switch (index) {
        case 0:
          // Navigate to Home
          Navigator.of(rootContext!).popUntil((route) => route.isFirst);
          break;
        case 1:
          // Navigate to Order
          Navigator.push(
            rootContext!,
            MaterialPageRoute(builder: (context) => const Order()),
          );
          break;
        case 2:
          break;
      }
    },
  );
}
