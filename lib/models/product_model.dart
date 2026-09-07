class ProductModel {
  final String id;
  String name;
  String category;
  double buyPrice;
  double sellPrice;
  double discount;
  int stock;
  String unit;
  DateTime createdAt;

  ProductModel({
    required this.id, required this.name, required this.category,
    required this.buyPrice, required this.sellPrice, this.discount = 0,
    required this.stock, required this.unit, required this.createdAt,
  });

  double get finalPrice => sellPrice - (sellPrice * (discount / 100));
}