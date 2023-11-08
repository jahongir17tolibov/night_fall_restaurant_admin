import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:night_fall_restaurant_admin/data/local/entities/menu_products_list_entity.dart';
import 'package:night_fall_restaurant_admin/feature/add_new_product/add_new_product_screen.dart';
import 'package:night_fall_restaurant_admin/feature/editing_product/editing_product_screen.dart';
import 'package:night_fall_restaurant_admin/feature/products/bloc/products_bloc.dart';
import 'package:night_fall_restaurant_admin/utils/helpers.dart';
import 'package:night_fall_restaurant_admin/utils/ui_components/cupertino_dialog.dart';
import 'package:night_fall_restaurant_admin/utils/ui_components/error_widget.dart';
import 'package:night_fall_restaurant_admin/utils/ui_components/shimmer_gradient.dart';
import 'package:night_fall_restaurant_admin/utils/ui_components/standart_text.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  static void close(BuildContext context) {
    Navigator.of(context).pop();
    context.read<ProductsBloc>().add(ProductsOnGetMenuProductsEvent());
  }

  @override
  State<StatefulWidget> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    context.read<ProductsBloc>().add(ProductsOnGetMenuProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: RefreshIndicator(
        onRefresh: () async {
          context.read<ProductsBloc>().add(ProductsOnRefreshEvent());
        },
        child: BlocConsumer<ProductsBloc, ProductsState>(
          buildWhen: (previous, current) => current is! ProductsActionState,
          listenWhen: (previous, current) => current is ProductsActionState,
          builder: (BuildContext context, ProductsState state) {
            if (state is ProductsLoadingState) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (state is ProductsSuccessState) {
              return ListView.builder(
                padding: EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  bottom: fillMaxHeight(context) * 0.09,
                  top: 8.0,
                ),
                itemCount: state.products.length,
                physics: Platform.isIOS
                    ? const BouncingScrollPhysics(
                        decelerationRate: ScrollDecelerationRate.fast)
                    : const BouncingScrollPhysics(
                        decelerationRate: ScrollDecelerationRate.fast),
                itemBuilder: (context, index) {
                  final item = state.products[index];
                  return _productsItem(item: item);
                },
              );
            } else if (state is ProductsErrorState) {
              return errorWidget(state.error, context);
            }
            return Container();
          },
          listener: (BuildContext context, ProductsState state) {
            if (state is ProductsNavigateToEditingScreenActionState) {
              EditingProductScreen.open(
                context: context,
                argument: state.productId.toString(),
              );
            }
            if (state is ProductsNavigateToAddNewProductScreenActionState) {
              AddNewProductScreen.open(context);
            }
            if (state is ProductsShowDeleteProductDialogActionState) {
              showCustomDialog(
                context: context,
                message: state.text,
                onDeleteButtonPressed: () {
                  Navigator.of(context).pop();
                  context
                      .read<ProductsBloc>()
                      .add(ProductOnDeleteEvent(state.productName));
                },
              );
            }
          },
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context
              .read<ProductsBloc>()
              .add(ProductsOnNavigateToAddNewProductScreenEvent());
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        tooltip: 'Add new products',
        child: Icon(
          Icons.add_rounded,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
    );
  }

  /// orders list side
  Widget _productsItem({required MenuProductsEntity item}) {
    /// imageView
    Widget productsImage = ClipRRect(
      borderRadius: BorderRadius.circular(14.0),
      child: CachedNetworkImage(
        imageUrl: item.image,
        width: fillMaxWidth(context) * 0.25,
        height: fillMaxHeight(context) * 0.12,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) => Container(
          decoration: BoxDecoration(
            gradient: shimmerEffect(
              context,
              AnimationController(
                vsync: this,
                duration: const Duration(seconds: 2),
              )..repeat(reverse: true),
            ),
          ),
        ),
      ),
    );

    /// trailing
    Widget trailingActionSide = Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            tooltip: "Edit product",
            onPressed: () {
              context
                  .read<ProductsBloc>()
                  .add(ProductsOnNavigateToEditingScreen(item.id!));
            },
            icon: Icon(
              Icons.edit,
              size: 30.0,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          IconButton(
            tooltip: "Delete product",
            onPressed: () {
              context
                  .read<ProductsBloc>()
                  .add(ProductsOnShowDeleteProductDialogEvent(item.name));
            },
            icon: Icon(
              Icons.delete_rounded,
              size: 30.0,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );

    /// list tile
    return Card(
      color: Theme.of(context).colorScheme.surface,
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.primaryContainer,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          productsImage,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextView(
                    text: item.name,
                    textColor: Theme.of(context).colorScheme.onSurface,
                    textSize: 22.0,
                    maxLines: 1,
                    weight: FontWeight.w500,
                  ),
                  TextView(
                    text: item.price,
                    textColor: Theme.of(context).colorScheme.onSurface,
                    textSize: 12.5,
                    maxLines: 1,
                  ),
                  TextView(
                    text: item.weight,
                    textColor: Theme.of(context).colorScheme.onSurface,
                    textSize: 12.5,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
          trailingActionSide,
        ],
      ),
    );
  }
}
