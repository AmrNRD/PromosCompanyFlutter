import 'dart:async';

import 'package:PromoMeCompany/data/models/cycle.dart';
import 'package:PromoMeCompany/data/models/user_model.dart';
import 'package:PromoMeCompany/data/repositories/cycle_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'cycle_event.dart';
part 'cycle_state.dart';

class CycleBloc extends Bloc<CycleEvent, CycleState> {
  CycleBloc(this.cycleRepository) : super(CycleInitial());
  final CycleRepository cycleRepository;


  @override
  Stream<CycleState> mapEventToState(CycleEvent event) async* {
    try {
      yield CycleLoading();
      if (event is GetAllCyclesEvent) {
        List<Cycle>posts=await cycleRepository.getAllCycles();
        yield CyclesLoaded(posts);
      }
      else if (event is SendCycleHadBeenWatched) {
        User user=await cycleRepository.setCycleAsWatched(event.cycle);
        yield CycleWatchedSuccessfully(user);
      }
    } catch (error) {
      yield CycleError(error.toString());
    }
  }
}
