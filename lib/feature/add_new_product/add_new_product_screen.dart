import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:night_fall_restaurant_admin/feature/add_new_product/bloc/add_new_product_bloc.dart';
import 'package:night_fall_restaurant_admin/feature/products/products_screen.dart';
import 'package:night_fall_restaurant_admin/utils/helpers.dart';
import 'package:night_fall_restaurant_admin/utils/ui_components/cupertino_picker.dart';
import 'package:night_fall_restaurant_admin/utils/ui_components/error_widget.dart';
import 'package:night_fall_restaurant_admin/utils/ui_components/material_text_field.dart';
import 'package:night_fall_restaurant_admin/utils/ui_components/show_snack_bar.dart';
import 'package:night_fall_restaurant_admin/utils/ui_components/standart_text.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';

class AddNewProductScreen extends StatefulWidget {
  static const String addNewProductRoute = "/addNewProduct";

  const AddNewProductScreen({super.key});

  static void open(BuildContext context) {
    Navigator.of(context).pushNamed(addNewProductRoute);
  }

  @override
  State<StatefulWidget> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProductScreen>
    with TickerProviderStateMixin {
  File? _selectedImage;
  int _selectedCategory = 0;
  late String _nameEditText;
  late String _priceEditText;
  late String _weightEditText;
  final FocusNode _textFieldFocusNode = FocusNode();
  static const double kItemExtent = 32;

  @override
  void initState() {
    super.initState();
    context.read<AddNewProductBloc>().add(AddNewProductOnLoadCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    _nameEditText =
        context.watch<AddNewProductBloc>().nameEditingController.text;
    _priceEditText =
        context.watch<AddNewProductBloc>().priceEditingController.text;
    _weightEditText =
        context.watch<AddNewProductBloc>().weightEditingController.text;
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          leading: IconButton(
            onPressed: () {
              context
                  .read<AddNewProductBloc>()
                  .add(AddNewProductOnNavigateBackEvent());
            },
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        body: BlocConsumer<AddNewProductBloc, AddNewProductState>(
          buildWhen: (previous, current) =>
              current is! AddNewProductActionState,
          listenWhen: (previous, current) =>
              current is AddNewProductActionState,
          builder: (context, state) {
            if (state is AddNewProductLoadingState) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (state is AddNewProductSuccessState) {
              final List<String> categoryNames =
                  state.categories.map((e) => e.categoryName).toList();
              final List<String> categoryIds =
                  state.categories.map((e) => e.categoryId).toList();
              return SafeArea(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(16.0),
                  physics: const RangeMaintainingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            context
                                .read<AddNewProductBloc>()
                                .add(AddNewProductOnShowImagePickerEvent());
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
                                : Container(
                                    width: 150,
                                    height: 150,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                    child: Icon(
                                      Icons.image,
                                      size: 80,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                      buildTextField(
                        hintText: "Product name",
                        context: context,
                        textFieldFocusNode: _textFieldFocusNode,
                        controller: context
                            .watch<AddNewProductBloc>()
                            .nameEditingController,
                      ),
                      const SizedBox(height: 24),
                      _selectCategoryButton(categoryNames),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          buildTextField(
                            hintText: "Select price",
                            width: fillMaxWidth(context) * 0.53,
                            textInputType: TextInputType.number,
                            inputFormatter: [
                              NumberTextInputFormatter(
                                groupDigits: 3,
                                groupSeparator: " ",
                              )
                            ],
                            context: context,
                            textFieldAlign: TextAlign.center,
                            textFieldFocusNode: _textFieldFocusNode,
                            controller: context
                                .watch<AddNewProductBloc>()
                                .priceEditingController,
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
                            textInputType: TextInputType.number,
                            inputFormatter: [
                              NumberTextInputFormatter(
                                groupDigits: 3,
                                groupSeparator: " ",
                              )
                            ],
                            context: context,
                            textFieldAlign: TextAlign.center,
                            textFieldFocusNode: _textFieldFocusNode,
                            controller: context
                                .watch<AddNewProductBloc>()
                                .weightEditingController,
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
                      Center(
                        child: MaterialButton(
                          onPressed: (_selectedImage != null &&
                                  _nameEditText.isNotEmpty &&
                                  _priceEditText.isNotEmpty &&
                                  _weightEditText.isNotEmpty)
                              ? () {
                                  context
                                      .read<AddNewProductBloc>()
                                      .add(AddNewProductOnSendEvent(
                                        _selectedImage!,
                                        categoryIds
                                            .elementAt(_selectedCategory),
                                      ));
                                }
                              : null,
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          minWidth: fillMaxWidth(context) * 0.77,
                          height: fillMaxHeight(context) * 0.05,
                          elevation: 4.0,
                          disabledColor:
                              Theme.of(context).colorScheme.surfaceVariant,
                          disabledTextColor:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                          disabledElevation: 2.0,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer,
                                width: 2.0),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: TextView(
                            text: "Add product",
                            textColor: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is AddNewProductErrorState) {
              return errorWidget(state.error, context);
            } else if (state is AddNewProductSentSuccessState) {
              return Center(
                child: SizedBox(
                  width: fillMaxWidth(context),
                  height: fillMaxHeight(context) * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Lottie.asset(
                        state.lottiePath,
                        width: 200,
                        height: 200,
                        fit: BoxFit.fill,
                        repeat: false,
                      ),
                      const SizedBox(height: 80),
                      Expanded(
                        child: Text(
                          state.statusText,
                          style: const TextStyle(
                              color: Colors.green,
                              fontSize: 24.0,
                              fontFamily: 'Ktwod'),
                          maxLines: 3,
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
            return Container();
          },
          listener: (context, state) async {
            if (state is AddNewProductShowSnackMessageState) {
              showSnackBar(state.message, context);
            }
            if (state is AddNewProductNavigateBackActionState) {
              ProductsScreen.close(context);
            }
            if (state is AddNewProductShowImagePickerState) {
              await _selectImageFromGallery();
            }
          },
        ),
      ),
      onWillPop: () async {
        context
            .read<AddNewProductBloc>()
            .add(AddNewProductOnNavigateBackEvent());
        return false;
      },
    );
  }

  Widget _selectCategoryButton(List<String> categories) => OutlinedButton(
        onPressed: () {
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
                setState(() {
                  _selectedCategory = selectedItem;
                });
              },
              children: List<Widget>.generate(
                categories.length,
                (index) => Center(child: Text(categories[index])),
              ),
            ),
          );
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
            )),
        child: TextView(
          text: categories[_selectedCategory],
          textSize: 17.0,
          textColor: Theme.of(context).colorScheme.onBackground,
        ),
      );

  Future<void> _selectImageFromGallery() async {
    final XFile? returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _selectedImage = File(returnedImage!.path);
    });
  }
}
