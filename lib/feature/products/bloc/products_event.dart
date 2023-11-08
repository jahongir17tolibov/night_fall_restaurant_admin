part of 'products_bloc.dart';

@immutable
sealed class ProductsEvent {}

class ProductsOnGetMenuProductsEvent extends ProductsEvent {}

class ProductsOnRefreshEvent extends ProductsEvent {}

class ProductsOnNavigateToEditingScreen extends ProductsEvent {
  final int? id;

  ProductsOnNavigateToEditingScreen(this.id);
}

class ProductsOnNavigateToAddNewProductScreenEvent extends ProductsEvent {}

class ProductsOnShowDeleteProductDialogEvent extends ProductsEvent {
  final String productName;

  ProductsOnShowDeleteProductDialogEvent(this.productName);
}

class ProductOnDeleteEvent extends ProductsEvent {
  final String productName;

  ProductOnDeleteEvent(this.productName);
}
