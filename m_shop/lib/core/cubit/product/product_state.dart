import 'package:equatable/equatable.dart';
import 'package:m_shop/core/models/prouduct/product_models.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductModel> products;
  final List<ProductModel> filteredProducts;
  final Set<String> favorites;

  const ProductLoaded({
    required this.products,
    required this.filteredProducts,
    required this.favorites,
  });

  @override
  List<Object?> get props => [products, filteredProducts, favorites];
}

class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}
