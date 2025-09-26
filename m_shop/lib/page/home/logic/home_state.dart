import 'package:flutter/foundation.dart';
import 'package:m_shop/core/models/prouduct/product_models.dart';
import 'package:m_shop/core/models/user/user_model.dart';

@immutable
class HomeState {
  final List<ProductModel> products;
  final List<ProductModel> filtered;
  final bool loadingProducts;
  final bool loadingUser;
  final String? error;
  final UserModel? user;
  final int currentIndex;
  final String? selectedCategory;
  final String searchQuery;

  const HomeState({
    required this.products,
    required this.filtered,
    required this.loadingProducts,
    required this.loadingUser,
    required this.error,
    required this.user,
    required this.currentIndex,
    required this.selectedCategory,
    required this.searchQuery,
  });

  factory HomeState.initial() => const HomeState(
    products: [],
    filtered: [],
    loadingProducts: true,
    loadingUser: true,
    error: null,
    user: null,
    currentIndex: 2,
    selectedCategory: null,
    searchQuery: '',
  );

  HomeState copyWith({
    List<ProductModel>? products,
    List<ProductModel>? filtered,
    bool? loadingProducts,
    bool? loadingUser,
    String? error, // مرِّر null صراحة لمسح الخطأ
    UserModel? user,
    int? currentIndex,
    String? selectedCategory, // مرر '' لمسح الفئة
    String? searchQuery,
  }) {
    return HomeState(
      products: products ?? this.products,
      filtered: filtered ?? this.filtered,
      loadingProducts: loadingProducts ?? this.loadingProducts,
      loadingUser: loadingUser ?? this.loadingUser,
      error: error == null ? null : error, // null => clear
      user: user ?? this.user,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedCategory: selectedCategory == ''
          ? null
          : (selectedCategory ?? this.selectedCategory),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  bool get isBusy => loadingProducts || loadingUser;
  bool get hasError => (error ?? '').isNotEmpty;
  bool get isEmpty => !isBusy && filtered.isEmpty;
}
