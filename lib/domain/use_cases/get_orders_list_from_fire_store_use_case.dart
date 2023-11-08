import 'package:flutter/cupertino.dart';
import 'package:night_fall_restaurant_admin/data/remote/firebase/fire_base_service.dart';

import '../../data/remote/model/orders/get_orders_list_response.dart';

@immutable
class GetOrdersListFromFireStoreUseCase {
  final FireBaseService fireBaseService;

  const GetOrdersListFromFireStoreUseCase(this.fireBaseService);

  Future<List<GetOrdersListResponse>> call() async =>
      await fireBaseService.getOrdersList();
}
