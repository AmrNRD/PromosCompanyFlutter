import 'dart:async';
import 'dart:io';

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
      }else if (event is DisableSaleItemsEvent) {
        SaleItem saleItem=await storeRepository.disable(event.saleItem);
        yield SaleItemLoaded(saleItem);
      }else if (event is EnableSaleItemsEvent) {
        SaleItem saleItem=await storeRepository.enable(event.saleItem);
        yield SaleItemLoaded(saleItem);
      }else if (event is StoreItem) {
        SaleItem saleItem=await storeRepository.store(event.saleItem,event.files);
        yield SaleItemLoaded(saleItem);
      }
    } catch (error) {
      yield SaleItemError(error.toString());
    }
  }
}
