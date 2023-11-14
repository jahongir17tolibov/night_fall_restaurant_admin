part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

class HomeLoadingState extends HomeState {
  HomeLoadingState() : super();
}

class HomeSuccessState extends HomeState {
  final List<OrdersListEntity> ordersList;

  HomeSuccessState(this.ordersList) : super();
}

class HomeErrorState extends HomeState {
  final String error;

  HomeErrorState(this.error) : super();
}

@immutable
sealed class HomeActionState extends HomeState {}

class ThemeChangeState extends HomeActionState {
  final bool isDark;

  ThemeChangeState(this.isDark);
}

class HomeShowModalBottomSheetActionState extends HomeActionState {
  final List<OrderProductsEntity> orderProducts;
  final String totalPrice;

  HomeShowModalBottomSheetActionState({
    required this.orderProducts,
    required this.totalPrice,
  });
}

class HomeOrdersShowSnackMessageActionState extends HomeActionState {
  final String message;

  HomeOrdersShowSnackMessageActionState(this.message) : super();
}
