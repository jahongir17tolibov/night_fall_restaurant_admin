import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:night_fall_restaurant_admin/data/local/entities/order_products_entity.dart';
import 'package:night_fall_restaurant_admin/utils/helpers.dart';
import 'package:night_fall_restaurant_admin/utils/ui_components/standart_text.dart';

class OrderProductsModalBottomSheet extends StatelessWidget {
  final List<OrderProductsEntity> orderProduct;
  final String orderTotalPrice;

  const OrderProductsModalBottomSheet({
    super.key,
    required this.orderProduct,
    required this.orderTotalPrice,
  });

  @override
  Widget build(BuildContext context) => DraggableScrollableSheet(
        expand: false,
        maxChildSize: 0.9,
        initialChildSize: 0.6,
        minChildSize: 0.4,
        builder: (context, scrollController) => Flexible(
          child: ListView.builder(
            controller: scrollController,
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(12.0),
            itemCount: orderProduct.length + 1,
            itemBuilder: (context, index) {
              if (index == orderProduct.length) {
                return Column(
                  children: <Widget>[
                    const SizedBox(height: 12.0),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextView(
                          text: "Umumiy narx:",
                          textColor: Theme.of(context).colorScheme.onSurface,
                          maxLines: 1,
                          weight: FontWeight.w500,
                          textSize: 20.0,
                        ),
                        const SizedBox(width: 10.0),
                        TextView(
                          text: orderTotalPrice,
                          textColor: Theme.of(context).colorScheme.onSurface,
                          maxLines: 1,
                          weight: FontWeight.w500,
                          textSize: 20.0,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                  ],
                );
              } else {
                final item = orderProduct[index];
                return _orderProductListViewItem(context, item);
              }
            },
          ),
        ),
      );

  Widget _orderProductListViewItem(
    BuildContext context,
    OrderProductsEntity orderProduct,
  ) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          tileColor: Theme.of(context).colorScheme.surface,
          splashColor: Theme.of(context).colorScheme.primaryContainer,
          leading: _orderProductImageView(context, orderProduct.image),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: TextView(
            text: orderProduct.fromOrderUniqueId,
            textColor: Theme.of(context).colorScheme.onSurface,
            textSize: 22.0,
            maxLines: 1,
            weight: FontWeight.w500,
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextView(
                text: orderProduct.price,
                textColor: Theme.of(context).colorScheme.onSurface,
                textSize: 12.5,
                maxLines: 1,
              ),
              TextView(
                text: orderProduct.weight,
                textColor: Theme.of(context).colorScheme.onSurface,
                textSize: 12.5,
                maxLines: 1,
              ),
            ],
          ),
          trailing: TextView(
            text: "${orderProduct.amount}x",
            textColor: Theme.of(context).colorScheme.onSurface,
            weight: FontWeight.w500,
            textSize: 20.0,
          ),
        ),
      );

  Widget _orderProductImageView(
    BuildContext context,
    String imageUrl,
  ) =>
      ClipRRect(
        borderRadius: BorderRadius.circular(14.0),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: fillMaxWidth(context) * 0.175,
          height: fillMaxHeight(context) * 0.1,
          fit: BoxFit.fill,
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primaryContainer),
          ),
        ),
      );
}
