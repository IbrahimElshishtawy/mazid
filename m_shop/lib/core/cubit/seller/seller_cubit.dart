import 'package:flutter_bloc/flutter_bloc.dart';
import 'seller_state.dart';

class SellerCubit extends Cubit<SellerState> {
  SellerCubit() : super(SellerInitial());

  void fetchAnalytics() {
    emit(SellerLoading());
    // Simulate fetching analytics with dummy data
    Future.delayed(const Duration(seconds: 1), () {
      emit(SellerLoaded(SellerAnalytics(
        dailyProfit: 150.0,
        weeklyProfit: 1200.0,
        monthlyProfit: 5000.0,
        annualProfit: 60000.0,
        dailyInventory: 10,
        weeklyInventory: 85,
        monthlyInventory: 340,
        annualInventory: 4000,
        dailyLoss: 20.0,
        weeklyLoss: 150.0,
        monthlyLoss: 600.0,
        annualLoss: 7000.0,
      )));
    });
  }
}
