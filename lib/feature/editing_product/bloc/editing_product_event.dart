part of 'editing_product_bloc.dart';

@immutable
sealed class EditingProductEvent {}

class EditingProductsOnLoadByArgumentEvent extends EditingProductEvent {
  final String? productId;

  EditingProductsOnLoadByArgumentEvent(this.productId);
}

class EditingProductOnShowImagePickerEvent extends EditingProductEvent {}

class EditingProductOnNavigateBackEvent extends EditingProductEvent {}

class EditingProductOnShowSnackMessageEvent extends EditingProductEvent {
  final String message;

  EditingProductOnShowSnackMessageEvent(this.message);
}
