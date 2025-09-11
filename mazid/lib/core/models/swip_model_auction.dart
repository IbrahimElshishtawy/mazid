class SwapProductModel {
  final String id; // معرف المنتج
  final String title; // عنوان المنتج
  final String description; // وصف المنتج
  final String image; // صورة أساسية
  final List<String> images; // صور متعددة
  final double startingPrice; // السعر الابتدائي
  final double currentBid; // آخر مزايدة
  final String owner; // صاحب المنتج
  final DateTime endDate; // وقت انتهاء المزاد
  final double rating; // تقييم
  final int ratingCount; // عدد التقييمات

  const SwapProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.images,
    required this.startingPrice,
    required this.currentBid,
    required this.owner,
    required this.endDate,
    this.rating = 0.0,
    this.ratingCount = 0,
  });

  factory SwapProductModel.fromJson(Map<String, dynamic> json) {
    return SwapProductModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      images:
          (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
      startingPrice: (json['startingPrice'] as num?)?.toDouble() ?? 0.0,
      currentBid: (json['currentBid'] as num?)?.toDouble() ?? 0.0,
      owner: json['owner'] ?? '',
      endDate: DateTime.tryParse(json['endDate'] ?? '') ?? DateTime.now(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'images': images,
      'startingPrice': startingPrice,
      'currentBid': currentBid,
      'owner': owner,
      'endDate': endDate.toIso8601String(),
      'rating': rating,
      'ratingCount': ratingCount,
    };
  }

  SwapProductModel copyWith({
    String? id,
    String? title,
    String? description,
    String? image,
    List<String>? images,
    double? startingPrice,
    double? currentBid,
    String? owner,
    DateTime? endDate,
    double? rating,
    int? ratingCount,
  }) {
    return SwapProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      images: images ?? this.images,
      startingPrice: startingPrice ?? this.startingPrice,
      currentBid: currentBid ?? this.currentBid,
      owner: owner ?? this.owner,
      endDate: endDate ?? this.endDate,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
    );
  }

  @override
  String toString() {
    return 'SwapProductModel(id: $id, title: $title, startingPrice: $startingPrice, currentBid: $currentBid, endDate: $endDate)';
  }
}
