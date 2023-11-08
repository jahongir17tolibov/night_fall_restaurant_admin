part of 'editing_product_bloc.dart';

@immutable
sealed class EditingProductState {}

class EditingProductLoadingState extends EditingProductState {}

class EditingProductSuccessState extends EditingProductState {}

class EditingProductErrorState extends EditingProductState {}

@immutable
sealed class EditingProductActionState extends EditingProductState {}

class EditingProductNavigateBackActionState extends EditingProductActionState {}

class EditingProductShowImagePickerState extends EditingProductActionState {}

class EditingProductShowSnackMessageState extends EditingProductActionState {
  final String message;

  EditingProductShowSnackMessageState(this.message);
}
