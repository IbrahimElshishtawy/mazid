// product_model.dart
class ProductModel {
  final String id;
  final String status;
  final String category;
  final String name;
  final String title;
  final double price;
  final String description;
  final String image;
  final List<String> images;
  final String company;
  final int countInStock;
  final int v;
  final int sales;

  ProductModel({
    required this.id,
    required this.status,
    required this.category,
    required this.name,
    required this.title,
    required this.price,
    required this.description,
    required this.image,
    required this.images,
    required this.company,
    required this.countInStock,
    required this.v,
    required this.sales,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    String safeString(dynamic value) {
      if (value == null) return '';
      if (value is String) return value;
      return value.toString();
    }

    return ProductModel(
      id: safeString(json['_id']),
      status: safeString(json['status']),
      category: safeString(json['category']),
      name: safeString(json['name']),
      title: safeString(json['title']),
      price: _toDouble(json['price']),
      description: safeString(json['description']),
      image: safeString(json['image']),
      images:
          (json['images'] as List?)?.map((e) => safeString(e)).toList() ?? [],
      company: safeString(json['company']),
      countInStock: json['countInStock'] ?? 0,
      v: json['__v'] ?? 0,
      sales: json['sales'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'status': status,
      'category': category,
      'name': name,
      'title': title,
      'price': price,
      'description': description,
      'image': image,
      'images': images,
      'company': company,
      'countInStock': countInStock,
      '__v': v,
      'sales': sales,
    };
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
