part of 'editing_product_bloc.dart';

@immutable
sealed class EditingProductEvent {}

class EditingProductsOnLoadByArgumentEvent extends EditingProductEvent {
  final String? productId;

  EditingProductsOnLoadByArgumentEvent(this.productId);
}

class EditingProductOnSelectCategoryEvent extends EditingProductEvent {
  final int selectedItem;
  final List<String> categoriesNames;
  final List<String> categoriesIds;
  final String imageUrl;
  final String fireId;

  EditingProductOnSelectCategoryEvent({
    required this.selectedItem,
    required this.categoriesNames,
    required this.categoriesIds,
    required this.imageUrl,
    required this.fireId,
  });
}

class EditingProductsOnShowCategoryPickerEvent extends EditingProductEvent {
  final List<String> categoryNames;
  final List<String> categoryIds;
  final String imageUrl;
  final String fireId;

  EditingProductsOnShowCategoryPickerEvent({
    required this.categoryNames,
    required this.categoryIds,
    required this.imageUrl,
    required this.fireId,
  });
}

class EditingProductsOnDoneEvent extends EditingProductEvent {
  final File? imageFile;
  final String imageUrl;
  final String fireId;
  final String productCategoryId;

  EditingProductsOnDoneEvent({
    this.imageFile,
    required this.imageUrl,
    required this.fireId,
    required this.productCategoryId,
  });
}

class EditingProductOnShowImagePickerEvent extends EditingProductEvent {}

class EditingProductOnNavigateBackEvent extends EditingProductEvent {}

class EditingProductOnShowSnackMessageEvent extends EditingProductEvent {
  final String message;

  EditingProductOnShowSnackMessageEvent(this.message);
}
