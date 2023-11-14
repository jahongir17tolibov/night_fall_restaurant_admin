import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';
import 'package:night_fall_restaurant_admin/core/result/result_handle.dart';
import 'package:night_fall_restaurant_admin/data/local/entities/order_products_entity.dart';
import 'package:night_fall_restaurant_admin/data/local/entities/orders_list_entity.dart';
import 'package:night_fall_restaurant_admin/data/shared/shared_preferences.dart';
import 'package:night_fall_restaurant_admin/domain/use_cases/clear_all_orders_use_case.dart';
import 'package:night_fall_restaurant_admin/domain/use_cases/get_order_products_by_order_id_use_case.dart';
import 'package:night_fall_restaurant_admin/domain/use_cases/get_orders_list_from_fire_store_use_case.dart';
import 'package:night_fall_restaurant_admin/domain/use_cases/get_orders_list_use_case.dart';
import 'package:night_fall_restaurant_admin/domain/use_cases/sync_orders_list_use_case.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SyncOrdersListUseCase syncOrdersListUseCase;
  final GetOrdersListUseCase getOrdersListUseCase;
  final GetProductsByOrderIdUseCase getProductsByOrderIdUseCase;
  final ClearAllOrdersUseCase clearAllOrdersUseCase;
  final GetOrdersListFromFireStoreUseCase fireStoreUseCase;

  HomeBloc({
    required this.syncOrdersListUseCase,
    required this.getOrdersListUseCase,
    required this.getProductsByOrderIdUseCase,
    required this.clearAllOrdersUseCase,
    required this.fireStoreUseCase,
  }) : super(HomeLoadingState()) {
    on<HomeOnGetOrdersListEvent>(_getOrdersListEvent);

    on<HomeOnClearAllOrdersEvent>(_clearOrdersEvent);

    on<HomeOnGetOrderProductsEvent>(_getOrderProductsByIdEvent);
  }

  bool _themeModeState = false;

  bool get themeModeState => _themeModeState;

  Future<void> _getOrdersListEvent(
    HomeOnGetOrdersListEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoadingState());
    final syncOrderList = await syncOrdersListUseCase.call();
    final hasConnection = await InternetConnectionChecker().hasConnection;
    try {
      final fetchedOrderList = await _fetchOrdersList(emit);
      if (hasConnection) {
        syncOrderList; /* syncing order */
        fetchedOrderList; /* fetching orders */
      } else {
        fetchedOrderList;
      }
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }

  Future<void> _getOrderProductsByIdEvent(
    HomeOnGetOrderProductsEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final orderProducts =
          await getProductsByOrderIdUseCase.call(event.orderId);
      switch (orderProducts) {
        case SUCCESS():
          emit(HomeShowModalBottomSheetActionState(
            orderProducts: orderProducts.data,
            totalPrice: event.totalPrice,
          ));
        case FAILURE():
          emit(HomeErrorState(orderProducts.exception.toString()));
      }
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }

  Future<void> _clearOrdersEvent(
    HomeOnClearAllOrdersEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoadingState());
    await clearAllOrdersUseCase.call();
    emit(HomeOrdersShowSnackMessageActionState("Hozircha buyurtmalar yo'q"));
  }

  Future<void> _fetchOrdersList(Emitter<HomeState> emit) async {
    final ordersList = await getOrdersListUseCase.call();
    switch (ordersList) {
      case SUCCESS():
        return emit(HomeSuccessState(ordersList.data));
      case FAILURE():
        return emit(HomeErrorState(ordersList.exception.toString()));
    }
  }

  Future<void> _regenrateList(
    // ReloadEvent event,
    Emitter<HomeState> emit,
  ) async {
    List<String> items = [];
    for (int i = 0; i < 100; i++) {
      items.add("Item` $i");
    }

    // emit(HomeSuccessState(items));
  }

  Future<void> _changeAppTheme(
    ThemeChangedEvent event,
    Emitter<HomeState> emit,
  ) async {
    _themeModeState = event.isDark;
    if (event.isDark) {
      ThemeMode.dark;
    } else {
      ThemeMode.light;
    }

    emit(ThemeChangeState(event.isDark));
  }
}
