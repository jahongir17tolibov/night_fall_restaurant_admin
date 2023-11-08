part of 'products_bloc.dart';

@immutable
sealed class ProductsState {}

class ProductsLoadingState extends ProductsState {
  ProductsLoadingState() : super();
}

class ProductsSuccessState extends ProductsState {
  final List<MenuProductsEntity> products;

  ProductsSuccessState(this.products) : super();
}

class ProductsErrorState extends ProductsState {
  final String error;

  ProductsErrorState(this.error) : super();
}

@immutable
sealed class ProductsActionState extends ProductsState {}

class ProductsNavigateToEditingScreenActionState extends ProductsActionState {
  final int? productId;

  ProductsNavigateToEditingScreenActionState(this.productId);
}

class ProductsNavigateToAddNewProductScreenActionState
    extends ProductsActionState {}

class ProductsShowDeleteProductDialogActionState extends ProductsActionState {
  final String productName;
  final String text;

  ProductsShowDeleteProductDialogActionState(this.text, this.productName);
}

class ProductsShowSnackMessageActionState extends ProductsActionState {
  final String message;

  ProductsShowSnackMessageActionState(this.message);
}
