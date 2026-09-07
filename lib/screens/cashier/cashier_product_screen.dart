import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/transaction_provider.dart';
import 'cart_screen.dart';

class CashierProductScreen extends StatelessWidget {
  const CashierProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pProv = Provider.of<ProductProvider>(context);
    final tProv = Provider.of<TransactionProvider>(context);
    final products = pProv.filteredProducts;

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Barang'), automaticallyImplyLeading: false),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: pProv.setSearchQuery,
              decoration: InputDecoration(
                hintText: 'Cari barang...', prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                filled: true, fillColor: Colors.grey[200],
              ),
            ),
          ),
          Expanded(
            child: products.isEmpty
                ? const Center(child: Text('Barang tidak ditemukan'))
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 1 / 1.15, crossAxisSpacing: 12, mainAxisSpacing: 12,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final p = products[index];
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: const BorderRadius.vertical(top: Radius.circular(16))),
                                child: const Center(child: Icon(Icons.inventory_2, size: 40, color: Colors.green)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Rp${p.finalPrice.toStringAsFixed(0)}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13)),
                                      Text('Stok: ${p.stock}', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 4),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        textStyle: const TextStyle(fontSize: 12)
                                      ),
                                      onPressed: p.stock == 0 ? null : () {
                                        try {
                                          tProv.addToCart(p);
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${p.name} ditambahkan'), duration: const Duration(milliseconds: 500)));
                                        } catch (e) {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
                                        }
                                      },
                                      icon: const Icon(Icons.add, size: 16),
                                      label: const Text('Tambah'),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          if (tProv.cart.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -2))]
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${tProv.cart.length} Item', style: TextStyle(color: Colors.grey[600])),
                        Text('Rp${tProv.cartTotal.toStringAsFixed(0)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
                      icon: const Icon(Icons.shopping_cart), label: const Text('Keranjang'),
                    )
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}