import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/transaction_model.dart';
import '../providers/auth_provider.dart';

class ReceiptDialog extends StatelessWidget {
  final TransactionModel transaction;
  const ReceiptDialog({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final fmtCur = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final fmtDate = DateFormat('dd MMM yyyy, HH:mm');

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 350, maxHeight: MediaQuery.of(context).size.height * 0.8),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(child: Icon(Icons.store, size: 40, color: Colors.green)),
              const SizedBox(height: 8),
              const Center(child: Text('TEFA TOKO', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2))),
              Center(child: Text('SMKN 20 Jakarta', style: TextStyle(fontSize: 12, color: Colors.grey[600]))),
              const SizedBox(height: 12), _dashedDivider(), const SizedBox(height: 12),
              Text('No: ${transaction.id}', style: const TextStyle(fontFamily: 'Courier', fontSize: 12)),
              Text('Tgl: ${fmtDate.format(transaction.date)}', style: const TextStyle(fontFamily: 'Courier', fontSize: 12)),
              Text('Kasir: ${transaction.cashierName}', style: const TextStyle(fontFamily: 'Courier', fontSize: 12)),
              const SizedBox(height: 12), _dashedDivider(), const SizedBox(height: 12),
              ...transaction.items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.product.name, style: const TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${item.quantity} x ${fmtCur.format(item.product.finalPrice)}', style: const TextStyle(fontFamily: 'Courier', fontSize: 12)),
                        Text(fmtCur.format(item.subtotal), style: const TextStyle(fontFamily: 'Courier', fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              )).toList(),
              const SizedBox(height: 12), _dashedDivider(), const SizedBox(height: 12),
              _receiptRow('Total Item', transaction.items.fold(0, (sum, item) => sum + item.quantity).toString()),
              _receiptRow('Total Bayar', fmtCur.format(transaction.total), isBold: true),
              _receiptRow('Tunai', fmtCur.format(transaction.paid)),
              _receiptRow('Kembalian', fmtCur.format(transaction.change)),
              const SizedBox(height: 20), _dashedDivider(), const SizedBox(height: 20),
              const Center(child: Text('Terima Kasih 🙏', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  final auth = Provider.of<AuthProvider>(context, listen: false);
                  if (auth.user?.role == 'admin') {
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                },
                child: const Text('Selesai'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _receiptRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontFamily: 'Courier', fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: 13)),
          Text(value, style: TextStyle(fontFamily: 'Courier', fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _dashedDivider() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dashWidth = 4.0;
        final dashCount = (constraints.maxWidth / (2 * dashWidth)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) => Container(width: dashWidth, height: 1, color: Colors.grey)),
        );
      },
    );
  }
}