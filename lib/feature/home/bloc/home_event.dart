part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class HomeOnGetOrdersListEvent extends HomeEvent {}

class ThemeChangedEvent extends HomeEvent {
  final bool isDark;

  ThemeChangedEvent(this.isDark);
}

class HomeOnGetOrderProductsEvent extends HomeEvent {
  final String orderId;
  final String totalPrice;

  HomeOnGetOrderProductsEvent({
    required this.orderId,
    required this.totalPrice,
  });
}

class HomeOnClearAllOrdersEvent extends HomeEvent {}
