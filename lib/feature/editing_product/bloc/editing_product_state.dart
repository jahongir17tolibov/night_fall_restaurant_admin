part of 'editing_product_bloc.dart';

@immutable
sealed class EditingProductState {}

class EditingProductInitial extends EditingProductState {
  EditingProductInitial() : super();
}

class EditingProductSuccessState extends EditingProductState {
  final List<String> categoriesNames;
  final List<String> categoriesIds;
  final String imageUrl;
  final String fireId;
  final int selectedCategoryItem;

  EditingProductSuccessState({
    required this.categoriesNames,
    required this.categoriesIds,
    required this.imageUrl,
    required this.fireId,
    required this.selectedCategoryItem,
  });
}

class EditingProductLoadingState extends EditingProductState {}

class EditingProductUpdatedSuccessfully extends EditingProductState {
  final String lottiePath;
  final String statusText;

  EditingProductUpdatedSuccessfully(this.lottiePath, this.statusText);
}

class EditingProductErrorState extends EditingProductState {
  final String error;

  EditingProductErrorState(this.error);
}

@immutable
sealed class EditingProductActionState extends EditingProductState {}

class EditingProductNavigateBackActionState extends EditingProductActionState {}

class ShowCategoryPickerActionState extends EditingProductActionState {
  final List<String> categoryNames;
  final List<String> categoryIds;
  final String imageUrl;
  final String fireId;

  ShowCategoryPickerActionState({
    required this.categoryNames,
    required this.categoryIds,
    required this.imageUrl,
    required this.fireId,
  });
}

class ShowImagePickerState extends EditingProductActionState {}

class ShowSnackMessageState extends EditingProductActionState {
  final String message;

  ShowSnackMessageState(this.message);
}
