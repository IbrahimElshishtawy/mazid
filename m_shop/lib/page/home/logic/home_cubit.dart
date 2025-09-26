import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_shop/core/models/prouduct/product_models.dart';
import 'package:m_shop/core/repository/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._repo) : super(HomeState.initial());

  final HomeRepository _repo;
  Timer? _debounce;

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }

  // ========= Init / Refresh =========
  Future<void> init() async {
    emit(state.copyWith(loadingProducts: true, loadingUser: true, error: null));

    await Future.wait([_loadProducts(), _loadUser()]);
  }

  Future<void> refresh() async {
    emit(state.copyWith(loadingProducts: true, error: null));
    await _loadProducts(forceRefresh: true);
  }

  Future<void> _loadProducts({bool forceRefresh = false}) async {
    try {
      final products = await _repo.getProducts(forceRefresh: forceRefresh);
      emit(state.copyWith(products: products, loadingProducts: false));
      _recomputeFiltered(); // بعد تحديث المنتجات
    } catch (e) {
      emit(
        state.copyWith(
          loadingProducts: false,
          error: "❌ خطأ أثناء تحميل المنتجات: $e",
        ),
      );
    }
  }

  Future<void> _loadUser() async {
    try {
      final user = await _repo.getCurrentUser();
      emit(state.copyWith(user: user, loadingUser: false));
    } catch (e) {
      emit(
        state.copyWith(
          loadingUser: false,
          error: "❌ خطأ أثناء تحميل بيانات المستخدم: $e",
        ),
      );
    }
  }

  // ========= Filters & Search =========

  void onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      emit(state.copyWith(searchQuery: query));
      _recomputeFiltered();
    });
  }

  void filterByCategory(String? category) {
    final normalized = category?.trim();
    final value = (normalized == null || normalized.isEmpty) ? '' : normalized;
    emit(state.copyWith(selectedCategory: value));
    _recomputeFiltered();
  }

  void clearFilters() {
    emit(state.copyWith(selectedCategory: '', searchQuery: ''));
    _recomputeFiltered();
  }

  void _recomputeFiltered() {
    List<ProductModel> base = state.products;

    // category filter
    if (state.selectedCategory != null) {
      final cat = state.selectedCategory!;
      base = base.where((p) => p.category == cat).toList();
    }

    // search
    final q = state.searchQuery.trim().toLowerCase();
    if (q.isNotEmpty) {
      base = base.where((p) {
        final name = p.name.toLowerCase();
        final desc = p.description.toLowerCase();
        return name.contains(q) || desc.contains(q);
      }).toList();
    }

    emit(state.copyWith(filtered: base));
  }

  // ========= UI State =========

  void changeTab(int index) {
    if (index == state.currentIndex || index < 0) return;
    emit(state.copyWith(currentIndex: index));
  }
}
