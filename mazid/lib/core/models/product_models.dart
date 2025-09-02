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
  final double rating; // التقييم
  final int ratingCount; // عدد المراجعات

  const ProductModel({
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
    this.rating = 0.0,
    this.ratingCount = 0,
  });

  /// getter يرجع أول صورة أو placeholder
  String get firstImage => (images.isNotEmpty && images.first.isNotEmpty)
      ? images.first
      : 'https://via.placeholder.com/150';

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // التعامل مع rating (ممكن يكون double أو Map)
    double rate = 0.0;
    int count = 0;

    if (json['rating'] != null) {
      if (json['rating'] is num) {
        // لو رجع 4 أو 4.5
        rate = (json['rating'] as num).toDouble();
      } else if (json['rating'] is String) {
        rate = double.tryParse(json['rating']) ?? 0.0;
      } else if (json['rating'] is Map) {
        final ratingObj = json['rating'] as Map;
        if (ratingObj['rate'] != null) {
          rate = _toDouble(ratingObj['rate']);
        }
        if (ratingObj['count'] != null) {
          count = (ratingObj['count'] as num).toInt();
        }
      }
    }

    return ProductModel(
      id: _safeString(json['_id'] ?? json['id']),
      status: _safeString(json['status']),
      category: _safeString(json['category']),
      name: _safeString(json['name']),
      title: _safeString(json['title']),
      price: _toDouble(json['price']),
      description: _safeString(json['description']),
      image: _safeString(json['image']),
      images:
          (json['images'] as List?)?.map((e) => _safeString(e)).toList() ?? [],
      company: _safeString(json['company']),
      countInStock: (json['countInStock'] as num?)?.toInt() ?? 0,
      v: (json['__v'] as num?)?.toInt() ?? 0,
      sales: (json['sales'] as num?)?.toInt() ?? 0,
      rating: rate,
      ratingCount: count,
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
      'rating': {'rate': rating, 'count': ratingCount},
    };
  }

  ProductModel copyWith({
    String? id,
    String? status,
    String? category,
    String? name,
    String? title,
    double? price,
    String? description,
    String? image,
    List<String>? images,
    String? company,
    int? countInStock,
    int? v,
    int? sales,
    double? rating,
    int? ratingCount,
  }) {
    return ProductModel(
      id: id ?? this.id,
      status: status ?? this.status,
      category: category ?? this.category,
      name: name ?? this.name,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      image: image ?? this.image,
      images: images ?? this.images,
      company: company ?? this.company,
      countInStock: countInStock ?? this.countInStock,
      v: v ?? this.v,
      sales: sales ?? this.sales,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
    );
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, title: $title, price: $price, rating: $rating, count: $ratingCount)';
  }

  /// helper methods
  static String _safeString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
