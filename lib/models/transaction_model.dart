import 'product_model.dart';

class CartItem {
  final ProductModel product;
  int quantity;
  CartItem({required this.product, required this.quantity});
  double get subtotal => product.finalPrice * quantity;
}

class TransactionModel {
  final String id;
  final String cashierName;
  final DateTime date;
  final List<CartItem> items;
  final double total;
  final double paid;
  final double change;

  TransactionModel({
    required this.id, required this.cashierName, required this.date,
    required this.items, required this.total, required this.paid, required this.change,
  });
}