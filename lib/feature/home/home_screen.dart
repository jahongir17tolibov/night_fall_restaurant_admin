import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:night_fall_restaurant_admin/feature/home/bloc/home_bloc.dart';
import 'package:night_fall_restaurant_admin/feature/home/widget/order_products_bottom_sheet.dart';
import 'package:night_fall_restaurant_admin/utils/helpers.dart';
import 'package:night_fall_restaurant_admin/utils/ui_components/error_widget.dart';
import 'package:night_fall_restaurant_admin/utils/ui_components/standart_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(HomeOnGetOrdersListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          onPressed: () async {},
          icon: Icon(
            Icons.light_mode_rounded,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          tooltip: 'Light mode',
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_rounded,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<HomeBloc>().add(HomeOnGetOrdersListEvent());
          },
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          strokeWidth: 3.0,
          child: BlocConsumer<HomeBloc, HomeState>(
            buildWhen: (previous, current) => current is! HomeActionState,
            listenWhen: (previous, current) => current is HomeActionState,
            listener: (context, state) async {
              if (state is HomeShowModalBottomSheetActionState) {
                await showModalBottomSheet(
                  context: context,
                  useSafeArea: true,
                  builder: (context) => SafeArea(
                    child: OrderProductsModalBottomSheet(
                      orderProduct: state.orderProducts,
                      orderTotalPrice: state.totalPrice,
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              switch (state) {
                case HomeLoadingState():
                  return Center(
                    child: CupertinoActivityIndicator(
                      color: Theme.of(context).colorScheme.secondary,
                      radius: 25.0,
                    ),
                  );
                case HomeSuccessState():
                  {
                    return ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: state.ordersList.length,
                        itemBuilder: (context, index) {
                          final orderItem = state.ordersList[index];
                          return GestureDetector(
                            onTap: () {
                              context
                                  .read<HomeBloc>()
                                  .add(HomeOnGetOrderProductsEvent(
                                    orderId: orderItem.orderId,
                                    totalPrice: orderItem.totalPrice,
                                  ));
                            },
                            child: _ordersListItem(
                              tableNumber: orderItem.tableNumber,
                              sentDateTime: orderItem.sendTime,
                              uniqueOrderId: orderItem.orderId,
                            ),
                          );
                        });
                  }
                case HomeErrorState():
                  return errorWidget(state.error, context);
                default:
                  return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _ordersListItem({
    required String tableNumber,
    required String uniqueOrderId,
    required String sentDateTime,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      color: Theme.of(context).colorScheme.surface,
      elevation: 6.0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          strokeAlign: BorderSide.strokeAlignCenter,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 7,
            height: fillMaxHeight(context) * 0.10,
            margin: const EdgeInsets.only(
              top: 20.0,
              bottom: 20.0,
              right: 20.0,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: fillMaxWidth(context),
                height: fillMaxHeight(context) * 0.15,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextView(
                      text: 'Table: $tableNumber',
                      textSize: 32.0,
                      maxLines: 1,
                      textColor: Theme.of(context).colorScheme.onSurface,
                    ),
                    const Spacer(),
                    TextView(
                      text: 'Buyurtma: $uniqueOrderId',
                      textSize: 16.0,
                      maxLines: 1,
                      textColor: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    TextView(
                      text: sentDateTime,
                      textSize: 16.0,
                      weight: FontWeight.w700,
                      maxLines: 1,
                      textColor: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 14.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
