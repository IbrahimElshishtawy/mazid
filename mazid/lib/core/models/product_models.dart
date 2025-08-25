class ProductModel {
  final String id;
  final String name;
  final String category;
  final String image;
  final double price;
  final double rate;
  final String ownerId;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.price,
    required this.rate,
    required this.ownerId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      image: json['image'],
      price: (json['price'] ?? 0).toDouble(),
      rate: (json['rate'] ?? 0).toDouble(),
      ownerId: json['ownerid'],
    );
  }
}
