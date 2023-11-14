import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';
import 'package:night_fall_restaurant_admin/core/result/result_handle.dart';
import 'package:night_fall_restaurant_admin/data/local/entities/menu_products_list_entity.dart';
import 'package:night_fall_restaurant_admin/domain/repository/menu_list_repo/menu_list_repository.dart';
import 'package:night_fall_restaurant_admin/domain/use_cases/delete_menu_product_from_firestore_use_case.dart';

part 'products_event.dart';

part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final MenuListRepository repository;
  final DeleteMenuProductFromFireStoreUseCase deleteProductUseCase;

  ProductsBloc({
    required this.repository,
    required this.deleteProductUseCase,
  }) : super(ProductsLoadingState()) {
    on<ProductsOnGetMenuProductsEvent>(onGetMenuProductsEvent);

    on<ProductsOnRefreshEvent>(onRefreshEvent);

    on<ProductsOnNavigateToEditingScreen>(navigateToEditingScreenEvent);

    on<ProductsOnNavigateToAddNewProductScreenEvent>(
      navigateToAddNewProductScreenEvent,
    );

    on<ProductsOnShowDeleteProductDialogEvent>(showDeleteProductDialogEvent);

    on<ProductOnDeleteEvent>(deleteProductEvent);
  }

  Future<void> onGetMenuProductsEvent(
    ProductsOnGetMenuProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoadingState());
    await _getMenuProducts(event, emit);
  }

  Future<void> onRefreshEvent(
    ProductsOnRefreshEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoadingState());
    await _getMenuProducts(event, emit);
  }

  Future<void> showDeleteProductDialogEvent(
    ProductsOnShowDeleteProductDialogEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsShowDeleteProductDialogActionState(
      "Ushbu mahsulotni delete qilishga ishonchingiz komilmi?",
      event.productName,
    ));
  }

  Future<void> deleteProductEvent(
    ProductOnDeleteEvent event,
    Emitter<ProductsState> emit,
  ) async {
    try {
      final hasConnection = await InternetConnectionChecker().hasConnection;
      if (hasConnection) {
        await deleteProductUseCase.call(event.productName);
        emit(ProductsLoadingState());
        await _getMenuProducts(event, emit);
        emit(ProductsShowSnackMessageActionState(
            "${event.productName} o'chirildi"));
      } else {
        emit(ProductsShowSnackMessageActionState("Check internet connection"));
      }
    } on Exception catch (e) {
      emit(ProductsErrorState(e.toString()));
    }
  }

  Future<void> navigateToEditingScreenEvent(
    ProductsOnNavigateToEditingScreen event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsNavigateToEditingScreenActionState(event.id));
  }

  Future<void> navigateToAddNewProductScreenEvent(
    ProductsOnNavigateToAddNewProductScreenEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsNavigateToAddNewProductScreenActionState());
  }

  Future<void> _getMenuProducts(
    ProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    final syncMenuProducts = await repository.syncMenuProductsList();
    final hasConnection = await InternetConnectionChecker().hasConnection;
    try {
      final fetchedMenuList = await _fetchMenuList(emit);
      if (hasConnection) {
        syncMenuProducts;
        fetchedMenuList;
      } else {
        fetchedMenuList;
      }
    } catch (e) {
      emit(ProductsErrorState(e.toString()));
    }
  }

  Future<void> _fetchMenuList(Emitter<ProductsState> emit) async {
    final menuProducts = await repository.getMenuProductsFromDb();
    final categories = await repository.getMenuCategoriesFromDb();
    switch (menuProducts) {
      case SUCCESS():
        emit(ProductsSuccessState(menuProducts.data));
        break;

      case FAILURE():
        emit(ProductsErrorState(menuProducts.exception.toString()));
        break;
    }
  }
}
