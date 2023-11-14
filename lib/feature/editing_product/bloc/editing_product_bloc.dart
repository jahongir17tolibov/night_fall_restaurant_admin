import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:night_fall_restaurant_admin/data/remote/model/editing_menu_product_model.dart';
import 'package:night_fall_restaurant_admin/domain/use_cases/get_menu_categories_use_case.dart';
import 'package:night_fall_restaurant_admin/domain/use_cases/get_single_product_use_case.dart';
import 'package:night_fall_restaurant_admin/domain/use_cases/update_menu_product_from_firestore_use_case.dart';
import 'package:night_fall_restaurant_admin/domain/use_cases/upload_and_get_image_to_fire_store_use_case.dart';

part 'editing_product_event.dart';

part 'editing_product_state.dart';

class EditingProductBloc
    extends Bloc<EditingProductEvent, EditingProductState> {
  final GetSingleProductUseCase getSingleProductUseCase;
  final GetMenuCategoriesUseCase getMenuCategoriesUseCase;
  final UpdateMenuProductFromFireStoreUseCase updateProduct;
  final UploadAndGetImageToFireStoreUseCase uploadAndGetImage;

  EditingProductBloc({
    required this.getSingleProductUseCase,
    required this.getMenuCategoriesUseCase,
    required this.updateProduct,
    required this.uploadAndGetImage,
  }) : super(EditingProductInitial()) {
    on<EditingProductOnNavigateBackEvent>(_navigateBackEvent);

    on<EditingProductOnShowImagePickerEvent>(_showImagePickerEvent);

    on<EditingProductsOnLoadByArgumentEvent>(_loadProductByArgumentEvent);

    on<EditingProductsOnShowCategoryPickerEvent>(_showCategoryPickerEvent);

    on<EditingProductOnSelectCategoryEvent>(_selectCategoryEvent);

    on<EditingProductsOnDoneEvent>(_doneEvent);
  }

  static const String _lottiePath = 'assets/anim/success_anim.json';
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _priceEditingController = TextEditingController();
  final TextEditingController _weightEditController = TextEditingController();
  int _selectedCategoryIndex = 0;

  int get selectedCategory => _selectedCategoryIndex;

  TextEditingController get nameEditingController => _nameEditingController;

  TextEditingController get priceEditingController => _priceEditingController;

  TextEditingController get weightEditController => _weightEditController;

  Future<void> _loadProductByArgumentEvent(
    EditingProductsOnLoadByArgumentEvent event,
    Emitter<EditingProductState> emit,
  ) async {
    try {
      final productIdArgument = int.parse(event.productId!);
      final product = await getSingleProductUseCase.call(productIdArgument);
      final categories = await getMenuCategoriesUseCase.call();

      _nameEditingController.text = product.name;
      _priceEditingController.text = product.price.replaceAll("so`m", "");
      _weightEditController.text = product.weight.replaceAll("g", "");

      final List<String> categoryNames =
          categories.map((e) => e.categoryName).toList();
      final List<String> categoryIds =
          categories.map((e) => e.categoryId).toList();

      String newProductId = product.productCategoryId;
      _selectedCategoryIndex = categoryIds.indexOf(newProductId);
      print(
        "_loadProductByArgumentEvent: ${categoryIds.indexOf(newProductId)} and $_selectedCategoryIndex",
      );

      emit(EditingProductSuccessState(
        categoriesNames: categoryNames,
        categoriesIds: categoryIds,
        imageUrl: product.image,
        fireId: product.fireId,
        selectedCategoryItem: _selectedCategoryIndex,
      ));
    } on Exception catch (e) {
      emit(EditingProductErrorState(e.toString()));
    }
  }

  Future<void> _selectCategoryEvent(
    EditingProductOnSelectCategoryEvent event,
    Emitter<EditingProductState> emit,
  ) async {
    _pickerSelection(event.selectedItem);

    emit(EditingProductSuccessState(
      categoriesNames: event.categoriesNames,
      categoriesIds: event.categoriesIds,
      imageUrl: event.imageUrl,
      fireId: event.fireId,
      selectedCategoryItem: _selectedCategoryIndex,
    ));
  }

  Future<void> _doneEvent(
    EditingProductsOnDoneEvent event,
    Emitter<EditingProductState> emit,
  ) async {
    const String addedWhenThereIsInternet = 'Product updated successfully!!!';
    try {
      final hasConnection = await InternetConnectionChecker().hasConnection;
      if (hasConnection) {
        await _updateProduct(
          event.fireId,
          event.imageUrl,
          event.imageFile,
          event.productCategoryId,
          emit,
        );
        emit(EditingProductUpdatedSuccessfully(
          _lottiePath,
          addedWhenThereIsInternet,
        ));
      } else {
        emit(ShowSnackMessageState("Check internet connection!!!"));
      }
    } on Exception catch (e) {
      emit(EditingProductErrorState(e.toString()));
    }
  }

  Future<void> _showImagePickerEvent(
    EditingProductOnShowImagePickerEvent event,
    Emitter<EditingProductState> emit,
  ) async {
    emit(ShowImagePickerState());
  }

  Future<void> _showCategoryPickerEvent(
    EditingProductsOnShowCategoryPickerEvent event,
    Emitter<EditingProductState> emit,
  ) async {
    emit(ShowCategoryPickerActionState(
      categoryNames: event.categoryNames,
      categoryIds: event.categoryIds,
      imageUrl: event.imageUrl,
      fireId: event.fireId,
    ));
  }

  Future<void> _navigateBackEvent(
    EditingProductOnNavigateBackEvent event,
    Emitter<EditingProductState> emit,
  ) async {
    emit(EditingProductNavigateBackActionState());
  }

  Future<void> _updateProduct(
    String fireId,
    String imageUrl,
    File? imageFile,
    String categoryId,
    Emitter<EditingProductState> emit,
  ) async {
    emit(EditingProductLoadingState());
    EditingMenuProductsModel updatedProduct = EditingMenuProductsModel(
      fireId: fireId,
      name: _nameEditingController.text,
      image: imageFile != null
          ? await uploadAndGetImage.call(
              imageFile,
              _nameEditingController.text,
            )
          : imageUrl,
      price: _priceEditingController.text,
      weight: _weightEditController.text,
      productCategoryId: categoryId,
    );
    await updateProduct.call(updatedProduct);
  }

  void _pickerSelection(int selectedItem) {
    _selectedCategoryIndex = selectedItem;
  }
}
