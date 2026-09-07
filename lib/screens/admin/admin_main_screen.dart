import 'package:flutter/material.dart';
import 'admin_dashboard_screen.dart';
import 'product_management_screen.dart';
import 'sales_report_screen.dart';
import 'admin_profile_screen.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});
  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _currentIndex = 0;
  void _changeTab(int index) => setState(() => _currentIndex = index);

  late final List<Widget> _screens = [
    AdminDashboardScreen(onNavigate: _changeTab),
    const ProductManagementScreen(),
    const SalesReportScreen(),
    const AdminProfileScreen(),
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
          NavigationDestination(icon: Icon(Icons.analytics), label: 'Penjualan'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}