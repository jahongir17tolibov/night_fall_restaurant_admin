import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:night_fall_restaurant_admin/data/remote/model/editing_menu_product_model.dart';
import 'package:night_fall_restaurant_admin/domain/use_cases/add_new_product_to_fire_store_use_case.dart';
import 'package:night_fall_restaurant_admin/domain/use_cases/get_menu_categories_use_case.dart';
import 'package:night_fall_restaurant_admin/domain/use_cases/upload_and_get_image_to_fire_store_use_case.dart';

part 'add_new_product_event.dart';

part 'add_new_product_state.dart';

class AddNewProductBloc extends Bloc<AddNewProductEvent, AddNewProductState> {
  final GetMenuCategoriesUseCase getMenuCategoriesUseCase;
  final UploadAndGetImageToFireStoreUseCase uploadAndGetImageToFireStoreUseCase;
  final AddNewProductToFireStoreUseCase addNewProductToFireStoreUseCase;

  AddNewProductBloc({
    required this.getMenuCategoriesUseCase,
    required this.uploadAndGetImageToFireStoreUseCase,
    required this.addNewProductToFireStoreUseCase,
  }) : super(AddNewProductLoadingState()) {
    on<AddNewProductOnShowImagePickerEvent>(_showImagePickerEvent);

    on<AddNewProductOnNavigateBackEvent>(_navigateBackEvent);

    on<AddNewProductOnLoadCategoriesEvent>(_getCategoriesEvent);

    on<AddNewProductOnSendEvent>(_addNewProductEvent);

    on<AddNewProductOnShowCategoryPickerEvent>(_showCategoryPickerEvent);
  }

  static const String _lottiePath = 'assets/anim/success_anim.json';
  static const String _channel = "night_fall_restaurant_admin_channel";
  static const String _invokedMethod = "sync_data_local_and_do_work";
  static const platform = MethodChannel(_channel);

  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _priceEditingController = TextEditingController();
  final TextEditingController _weightEditController = TextEditingController();
  int _selectedCategoryIndex = 0;

  TextEditingController get nameEditingController => _nameEditingController;

  TextEditingController get priceEditingController => _priceEditingController;

  TextEditingController get weightEditingController => _weightEditController;

  int get selectedCategoryIndex => _selectedCategoryIndex;

  Future<void> _addNewProductEvent(
    AddNewProductOnSendEvent event,
    Emitter<AddNewProductState> emit,
  ) async {
    const String addedWhenThereIsInternet = 'Product Added successfully!!!';
    final int makeFireId = DateTime.now().millisecondsSinceEpoch;
    try {
      final hasConnection = await InternetConnectionChecker().hasConnection;
      emit(AddNewProductLoadingState());
      if (hasConnection) {
        final getUrlOfImage = await uploadAndGetImageToFireStoreUseCase.call(
          event.imageFile,
          _nameEditingController.text,
        );

        final EditingMenuProductsModel hasConnectionProductModel =
            _productsModel(
          fireId: makeFireId,
          imageUrlOrPath: getUrlOfImage,
          categoryId: event.categoryId,
        );

        await addNewProductToFireStoreUseCase.call(hasConnectionProductModel);

        emit(AddNewProductSentSuccessState(
          lottiePath: _lottiePath,
          statusText: addedWhenThereIsInternet,
        ));
      } else {
        /// send to native code side
        final EditingMenuProductsModel noConnectionProductModel =
            _productsModel(
          fireId: makeFireId,
          imageUrlOrPath: event.imageFile.path,
          categoryId: event.categoryId,
        );
        await _sendToNative(emit, noConnectionProductModel);
      }
    } catch (e) {
      emit(AddNewProductErrorState(e.toString()));
    }
  }

  Future<void> _getCategoriesEvent(
    AddNewProductOnLoadCategoriesEvent event,
    Emitter<AddNewProductState> emit,
  ) async {
    try {
      final categories = await getMenuCategoriesUseCase.call();

      final List<String> categoryNames =
          categories.map((e) => e.categoryName).toList();
      final List<String> categoryIds =
          categories.map((e) => e.categoryId).toList();

      _pickerSelection(event.categoryIndex);

      emit(AddNewProductSuccessState(
        categoryNames: categoryNames,
        categoryIds: categoryIds,
        selectedCategoryItem: event.categoryIndex,
      ));
    } on Exception catch (e) {
      emit(AddNewProductErrorState(e.toString()));
    }
  }

  Future<void> _showImagePickerEvent(
    AddNewProductOnShowImagePickerEvent event,
    Emitter<AddNewProductState> emit,
  ) async {
    emit(AddNewProductShowImagePickerState());
  }

  Future<void> _showCategoryPickerEvent(
    AddNewProductOnShowCategoryPickerEvent event,
    Emitter<AddNewProductState> emit,
  ) async {
    emit(ShowCategoryPickerActionState(event.categories));
  }

  Future<void> _navigateBackEvent(
    AddNewProductOnNavigateBackEvent event,
    Emitter<AddNewProductState> emit,
  ) async {
    emit(AddNewProductNavigateBackActionState());
    _nameEditingController.clear();
    _priceEditingController.clear();
    _weightEditController.clear();
  }

  /// helper functions

  Future<void> _sendToNative(
    Emitter<AddNewProductState> emit,
    EditingMenuProductsModel data,
  ) async {
    String nativeCodeStatus = "null";
    try {
      nativeCodeStatus = await platform.invokeMethod(
        _invokedMethod,
        data.toMap(),
      );
      emit(AddNewProductSentSuccessState(
        lottiePath: _lottiePath,
        statusText: nativeCodeStatus,
      ));
    } on PlatformException catch (e) {
      nativeCodeStatus = e.toString();
      emit(AddNewProductErrorState(nativeCodeStatus));
      throw Exception(e);
    }
  }

  EditingMenuProductsModel _productsModel({
    required int fireId,
    required String imageUrlOrPath,
    required String categoryId,
  }) =>
      EditingMenuProductsModel(
        fireId: fireId.toString(),
        name: _nameEditingController.text,
        image: imageUrlOrPath,
        price: "${_priceEditingController.text}so`m",
        weight: "${_weightEditController.text}g",
        productCategoryId: categoryId,
      );

  void _pickerSelection(int selectedItem) {
    _selectedCategoryIndex = selectedItem;
  }
}
