// lib/core/models/swap/swap_request_model.dart
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:m_shop/core/models/prouduct/product_models.dart' as pm;

class SwapProductModel implements pm.BaseProduct {
  @override
  final String id;
  @override
  final String title;
  @override
  final String name;
  @override
  final String image;
  @override
  final List<String> images;

  // حقول خاصة بالتبديل / المنتج
  final String swapId;
  final String requesterId;
  final String ownerId;
  final String imageUrl;
  final String description;
  final String status;
  final double price;
  final double rating;
  final DateTime? createdAt;

  SwapProductModel({
    required this.id,
    required this.title,
    required this.name,
    required this.image,
    required this.images,
    required this.swapId,
    required this.requesterId,
    this.ownerId = '',
    this.imageUrl = '',
    this.description = '',
    this.status = '',
    this.price = 0.0,
    this.rating = 0.0,
    this.createdAt,
  });

  factory SwapProductModel.fromJson(Map<String, dynamic> json) {
    String _s(dynamic v) => v == null ? '' : v.toString();

    double _toDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0.0;
      return 0.0;
    }

    List<String> _ls(dynamic v) {
      if (v is List) {
        return v.map((e) => _s(e)).toList();
      }
      return const <String>[];
    }

    DateTime? _toDate(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      if (v is String) return DateTime.tryParse(v);
      return null;
    }

    return SwapProductModel(
      id: _s(json['_id'] ?? json['id']),
      title: _s(json['title'] ?? json['name']),
      name: _s(json['name'] ?? json['title']),
      image: _s(json['image'] ?? json['thumbnail']),
      images: _ls(json['images']),
      swapId: _s(json['swapId']),
      requesterId: _s(json['requesterId']),
      ownerId: _s(json['ownerId']),
      imageUrl: _s(json['imageUrl']),
      description: _s(json['description']),
      status: _s(json['status']),
      price: _toDouble(json['price']),
      rating: _toDouble(json['rating']),
      createdAt: _toDate(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'title': title,
    'name': name,
    'image': image,
    'images': images,
    'swapId': swapId,
    'requesterId': requesterId,
    'ownerId': ownerId,
    'imageUrl': imageUrl,
    'description': description,
    'status': status,
    'price': price,
    'rating': rating,
    'createdAt': createdAt?.toIso8601String(),
  };
}
