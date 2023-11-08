part of 'add_new_product_bloc.dart';

@immutable
sealed class AddNewProductState {}

class AddNewProductLoadingState extends AddNewProductState {
  AddNewProductLoadingState() : super();
}

class AddNewProductSuccessState extends AddNewProductState {
  final List<MenuCategoriesEntity> categories;

  AddNewProductSuccessState(this.categories) : super();
}

class AddNewProductSentSuccessState extends AddNewProductState {
  final String lottiePath;
  final String statusText;

  AddNewProductSentSuccessState({
    required this.lottiePath,
    required this.statusText,
  }) : super();
}

class AddNewProductErrorState extends AddNewProductState {
  final String error;

  AddNewProductErrorState(this.error) : super();
}

@immutable
sealed class AddNewProductActionState extends AddNewProductState {}

class AddNewProductSendDataToNativeActionState
    extends AddNewProductActionState {
  final EditingMenuProductsModel data;

  AddNewProductSendDataToNativeActionState(this.data);
}

class AddNewProductNavigateBackActionState extends AddNewProductActionState {}

class AddNewProductShowImagePickerState extends AddNewProductActionState {}

class AddNewProductShowSnackMessageState extends AddNewProductActionState {
  final String message;

  AddNewProductShowSnackMessageState(this.message);
}
