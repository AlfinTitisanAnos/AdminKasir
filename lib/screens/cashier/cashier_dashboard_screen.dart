import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../widgets/statistic_card.dart';

class CashierDashboardScreen extends StatelessWidget {
  final VoidCallback onStartTransaction;
  const CashierDashboardScreen({super.key, required this.onStartTransaction});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final tProv = Provider.of<TransactionProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Kasir')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Halo, ${auth.user?.name} 👋', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.5,
            children: [
              StatisticCard(title: 'Transaksi Hari Ini', value: tProv.transactions.length.toString(), icon: Icons.receipt, color: Colors.blue),
              StatisticCard(title: 'Total Penjualan', value: 'Rp${tProv.transactions.fold(0.0, (sum, item) => sum + item.total).toStringAsFixed(0)}', icon: Icons.money, color: Colors.green),
            ],
          ),
          const SizedBox(height: 24),
          Text('Quick Action', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _quickAction(icon: Icons.point_of_sale, label: 'Mulai Transaksi', color: Colors.green, onTap: onStartTransaction),
              _quickAction(icon: Icons.inventory_2, label: 'Lihat Barang', color: Colors.purple, onTap: onStartTransaction),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickAction({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}