import 'package:coffeeshopordermanagementsystem/dataentities.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
BottomNavigationBar CustomBottomNavigationBar({bool isEnabledOrder = false}) {
  return BottomNavigationBar(
    items: <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        // icon: isEnabledOrder ? const Icon(Icons.menu_book) : const Icon(Icons.menu_book, color: Colors.grey),
        icon: const Icon(Icons.menu_book),
        label: 'Order',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Settings',
      ),
    ],
    currentIndex: 0, // Set the current selected index
    selectedItemColor: Colors.orangeAccent,
    unselectedItemColor: Colors.orangeAccent,
    onTap: (int index) {
      // Handle button tap
      switch (index) {
        case 0:
          // Navigate to Home
          // Navigator.of(rootContext!).popUntil((route) => route.isFirst);
          goHomePage();
          break;
        case 1:
          // if (!isEnabledOrder) return;
          // Navigate to Order
          // Navigator.push(
          //   rootContext!,
          //   MaterialPageRoute(builder: (context) => const Order()),
          // );
          break;
        case 2:
          break;
      }
    },
  );
}
