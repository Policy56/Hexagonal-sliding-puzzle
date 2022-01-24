// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'switch_event.dart';
part 'switch_state.dart';

class SwitchBloc extends Bloc<SwitchEvent, SwitchState> {
  SwitchBloc({required bool pIsSwitched})
      : _isSwitched = pIsSwitched,
        super(const SwitchState()) {
    on<SwitchTap>(_onSwitchTap);
  }

  bool _isSwitched;

  StreamSubscription<int>? _tickerSubscription;

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onSwitchTap(SwitchTap event, Emitter<SwitchState> emit) {
    _isSwitched = event.isSwitched;
    emit(state.copyWith(isTapped: _isSwitched));
  }
}
