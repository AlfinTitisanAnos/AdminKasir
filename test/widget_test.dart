// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:tefa/models/models.dart';

void main() {
  test('transaction profit is calculated from item margins', () {
    final product = Product(
      id: 'P01',
      barcode: '123',
      name: 'Test Product',
      category: 'Food',
      costPrice: 3000,
      sellingPrice: 5000,
      stock: 10,
      minStock: 2,
      unit: 'pcs',
    );

    final transaction = Transaction(
      id: 'TRX-1',
      cashierName: 'Admin',
      date: DateTime(2026, 8, 28),
      items: [CartItem(product: product, quantity: 2)],
      subtotal: 10000,
      discount: 0,
      total: 10000,
      paid: 10000,
      change: 0,
      paymentMethod: 'Cash',
    );

    expect(transaction.totalProfit, 4000);
  });
}
