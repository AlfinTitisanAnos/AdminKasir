import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/transaction_provider.dart';
import '../../widgets/app_card.dart';
import '../../widgets/receipt_dialog.dart';

class SalesReportScreen extends StatelessWidget {
  const SalesReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tProv = Provider.of<TransactionProvider>(context);
    double totalRevenue = tProv.transactions.fold(0.0, (sum, item) => sum + item.total);

    return Scaffold(
      appBar: AppBar(title: const Text('Laporan Penjualan')),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Pendapatan', style: TextStyle(color: Colors.white70, fontSize: 14)),
                Text('Rp${totalRevenue.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('${tProv.transactions.length} Total Transaksi', style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          Expanded(
            child: tProv.transactions.isEmpty
                ? const Center(child: Text('Belum ada transaksi'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: tProv.transactions.length,
                    itemBuilder: (context, index) {
                      final trx = tProv.transactions[index];
                      return AppCard(
                        margin: const EdgeInsets.only(bottom: 12),
                        onTap: () => showDialog(context: context, builder: (_) => ReceiptDialog(transaction: trx)),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('TRX #${trx.id.substring(0, 10)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${trx.date} - ${trx.cashierName}'),
                          trailing: Text('Rp${trx.total.toStringAsFixed(0)}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}