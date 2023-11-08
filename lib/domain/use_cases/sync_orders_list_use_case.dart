import 'package:flutter/cupertino.dart';
import 'package:night_fall_restaurant_admin/domain/repository/main_repo/repository.dart';

@immutable
class SyncOrdersListUseCase {
  final Repository repository;

  const SyncOrdersListUseCase(this.repository);

  Future<void> call() async => await repository.syncOrdersList();
}
