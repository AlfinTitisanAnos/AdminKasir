import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/transaction_provider.dart';
import '../../widgets/app_card.dart';
import '../../widgets/receipt_dialog.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tProv = Provider.of<TransactionProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Transaksi')),
      body: tProv.transactions.isEmpty
          ? const Center(child: Text('Belum ada riwayat transaksi'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
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
    );
  }
}