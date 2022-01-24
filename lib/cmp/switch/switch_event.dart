// ignore_for_file: public_member_api_docs

part of 'switch_bloc.dart';

abstract class SwitchEvent extends Equatable {
  const SwitchEvent();

  @override
  List<Object> get props => [];
}

class SwitchTap extends SwitchEvent {
  const SwitchTap({required this.isSwitched});

  final bool isSwitched;

  @override
  List<Object> get props => [isSwitched];
}
