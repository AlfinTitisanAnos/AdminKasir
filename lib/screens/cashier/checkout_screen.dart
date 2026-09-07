import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/receipt_dialog.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _paidController = TextEditingController();
  double _change = 0.0;

  void _calcChange(double total) {
    final paid = double.tryParse(_paidController.text) ?? 0;
    setState(() => _change = paid - total);
  }

  @override
  Widget build(BuildContext context) {
    final tProv = Provider.of<TransactionProvider>(context);
    final pProv = Provider.of<ProductProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    double total = tProv.cartTotal;

    return Scaffold(
      appBar: AppBar(title: const Text('Pembayaran')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Ringkasan Belanja', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          ...tProv.cart.map((item) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${item.product.name} (${item.quantity}x)'),
              Text('Rp${item.subtotal.toStringAsFixed(0)}'),
            ],
          )).toList(),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Bayar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('Rp${total.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
            ],
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _paidController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Uang Diterima', prefixText: 'Rp '),
            onChanged: (_) => _calcChange(total),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Kembalian'),
              Text('Rp${_change >= 0 ? _change.toStringAsFixed(0) : '0'}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            onPressed: () {
              if (_change < 0) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Uang yang diterima kurang!'), backgroundColor: Colors.red));
                return;
              }
              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Konfirmasi'),
                  content: const Text('Apakah transaksi ini sudah benar?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Batal')),
                    ElevatedButton(
                      onPressed: () {
                        final newTrx = tProv.processCheckout(double.parse(_paidController.text), auth.user?.name ?? 'Kasir', pProv);
                        Navigator.pop(dialogContext);
                        showDialog(context: context, barrierDismissible: false, builder: (_) => ReceiptDialog(transaction: newTrx));
                      },
                      child: const Text('Ya, Selesaikan'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Proses Transaksi'),
          )
        ],
      ),
    );
  }
}