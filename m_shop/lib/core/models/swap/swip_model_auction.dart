// lib/core/models/swap/swap_request_model.dart
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:m_shop/core/models/prouduct/product_models.dart' as pm;
//               ^^^^^^^ استخدم نفس المسار المستخدم في الشاشة تمامًا

class SwapProductModel implements pm.BaseProduct {
  // وفّر نفس الـ getters المطلوبة في BaseProduct
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

  // أي حقول إضافية خاصة بالـ swap
  final String swapId;
  final String requesterId;

  const SwapProductModel({
    required this.id,
    required this.title,
    required this.name,
    required this.image,
    required this.images,
    required this.swapId,
    required this.requesterId,
  });

  // لو عندك fromJson/toJson ضيفهم عادي
  factory SwapProductModel.fromJson(Map<String, dynamic> json) {
    String _s(dynamic v) => v == null ? '' : v.toString();
    List<String> _ls(dynamic v) =>
        (v is List ? v.map((e) => _s(e)).toList() : const <String>[]);

    return SwapProductModel(
      id: _s(json['_id'] ?? json['id']),
      title: _s(json['title'] ?? json['name']),
      name: _s(json['name'] ?? json['title']),
      image: _s(json['image'] ?? json['thumbnail']),
      images: _ls(json['images']),
      swapId: _s(json['swapId']),
      requesterId: _s(json['requesterId']),
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
  };
}
