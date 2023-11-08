import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:night_fall_restaurant_admin/domain/use_cases/get_single_product_use_case.dart';

part 'editing_product_event.dart';

part 'editing_product_state.dart';

class EditingProductBloc
    extends Bloc<EditingProductEvent, EditingProductState> {
  final GetSingleProductUseCase getSingleProductUseCase;

  EditingProductBloc({
    required this.getSingleProductUseCase,
  }) : super(EditingProductLoadingState()) {
    on<EditingProductOnNavigateBackEvent>(navigateBackEvent);

    on<EditingProductOnShowImagePickerEvent>(showImagePickerEvent);

    on<EditingProductsOnLoadByArgumentEvent>(loadProductByArgumentEvent);
  }

  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _priceEditingController = TextEditingController();
  final TextEditingController _weightEditController = TextEditingController();

  TextEditingController get nameEditingController => _nameEditingController;
  TextEditingController get priceEditingController => _priceEditingController;
  TextEditingController get weightEditingController => _weightEditController;

  Future<void> loadProductByArgumentEvent(
    EditingProductsOnLoadByArgumentEvent event,
    Emitter<EditingProductState> emit,
  ) async {
    final productIdArgument = int.parse(event.productId!);
    final product = await getSingleProductUseCase.call(productIdArgument);
    _nameEditingController.text = product.name;
    _priceEditingController.text = product.price.replaceAll("so`m", "");
    _weightEditController.text = product.weight.replaceAll("g", "");
  }

  Future<void> showImagePickerEvent(
    EditingProductOnShowImagePickerEvent event,
    Emitter<EditingProductState> emit,
  ) async {
    emit(EditingProductShowImagePickerState());
  }

  Future<void> navigateBackEvent(
    EditingProductOnNavigateBackEvent event,
    Emitter<EditingProductState> emit,
  ) async {
    emit(EditingProductNavigateBackActionState());
  }
}
