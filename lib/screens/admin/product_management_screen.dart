import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../models/product_model.dart';
import '../../widgets/app_card.dart';

class ProductManagementScreen extends StatelessWidget {
  const ProductManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pProv = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Barang')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context),
        child: const Icon(Icons.add),
      ),
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
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: pProv.filteredProducts.length,
              itemBuilder: (context, index) {
                final p = pProv.filteredProducts[index];
                return AppCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  onTap: () => _showForm(context, product: p),
                  child: Row(
                    children: [
                      Container(width: 50, height: 50,
                        decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.inventory_2, color: Colors.green)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('Stok: ${p.stock} ${p.unit}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Rp${p.finalPrice.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                          if (p.discount > 0)
                            Text('Rp${p.sellPrice.toStringAsFixed(0)}', style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showForm(BuildContext context, {ProductModel? product}) {
    final isEdit = product != null;
    final nameCtrl = TextEditingController(text: product?.name ?? '');
    final catCtrl = TextEditingController(text: product?.category ?? '');
    final buyCtrl = TextEditingController(text: product?.buyPrice.toStringAsFixed(0) ?? '');
    final sellCtrl = TextEditingController(text: product?.sellPrice.toStringAsFixed(0) ?? '');
    final stockCtrl = TextEditingController(text: product?.stock.toString() ?? '0');
    final discCtrl = TextEditingController(text: product?.discount.toStringAsFixed(0) ?? '0');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Edit Barang' : 'Tambah Barang'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nama Barang')),
              TextField(controller: catCtrl, decoration: const InputDecoration(labelText: 'Kategori')),
              TextField(controller: buyCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Harga Beli')),
              TextField(controller: sellCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Harga Jual')),
              TextField(controller: discCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Diskon (%)')),
              TextField(controller: stockCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Stok')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              final pProv = Provider.of<ProductProvider>(context, listen: false);
              if (isEdit) {
                product.name = nameCtrl.text; product.category = catCtrl.text;
                product.buyPrice = double.parse(buyCtrl.text); product.sellPrice = double.parse(sellCtrl.text);
                product.discount = double.parse(discCtrl.text); product.stock = int.parse(stockCtrl.text);
                pProv.updateProduct(product);
              } else {
                pProv.addProduct(ProductModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameCtrl.text, category: catCtrl.text,
                  buyPrice: double.parse(buyCtrl.text), sellPrice: double.parse(sellCtrl.text),
                  discount: double.parse(discCtrl.text), stock: int.parse(stockCtrl.text),
                  unit: 'Pcs', createdAt: DateTime.now(),
                ));
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isEdit ? 'Barang diupdate' : 'Barang ditambahkan')));
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}