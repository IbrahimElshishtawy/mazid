import 'package:mazid/core/models/product_models.dart';

enum SwapStatus { pending, accepted, rejected }

class SwapRequestModel {
  final String id;
  final ProductModel senderProduct;
  final ProductModel receiverProduct;
  final String senderId;
  final String urlimage;
  final String receiverId;
  SwapStatus status;
  final DateTime createdAt;

  SwapRequestModel({
    required this.id,
    required this.senderProduct,
    required this.receiverProduct,
    required this.senderId,
    required this.receiverId,
    required this.urlimage,
    this.status = SwapStatus.pending,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// factory من JSON
  factory SwapRequestModel.fromJson(Map<String, dynamic> json) {
    SwapStatus parseStatus(String? status) {
      switch (status) {
        case 'accepted':
          return SwapStatus.accepted;
        case 'rejected':
          return SwapStatus.rejected;
        default:
          return SwapStatus.pending;
      }
    }

    return SwapRequestModel(
      id: _safeString(json['_id'] ?? json['id']),
      senderProduct: ProductModel.fromJson(json['senderProduct'] ?? {}),
      receiverProduct: ProductModel.fromJson(json['receiverProduct'] ?? {}),
      senderId: _safeString(json['senderId']),
      receiverId: _safeString(json['receiverId']),
      urlimage: _safeString(json['image'] as String?),
      status: parseStatus(json['status'] as String?),
      createdAt:
          DateTime.tryParse(_safeString(json['createdAt'])) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'senderProduct': senderProduct.toJson(),
      'receiverProduct': receiverProduct.toJson(),
      'senderId': senderId,
      'receiverId': receiverId,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// نسخة مع تعديل قيم محددة
  SwapRequestModel copyWith({
    String? id,
    ProductModel? senderProduct,
    ProductModel? receiverProduct,
    String? senderId,
    String? receiverId,
    String? urlimage,
    SwapStatus? status,
    DateTime? createdAt,
  }) {
    return SwapRequestModel(
      id: id ?? this.id,
      senderProduct: senderProduct ?? this.senderProduct,
      receiverProduct: receiverProduct ?? this.receiverProduct,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      status: status ?? this.status,
      urlimage: urlimage ?? this.urlimage,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'SwapRequestModel(id: $id, sender: ${senderProduct.title}, receiver: ${receiverProduct.title}, status: $status)';
  }

  /// helper method
  static String _safeString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }
}
