import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:night_fall_restaurant_admin/feature/editing_product/bloc/editing_product_bloc.dart';
import 'package:night_fall_restaurant_admin/feature/products/products_screen.dart';
import 'package:night_fall_restaurant_admin/utils/helpers.dart';
import 'package:night_fall_restaurant_admin/utils/ui_components/cached_image_view.dart';
import 'package:night_fall_restaurant_admin/utils/ui_components/cupertino_picker.dart';
import 'package:night_fall_restaurant_admin/utils/ui_components/error_widget.dart';
import 'package:night_fall_restaurant_admin/utils/ui_components/lottie_when_success.dart';
import 'package:night_fall_restaurant_admin/utils/ui_components/material_text_field.dart';
import 'package:night_fall_restaurant_admin/utils/ui_components/show_snack_bar.dart';
import 'package:night_fall_restaurant_admin/utils/ui_components/standart_text.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';

class EditingProductScreen extends StatefulWidget {
  static const String editingProductRoute = "/editingProduct";
  final String? productIdArgument;

  const EditingProductScreen({this.productIdArgument, super.key});

  static void open({required BuildContext context, String? argument}) {
    Navigator.of(context).pushNamed(editingProductRoute, arguments: argument);
  }

  @override
  State<StatefulWidget> createState() => _EditingProductState();
}

class _EditingProductState extends State<EditingProductScreen>
    with TickerProviderStateMixin {
  File? _selectedImage;
  late int _selectedCategory;
  late AnimationController _animationController;
  late TextEditingController _nameEditText;
  late TextEditingController _priceEditText;
  late TextEditingController _weightEditText;
  final FocusNode _textFieldFocusNode = FocusNode();
  static const double kItemExtent = 32;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    context
        .read<EditingProductBloc>()
        .add(EditingProductsOnLoadByArgumentEvent(widget.productIdArgument));
  }

  @override
  void dispose() {
    _textFieldFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _selectedCategory = context.watch<EditingProductBloc>().selectedCategory;
    print("on build(): $_selectedCategory");
    _nameEditText = context.watch<EditingProductBloc>().nameEditingController;
    _priceEditText = context.watch<EditingProductBloc>().priceEditingController;
    _weightEditText = context.watch<EditingProductBloc>().weightEditController;

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          leading: IconButton(
            onPressed: () {
              context
                  .read<EditingProductBloc>()
                  .add(EditingProductOnNavigateBackEvent());
            },
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        body: BlocConsumer<EditingProductBloc, EditingProductState>(
          buildWhen: (previous, current) =>
              current is! EditingProductActionState,
          listenWhen: (previous, current) =>
              current is EditingProductActionState,
          builder: (context, state) {
            if (state is EditingProductSuccessState) {
              return SafeArea(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(16.0),
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: RangeMaintainingScrollPhysics(),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            context
                                .read<EditingProductBloc>()
                                .add(EditingProductOnShowImagePickerEvent());
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              fillMaxWidth(context),
                            ),
                            child: _selectedImage != null
                                ? Image.file(
                                    _selectedImage!,
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.fill,
                                  )
                                : CachedImageView(
                                    imageUrl: state.imageUrl,
                                    width: 150,
                                    height: 150,
                                    controller: _animationController,
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 100),
                      buildTextField(
                        hintText: "Product name",
                        context: context,
                        textFieldFocusNode: _textFieldFocusNode,
                        controller: _nameEditText,
                      ),
                      const SizedBox(height: 24),
                      _selectCategoryButton(
                        categoryNames: state.categoriesNames,
                        categoryIds: state.categoriesIds,
                        imageUrl: state.imageUrl,
                        selectedItemIndex: state.selectedCategoryItem,
                        fireId: state.fireId,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          buildTextField(
                            hintText: "Select price",
                            width: fillMaxWidth(context) * 0.53,
                            inputFormatter: [
                              NumberTextInputFormatter(
                                groupDigits: 3,
                                groupSeparator: " ",
                              )
                            ],
                            context: context,
                            textFieldAlign: TextAlign.center,
                            textFieldFocusNode: _textFieldFocusNode,
                            controller: _priceEditText,
                          ),
                          Expanded(
                            child: TextView(
                              text: "so`m",
                              textSize: 17,
                              textColor:
                                  Theme.of(context).colorScheme.onBackground,
                              maxLines: 1,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          buildTextField(
                            hintText: "Select weight",
                            width: fillMaxWidth(context) * 0.53,
                            inputFormatter: [
                              NumberTextInputFormatter(
                                groupDigits: 3,
                                groupSeparator: " ",
                              )
                            ],
                            context: context,
                            textFieldAlign: TextAlign.center,
                            textFieldFocusNode: _textFieldFocusNode,
                            controller: _weightEditText,
                          ),
                          Expanded(
                            child: TextView(
                              text: "gram",
                              textSize: 17,
                              textColor:
                                  Theme.of(context).colorScheme.onBackground,
                              maxLines: 1,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: fillMaxHeight(context) * 0.17),
                      _updateProductButton(
                        selectedCategoryId:
                            state.categoriesIds.elementAt(_selectedCategory),
                        imageUrl: state.imageUrl,
                        fireId: state.fireId,
                      )
                    ],
                  ),
                ),
              );
            } else if (state is EditingProductErrorState) {
              return errorWidget(state.error, context);
            } else if (state is EditingProductLoadingState) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (state is EditingProductUpdatedSuccessfully) {
              return showWhenAddedSuccessLottie(
                state.lottiePath,
                state.statusText,
                context,
              );
            }
            return Container();
          },
          listener: (context, state) async {
            if (state is ShowSnackMessageState) {
              showSnackBar(state.message, context);
            }
            if (state is EditingProductNavigateBackActionState) {
              ProductsScreen.close(context);
            }
            if (state is ShowImagePickerState) {
              await _selectImageFromGallery();
            }
            if (state is ShowCategoryPickerActionState) {
              _showCategoryPicker(
                categoryNames: state.categoryNames,
                categoryIds: state.categoryIds,
                imageUrl: state.imageUrl,
                fireId: state.fireId,
              );
            }
          },
        ),
      ),
      onWillPop: () async {
        context
            .read<EditingProductBloc>()
            .add(EditingProductOnNavigateBackEvent());
        return false;
      },
    );
  }

  Widget _selectCategoryButton({
    required List<String> categoryNames,
    required List<String> categoryIds,
    required String imageUrl,
    required String fireId,
    required int selectedItemIndex,
  }) =>
      OutlinedButton(
        onPressed: () {
          context
              .read<EditingProductBloc>()
              .add(EditingProductsOnShowCategoryPickerEvent(
                fireId: fireId,
                categoryNames: categoryNames,
                categoryIds: categoryIds,
                imageUrl: imageUrl,
              ));
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Theme.of(context).colorScheme.secondaryContainer,
            width: 4.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          minimumSize: Size(
            fillMaxWidth(context) * 0.78,
            fillMaxHeight(context) * 0.07,
          ),
        ),
        child: TextView(
          text: categoryNames[selectedItemIndex],
          textSize: 17.0,
          textColor: Theme.of(context).colorScheme.onBackground,
        ),
      );

  Widget _updateProductButton({
    required String selectedCategoryId,
    required String imageUrl,
    required String fireId,
  }) =>
      Center(
        child: MaterialButton(
          onPressed: (_nameEditText.text.isNotEmpty &&
                  _priceEditText.text.isNotEmpty &&
                  _weightEditText.text.isNotEmpty)
              ? () {
                  context
                      .read<EditingProductBloc>()
                      .add(EditingProductsOnDoneEvent(
                        imageUrl: imageUrl,
                        imageFile: _selectedImage,
                        fireId: fireId,
                        productCategoryId: selectedCategoryId,
                      ));
                }
              : null,
          color: Theme.of(context).colorScheme.secondaryContainer,
          minWidth: fillMaxWidth(context) * 0.77,
          height: fillMaxHeight(context) * 0.05,
          elevation: 4.0,
          disabledColor: Theme.of(context).colorScheme.surfaceVariant,
          disabledTextColor: Theme.of(context).colorScheme.onSurfaceVariant,
          disabledElevation: 2.0,
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                width: 2.0),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: TextView(
            text: "Update product",
            textColor: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
      );

  Future<void> _selectImageFromGallery() async {
    final XFile? returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _selectedImage = File(returnedImage!.path);
    });
  }

  void _showCategoryPicker({
    required List<String> categoryNames,
    required List<String> categoryIds,
    required String imageUrl,
    required String fireId,
  }) {
    showPopUp(
      context,
      CupertinoPicker(
        magnification: 1.5,
        squeeze: 1.2,
        useMagnifier: true,
        itemExtent: kItemExtent,
        scrollController: FixedExtentScrollController(
          initialItem: _selectedCategory,
        ),
        onSelectedItemChanged: (selectedItem) {
          context
              .read<EditingProductBloc>()
              .add(EditingProductOnSelectCategoryEvent(
                fireId: fireId,
                selectedItem: selectedItem,
                categoriesNames: categoryNames,
                categoriesIds: categoryIds,
                imageUrl: imageUrl,
              ));
        },
        children: List<Widget>.generate(
          categoryNames.length,
          (index) => Center(child: Text(categoryNames[index])),
        ),
      ),
    );
  }
}
