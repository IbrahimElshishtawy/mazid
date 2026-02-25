// m_shop/lib/core/cubit/seller/seller_state.dart
import 'package:equatable/equatable.dart';

class SellerStats extends Equatable {
  final double dailyRevenue;
  final double weeklyRevenue;
  final double monthlyRevenue;
  final double annualRevenue;
  final double dailyLoss;
  final double weeklyLoss;
  final double monthlyLoss;
  final double annualLoss;
  final int dailyInventory;
  final int weeklyInventory;
  final int monthlyInventory;
  final int annualInventory;

  const SellerStats({
    this.dailyRevenue = 0,
    this.weeklyRevenue = 0,
    this.monthlyRevenue = 0,
    this.annualRevenue = 0,
    this.dailyLoss = 0,
    this.weeklyLoss = 0,
    this.monthlyLoss = 0,
    this.annualLoss = 0,
    this.dailyInventory = 0,
    this.weeklyInventory = 0,
    this.monthlyInventory = 0,
    this.annualInventory = 0,
  });

  @override
  List<Object?> get props => [
        dailyRevenue,
        weeklyRevenue,
        monthlyRevenue,
        annualRevenue,
        dailyLoss,
        weeklyLoss,
        monthlyLoss,
        annualLoss,
        dailyInventory,
        weeklyInventory,
        monthlyInventory,
        annualInventory,
      ];
}

abstract class SellerState extends Equatable {
  const SellerState();

  @override
  List<Object?> get props => [];
}

class SellerInitial extends SellerState {}

class SellerLoading extends SellerState {}

class SellerLoaded extends SellerState {
  final SellerStats stats;
  const SellerLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class SellerError extends SellerState {
  final String message;
  const SellerError(this.message);

  @override
  List<Object?> get props => [message];
}
