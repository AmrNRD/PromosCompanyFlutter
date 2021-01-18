import 'dart:async';

import 'package:PromoMeCompany/data/models/sale_item.dart';
import 'package:PromoMeCompany/data/models/user_model.dart';
import 'package:PromoMeCompany/data/repositories/store_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'store_event.dart';
part 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc(this.storeRepository) : super(StoreInitial());
  final StoreRepository storeRepository;

  @override
  Stream<StoreState> mapEventToState(StoreEvent event) async* {
    try {
      yield SaleItemLoading();
      if (event is GetAllSaleItemsEvent) {
        List<SaleItem>saleItems=await storeRepository.getAllSaleItems();
        yield SaleItemsLoaded(saleItems);
      }else if (event is GetUserSaleItemsEvent) {
        List<SaleItem>saleItems=await storeRepository.getUserSaleItems(event.user);
        yield SaleItemsLoaded(saleItems);
      }
    } catch (error) {
      yield SaleItemError(error.toString());
    }
  }
}
