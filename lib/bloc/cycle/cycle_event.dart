part of 'cycle_bloc.dart';

@immutable
abstract class CycleEvent {}

class GetAllCyclesEvent extends CycleEvent {}

class SendCycleHadBeenWatched extends CycleEvent {
  final Cycle cycle;
  SendCycleHadBeenWatched(this.cycle);
}