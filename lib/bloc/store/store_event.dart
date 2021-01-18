part of 'store_bloc.dart';

@immutable
abstract class StoreEvent {}

class GetAllSaleItemsEvent extends StoreEvent {}


class GetUserSaleItemsEvent extends StoreEvent {
  final User user;
  GetUserSaleItemsEvent(this.user);
}