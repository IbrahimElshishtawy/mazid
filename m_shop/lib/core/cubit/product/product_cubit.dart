import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_shop/core/models/prouduct/product_models.dart';
import 'package:m_shop/core/service/api/product_service.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductService _productService;

  ProductCubit(this._productService) : super(ProductInitial());

  List<ProductModel> _allProducts = [];
  Set<String> _favorites = {};

  Future<void> fetchProducts() async {
    emit(ProductLoading());
    try {
      final products = await _productService.fetchAllProducts();
      _allProducts = products;
      emit(ProductLoaded(
        products: _allProducts,
        filteredProducts: _allProducts,
        favorites: _favorites,
      ));
    } catch (e) {
      emit(ProductError("Failed to fetch products: $e"));
    }
  }

  void filterProducts(String query, String? category) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      List<ProductModel> filtered = _allProducts;

      if (category != null && category.toLowerCase() != 'all') {
        filtered = filtered.where((p) => p.category.toLowerCase() == category.toLowerCase()).toList();
      }

      if (query.isNotEmpty) {
        filtered = filtered.where((p) => p.name.toLowerCase().contains(query.toLowerCase())).toList();
      }

      emit(ProductLoaded(
        products: _allProducts,
        filteredProducts: filtered,
        favorites: _favorites,
      ));
    }
  }

  void toggleFavorite(String productId) {
    if (_favorites.contains(productId)) {
      _favorites.remove(productId);
    } else {
      _favorites.add(productId);
    }
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      emit(ProductLoaded(
        products: _allProducts,
        filteredProducts: currentState.filteredProducts,
        favorites: Set.from(_favorites),
      ));
    }
  }
}
