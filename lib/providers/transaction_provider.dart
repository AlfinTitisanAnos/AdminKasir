import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../models/product_model.dart';
import 'product_provider.dart';

class TransactionProvider extends ChangeNotifier {
  final List<CartItem> _cart = [];
  final List<TransactionModel> _transactions = [];
  List<CartItem> get cart => _cart;
  List<TransactionModel> get transactions => _transactions;
  double get cartTotal => _cart.fold(0, (sum, item) => sum + item.subtotal);

  void addToCart(ProductModel p) {
    final i = _cart.indexWhere((x) => x.product.id == p.id);
    if (i != -1) {
      if (_cart[i].quantity < p.stock) _cart[i].quantity++;
      else throw Exception("Stok tidak mencukupi");
    } else {
      _cart.add(CartItem(product: p, quantity: 1));
    }
    notifyListeners();
  }

  void updateCartQty(String id, int qty) {
    final i = _cart.indexWhere((x) => x.product.id == id);
    if (i != -1) {
      if (qty <= 0) { _cart.removeAt(i); } 
      else { _cart[i].quantity = qty; }
      notifyListeners();
    }
  }

  void clearCart() { _cart.clear(); notifyListeners(); }

  TransactionModel processCheckout(double paid, String cashier, ProductProvider pp) {
    if (_cart.isEmpty) throw Exception("Keranjang kosong");
    double total = cartTotal;
    double change = paid - total;
    for (var item in _cart) { pp.reduceStock(item.product.id, item.quantity); }
    final trx = TransactionModel(
      id: 'TRX${DateTime.now().millisecondsSinceEpoch}', cashierName: cashier,
      date: DateTime.now(), items: List.from(_cart), total: total, paid: paid, change: change
    );
    _transactions.insert(0, trx);
    clearCart();
    return trx;
  }
}