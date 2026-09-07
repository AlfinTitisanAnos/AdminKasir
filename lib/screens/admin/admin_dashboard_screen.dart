import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/product_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/statistic_card.dart';
import '../../widgets/app_card.dart';

class AdminDashboardScreen extends StatelessWidget {
  final Function(int) onNavigate;
  const AdminDashboardScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final pProv = Provider.of<ProductProvider>(context);
    final tProv = Provider.of<TransactionProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    int totalProducts = pProv.products.length;
    int totalStock = pProv.products.fold(0, (sum, item) => sum + item.stock);
    int lowStock = pProv.lowStockProducts.length;
    double totalSales = tProv.transactions.fold(0.0, (sum, item) => sum + item.total);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        actions: [
          Stack(
            children: [
              IconButton(icon: const Icon(Icons.notifications), onPressed: () => _showNotif(context, pProv, tProv)),
              if (lowStock > 0)
                Positioned(right: 8, top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: Text(lowStock.toString(), style: const TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                )
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Halo, ${auth.user?.name} 👋', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.2,
            children: [
              StatisticCard(title: 'Total Barang', value: totalProducts.toString(), icon: Icons.inventory_2, color: Colors.green),
              StatisticCard(title: 'Total Stok', value: totalStock.toString(), icon: Icons.warehouse, color: Colors.purple),
              StatisticCard(title: 'Stok Menipis', value: lowStock.toString(), icon: Icons.warning, color: Colors.orange),
              StatisticCard(title: 'Penjualan', value: 'Rp${totalSales.toStringAsFixed(0)}', icon: Icons.money, color: Colors.blue),
            ],
          ),
          const SizedBox(height: 24),
          // Grafik Penjualan Sederhana
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Penjualan 7 Hari Terakhir', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 150,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: const FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              const FlSpot(0, 1), const FlSpot(1, 1.5), const FlSpot(2, 1.4), 
                              const FlSpot(3, 3), const FlSpot(4, 3.5), const FlSpot(5, 4), const FlSpot(6, 3.8)
                            ],
                            isCurved: true, color: Colors.green, barWidth: 4, isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(show: true, color: Colors.green.withOpacity(0.2)),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Quick Action', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _quickAction(icon: Icons.add_box, label: 'Tambah Barang', color: Colors.green, onTap: () => onNavigate(1)),
              _quickAction(icon: Icons.add, label: 'Tambah Stok', color: Colors.blue, onTap: () => _showStockDialog(context, true)),
              _quickAction(icon: Icons.remove, label: 'Kurangi Stok', color: Colors.red, onTap: () => _showStockDialog(context, false)),
              _quickAction(icon: Icons.receipt_long, label: 'Lihat Penjualan', color: Colors.purple, onTap: () => onNavigate(2)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Barang Stok Menipis', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              TextButton(onPressed: () => onNavigate(1), child: const Text('Lihat Semua'))
            ],
          ),
          const SizedBox(height: 12),
          ...pProv.lowStockProducts.map((p) => AppCard(
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const Icon(Icons.warning, color: Colors.orange),
                const SizedBox(width: 16),
                Expanded(child: Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600))),
                Text('Sisa: ${p.stock} ${p.unit}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            ),
          )).toList(),
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  void _showNotif(BuildContext context, ProductProvider pProv, TransactionProvider tProv) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Notifikasi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text('Stok Menipis', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
          ...pProv.lowStockProducts.map((p) => ListTile(
            leading: const Icon(Icons.warning, color: Colors.orange),
            title: Text(p.name),
            subtitle: Text('Sisa stok: ${p.stock}'),
          )),
          const SizedBox(height: 16),
          const Text('Transaksi Terbaru', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          ...tProv.transactions.take(3).map((t) => ListTile(
            leading: const Icon(Icons.check_circle, color: Colors.green),
            title: Text('TRX #${t.id.substring(0, 10)}'),
            subtitle: Text('Rp${t.total.toStringAsFixed(0)} - ${t.cashierName}'),
          )),
        ],
      ),
    );
  }

  void _showStockDialog(BuildContext context, bool isAdd) {
    final pProv = Provider.of<ProductProvider>(context, listen: false);
    final qtyCtrl = TextEditingController();
    String? selectedId;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isAdd ? 'Tambah Stok' : 'Kurangi Stok'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Pilih Barang'),
                value: selectedId,
                items: pProv.products.map((p) => DropdownMenuItem(value: p.id, child: Text('${p.name} (Stok: ${p.stock})'))).toList(),
                onChanged: (val) => setState(() => selectedId = val),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: qtyCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: isAdd ? 'Jumlah Masuk' : 'Jumlah Kurang', border: const OutlineInputBorder()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (selectedId == null || qtyCtrl.text.isEmpty) return;
              int qty = int.parse(qtyCtrl.text);
              if (isAdd) { pProv.addStock(selectedId!, qty); }
              else { pProv.reduceStock(selectedId!, qty); }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Stok berhasil diubah!')));
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}