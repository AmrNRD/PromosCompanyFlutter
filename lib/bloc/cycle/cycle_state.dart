part of 'cycle_bloc.dart';

@immutable
abstract class CycleState {}

class CycleInitial extends CycleState {}

class CycleLoading extends CycleState {}

class CycleLoaded extends CycleState {
  final Cycle cycle;
  CycleLoaded(this.cycle);
}

class CycleWatchedSuccessfully extends CycleState {
  final User user;
  CycleWatchedSuccessfully(this.user);
}

class CyclesLoaded extends CycleState {
  final List<Cycle>cycles;
  CyclesLoaded(this.cycles);
}

class CycleError extends CycleState {
  final String message;

  CycleError(this.message);
}
