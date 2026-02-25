// m_shop/lib/core/cubit/seller/seller_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'seller_state.dart';

class SellerCubit extends Cubit<SellerState> {
  SellerCubit() : super(SellerInitial());

  Future<void> loadSellerStats() async {
    emit(SellerLoading());
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      const stats = SellerStats(
        dailyRevenue: 150.0,
        weeklyRevenue: 1200.0,
        monthlyRevenue: 5000.0,
        annualRevenue: 60000.0,
        dailyLoss: 10.0,
        weeklyLoss: 50.0,
        monthlyLoss: 200.0,
        annualLoss: 2400.0,
        dailyInventory: 45,
        weeklyInventory: 300,
        monthlyInventory: 1200,
        annualInventory: 14000,
      );

      emit(const SellerLoaded(stats));
    } catch (e) {
      emit(SellerError(e.toString()));
    }
  }
}
