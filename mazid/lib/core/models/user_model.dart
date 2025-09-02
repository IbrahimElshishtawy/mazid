import 'package:postgrest/src/types.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final String phone;

  // إحصائيات تجارية ومالية
  final int totalSales;
  final int totalPurchases;
  final int totalAuctions;
  final double totalSpent;
  final double totalEarned;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.phone,
    this.totalSales = 0,
    this.totalPurchases = 0,
    this.totalAuctions = 0,
    this.totalSpent = 0.0,
    this.totalEarned = 0.0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'] ?? '',
      phone: json['phone'] ?? '',
      totalSales: json['total_sales'] ?? 0,
      totalPurchases: json['total_purchases'] ?? 0,
      totalAuctions: json['total_auctions'] ?? 0,
      totalSpent: (json['total_spent'] ?? 0).toDouble(),
      totalEarned: (json['total_earned'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'phone': phone,
      'total_sales': totalSales,
      'total_purchases': totalPurchases,
      'total_auctions': totalAuctions,
      'total_spent': totalSpent,
      'total_earned': totalEarned,
    };
  }

  /// تحويل من Map الناتج من Supabase/PostgREST
  static UserModel fromMap(PostgrestMap map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      avatar: map['avatar'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      totalSales: map['total_sales'] as int? ?? 0,
      totalPurchases: map['total_purchases'] as int? ?? 0,
      totalAuctions: map['total_auctions'] as int? ?? 0,
      totalSpent: (map['total_spent'] as num?)?.toDouble() ?? 0.0,
      totalEarned: (map['total_earned'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
