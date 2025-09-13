// ignore_for_file: depend_on_referenced_packages, implementation_imports

import 'package:postgrest/src/types.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final String phone;
  final String password;
  final String imageUrl;

  // محفظة المستخدم
  // ignore: strict_top_level_inference
  final double walletBalance;

  // طلبات وأوامر
  final int pendingOrders;
  final int totalCancelledOrders;
  final int receivedOrders;
  final int unreceivedOrders;

  // إحصائيات مالية وتجارية
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
    required this.password,
    required this.imageUrl,
    this.walletBalance = 0,
    this.pendingOrders = 0,
    this.totalCancelledOrders = 0,
    this.receivedOrders = 0,
    this.unreceivedOrders = 0,
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
      password: json['password'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      walletBalance: json['walletBalance'] ?? 0,
      pendingOrders: json['pendingOrders'] ?? 0,
      totalCancelledOrders: json['totalCancelledOrders'] ?? 0,
      receivedOrders: json['receivedOrders'] ?? 0,
      unreceivedOrders: json['unreceivedOrders'] ?? 0,
      totalSales: json['totalSales'] ?? 0,
      totalPurchases: json['totalPurchases'] ?? 0,
      totalAuctions: json['totalAuctions'] ?? 0,
      totalSpent: (json['totalSpent'] ?? 0).toDouble(),
      totalEarned: (json['totalEarned'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'phone': phone,
      'password': password,
      'imageUrl': imageUrl,
      'walletBalance': walletBalance,
      'pendingOrders': pendingOrders,
      'totalCancelledOrders': totalCancelledOrders,
      'receivedOrders': receivedOrders,
      'unreceivedOrders': unreceivedOrders,
      'totalSales': totalSales,
      'totalPurchases': totalPurchases,
      'totalAuctions': totalAuctions,
      'totalSpent': totalSpent,
      'totalEarned': totalEarned,
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
      password: map['password'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      walletBalance: map['walletBalance'] as double? ?? 0,
      pendingOrders: map['pendingOrders'] as int? ?? 0,
      totalCancelledOrders: map['totalCancelledOrders'] as int? ?? 0,
      receivedOrders: map['receivedOrders'] as int? ?? 0,
      unreceivedOrders: map['unreceivedOrders'] as int? ?? 0,
      totalSales: map['totalSales'] as int? ?? 0,
      totalPurchases: map['totalPurchases'] as int? ?? 0,
      totalAuctions: map['totalAuctions'] as int? ?? 0,
      totalSpent: (map['totalSpent'] as num?)?.toDouble() ?? 0.0,
      totalEarned: (map['totalEarned'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
