// m_shop/lib/core/cubit/order/order_state.dart
import 'package:equatable/equatable.dart';
import 'package:m_shop/core/models/order/order_model.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrdersLoaded extends OrderState {
  final List<OrderModel> orders;
  const OrdersLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class OrderError extends OrderState {
  final String message;
  const OrderError(this.message);

  @override
  List<Object?> get props => [message];
}

class OrderPlacedSuccess extends OrderState {
  final OrderModel order;
  const OrderPlacedSuccess(this.order);

  @override
  List<Object?> get props => [order];
}
