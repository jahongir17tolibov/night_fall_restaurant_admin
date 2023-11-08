import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:night_fall_restaurant_admin/feature/editing_product/bloc/editing_product_bloc.dart';
import 'package:night_fall_restaurant_admin/feature/products/products_screen.dart';
import 'package:night_fall_restaurant_admin/utils/helpers.dart';
import 'package:night_fall_restaurant_admin/utils/ui_components/cupertino_picker.dart';
import 'package:night_fall_restaurant_admin/utils/ui_components/material_text_field.dart';
import 'package:night_fall_restaurant_admin/utils/ui_components/show_snack_bar.dart';
import 'package:night_fall_restaurant_admin/utils/ui_components/standart_text.dart';

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
  int _selectedCategory = 0;
  late TextEditingController _nameEditText;
  late TextEditingController _priceEditText;
  late TextEditingController _weightEditText;
  final FocusNode _textFieldFocusNode = FocusNode();
  static const double kItemExtent = 32;

  @override
  void initState() {
    super.initState();
    context
        .read<EditingProductBloc>()
        .add(EditingProductsOnLoadByArgumentEvent(widget.productIdArgument));
  }

  @override
  Widget build(BuildContext context) {
    _nameEditText = context.watch<EditingProductBloc>().nameEditingController;
    _priceEditText = context.watch<EditingProductBloc>().priceEditingController;
    _weightEditText =
        context.watch<EditingProductBloc>().weightEditingController;
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
                    const SizedBox(height: 100),
                    buildTextField(
                      hintText: "Product name",
                      context: context,
                      textFieldFocusNode: _textFieldFocusNode,
                      controller: _nameEditText,
                    ),
            // _selectCategoryButton(categories)
                    const SizedBox(height: 24),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        buildTextField(
                          hintText: "Select price",
                          width: fillMaxWidth(context) * 0.53,
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
                  ],
                ),
              ),
            );
          },
          listener: (context, state) async {
            if (state is EditingProductShowSnackMessageState) {
              showSnackBar(state.message, context);
            }
            if (state is EditingProductNavigateBackActionState) {
              ProductsScreen.close(context);
            }
            if (state is EditingProductShowImagePickerState) {
              await _selectImageFromGallery();
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: null,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          tooltip: 'Done',
          child: Icon(
            Icons.done_outline_rounded,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      ),
      onWillPop: () async {
        ProductsScreen.close(context);
        return true;
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
