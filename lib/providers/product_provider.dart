import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> _products = [];
  String _searchQuery = '';
  String? _selectedCategory;

  List<ProductModel> get products => _products;
  List<String> get categories => _products.map((p) => p.category).toSet().toList();
  
  List<ProductModel> get filteredProducts {
    return _products.where((p) {
      final matchSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchCategory = _selectedCategory == null || p.category == _selectedCategory;
      return matchSearch && matchCategory;
    }).toList();
  }

  List<ProductModel> get lowStockProducts => _products.where((p) => p.stock < 10).toList();

  ProductProvider() { _initDummyData(); }

  void setSearchQuery(String query) { _searchQuery = query; notifyListeners(); }
  void setCategory(String? category) { _selectedCategory = category; notifyListeners(); }

  void _initDummyData() {
    _products = [
      ProductModel(id: '1', name: 'Indomie Goreng', category: 'Makanan', buyPrice: 2500, sellPrice: 3500, discount: 0, stock: 50, unit: 'Pcs', createdAt: DateTime.now()),
      ProductModel(id: '2', name: 'Roti Cokelat', category: 'Makanan', buyPrice: 5000, sellPrice: 7000, discount: 10, stock: 8, unit: 'Pcs', createdAt: DateTime.now()),
      ProductModel(id: '3', name: 'Teh Botol', category: 'Minuman', buyPrice: 3500, sellPrice: 5000, discount: 5, stock: 40, unit: 'Botol', createdAt: DateTime.now()),
      ProductModel(id: '4', name: 'Air Mineral', category: 'Minuman', buyPrice: 1500, sellPrice: 3000, discount: 0, stock: 75, unit: 'Botol', createdAt: DateTime.now()),
      ProductModel(id: '5', name: 'Keripik Singkong', category: 'Snack', buyPrice: 5000, sellPrice: 8000, discount: 10, stock: 5, unit: 'Pcs', createdAt: DateTime.now()),
    ];
    notifyListeners();
  }

  void addProduct(ProductModel p) { _products.add(p); notifyListeners(); }
  void updateProduct(ProductModel p) {
    final i = _products.indexWhere((x) => x.id == p.id);
    if (i != -1) { _products[i] = p; notifyListeners(); }
  }
  void deleteProduct(String id) { _products.removeWhere((p) => p.id == id); notifyListeners(); }
  void addStock(String id, int amt) {
    final i = _products.indexWhere((p) => p.id == id);
    if (i != -1) { _products[i].stock += amt; notifyListeners(); }
  }
  void reduceStock(String id, int amt) {
    final i = _products.indexWhere((p) => p.id == id);
    if (i != -1 && _products[i].stock >= amt) { _products[i].stock -= amt; notifyListeners(); }
  }
}