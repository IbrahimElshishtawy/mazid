/// موديل لمنتجات التبديل
class SwapProductModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String ownerId; // (user id)
  String status; // (pending, accepted, rejected, completed)
  final DateTime createdAt;
  final double price;
  final double rating;

  SwapProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.ownerId,
    required this.status,
    required this.createdAt,
    required this.price,
    required this.rating,
  });

  factory SwapProductModel.fromJson(Map<String, dynamic> json) {
    return SwapProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      ownerId: json['owner_id'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : (json['price'] ?? 0.0).toDouble(),
      rating: (json['rating'] is int)
          ? (json['rating'] as int).toDouble()
          : (json['rating'] ?? 0.0).toDouble(),
    );
  }

  String get image => imageUrl;
  double get currentPrice => price;
  String get title => name;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'owner_id': ownerId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'price': price,
      'rating': rating,
    };
  }

  SwapProductModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? ownerId,
    String? status,
    DateTime? createdAt,
    double? price,
    double? rating,
  }) {
    return SwapProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      ownerId: ownerId ?? this.ownerId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      price: price ?? this.price,
      rating: rating ?? this.rating,
    );
  }
}
