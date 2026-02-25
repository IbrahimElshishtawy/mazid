import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_shop/core/models/order_model.dart';
import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderInitial());

  List<OrderModel> _orders = [];

  void fetchOrders() {
    emit(OrderLoading());
    // Simulate fetching orders
    Future.delayed(const Duration(seconds: 1), () {
      emit(OrderLoaded(_orders));
    });
  }

  void placeOrder(OrderModel order) {
    _orders.add(order);
    emit(OrderLoaded(List.from(_orders)));
  }
}
