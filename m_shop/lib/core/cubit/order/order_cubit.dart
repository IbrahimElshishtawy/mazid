// m_shop/lib/core/cubit/order/order_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_shop/core/models/order/order_model.dart';
import 'package:m_shop/core/models/prouduct/product_models.dart';
import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderInitial());

  final List<OrderModel> _mockOrders = [];

  Future<void> fetchOrders() async {
    emit(OrderLoading());
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      emit(OrdersLoaded(List.from(_mockOrders)));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> placeOrder(ProductModel product, int quantity) async {
    emit(OrderLoading());
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final newOrder = OrderModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: "user_001",
        sellerId: product.company,
        items: [OrderItem(product: product, quantity: quantity)],
        totalAmount: product.price * quantity,
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
      );

      _mockOrders.insert(0, newOrder);
      emit(OrderPlacedSuccess(newOrder));
      emit(OrdersLoaded(List.from(_mockOrders)));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}
