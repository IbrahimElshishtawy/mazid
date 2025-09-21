import 'swap_status.dart';

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
  final SwapStatus status; // 🔄 Enum بدل String

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
    this.status = SwapStatus.available, // ✅ default
  });

  // 🔄 من JSON
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
      status: _mapStatus(json['status']), // ✅ تحويل String → Enum
    );
  }

  // 🔄 لـ JSON
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
      'status': status.name, // ✅ يتخزن كـ String
    };
  }

  // 🔄 نسخة معدلة
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
    SwapStatus? status,
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
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'SwapProductModel(id: $id, title: $title, startingPrice: $startingPrice, currentBid: $currentBid, endDate: $endDate, status: ${status.name})';
  }

  // ✅ helper لتحويل String إلى Enum
  static SwapStatus _mapStatus(String? status) {
    switch (status) {
      case "pending":
        return SwapStatus.pending;
      case "sold":
        return SwapStatus.sold;
      case "available":
      default:
        return SwapStatus.available;
    }
  }
}
