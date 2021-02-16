part of 'store_bloc.dart';

@immutable
abstract class StoreEvent {}

class GetAllSaleItemsEvent extends StoreEvent {}

class DisableSaleItemsEvent extends StoreEvent {
  final SaleItem saleItem;
  DisableSaleItemsEvent(this.saleItem);
}
class EnableSaleItemsEvent extends StoreEvent {
  final SaleItem saleItem;
  EnableSaleItemsEvent(this.saleItem);
}

class GetUserSaleItemsEvent extends StoreEvent {
  final User user;
  GetUserSaleItemsEvent(this.user);
}

class StoreItem extends StoreEvent {
  final SaleItem saleItem;
  final List<File> files;
  StoreItem(this.saleItem,this.files);
}
