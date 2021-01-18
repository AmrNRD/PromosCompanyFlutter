part of 'store_bloc.dart';

@immutable
abstract class StoreState {}

class StoreInitial extends StoreState {}

class SaleItemLoading extends StoreState {}

class SaleItemLoaded extends StoreState {
  final SaleItem saleItem;
  SaleItemLoaded(this.saleItem);
}


class SaleItemsLoaded extends StoreState {
  final List<SaleItem>saleItems;
  SaleItemsLoaded(this.saleItems);
}

class SaleItemError extends StoreState {
  final String message;
  SaleItemError(this.message);
}
