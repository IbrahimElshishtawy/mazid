import 'package:equatable/equatable.dart';

class SellerAnalytics {
  final double dailyProfit;
  final double weeklyProfit;
  final double monthlyProfit;
  final double annualProfit;
  final int dailyInventory;
  final int weeklyInventory;
  final int monthlyInventory;
  final int annualInventory;
  final double dailyLoss;
  final double weeklyLoss;
  final double monthlyLoss;
  final double annualLoss;

  SellerAnalytics({
    this.dailyProfit = 0,
    this.weeklyProfit = 0,
    this.monthlyProfit = 0,
    this.annualProfit = 0,
    this.dailyInventory = 0,
    this.weeklyInventory = 0,
    this.monthlyInventory = 0,
    this.annualInventory = 0,
    this.dailyLoss = 0,
    this.weeklyLoss = 0,
    this.monthlyLoss = 0,
    this.annualLoss = 0,
  });
}

abstract class SellerState extends Equatable {
  const SellerState();
  @override
  List<Object?> get props => [];
}

class SellerInitial extends SellerState {}
class SellerLoading extends SellerState {}
class SellerLoaded extends SellerState {
  final SellerAnalytics analytics;
  const SellerLoaded(this.analytics);
  @override
  List<Object?> get props => [analytics];
}
class SellerError extends SellerState {
  final String message;
  const SellerError(this.message);
  @override
  List<Object?> get props => [message];
}
