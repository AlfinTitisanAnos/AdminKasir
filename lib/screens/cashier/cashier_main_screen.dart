import 'package:flutter/material.dart';
import 'cashier_dashboard_screen.dart';
import 'cashier_product_screen.dart';
import 'transaction_history_screen.dart';
import 'cashier_profile_screen.dart';

class CashierMainScreen extends StatefulWidget {
  const CashierMainScreen({super.key});
  @override
  State<CashierMainScreen> createState() => _CashierMainScreenState();
}

class _CashierMainScreenState extends State<CashierMainScreen> {
  int _currentIndex = 0;
  void _changeTab(int index) => setState(() => _currentIndex = index);

  late final List<Widget> _screens = [
    CashierDashboardScreen(onStartTransaction: () => _changeTab(1)),
    const CashierProductScreen(),
    const TransactionHistoryScreen(),
    const CashierProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _changeTab,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.inventory_2), label: 'Barang'),
          NavigationDestination(icon: Icon(Icons.receipt_long), label: 'Transaksi'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}