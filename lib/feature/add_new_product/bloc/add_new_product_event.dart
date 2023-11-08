part of 'add_new_product_bloc.dart';

@immutable
sealed class AddNewProductEvent {}

class AddNewProductOnLoadCategoriesEvent extends AddNewProductEvent {}

class AddNewProductOnSendEvent extends AddNewProductEvent {
  final File imageFile;
  final String categoryId;

  AddNewProductOnSendEvent(this.imageFile, this.categoryId);
}

class AddNewProductOnShowImagePickerEvent extends AddNewProductEvent {}

class AddNewProductOnNavigateBackEvent extends AddNewProductEvent {}

class AddNewProductOnShowSnackMessageEvent extends AddNewProductEvent {
  final String message;

  AddNewProductOnShowSnackMessageEvent(this.message);
}

class AddNewProductSendDataToNativeEvent extends AddNewProductEvent {
  final EditingMenuProductsModel data;

  AddNewProductSendDataToNativeEvent(this.data);
}
