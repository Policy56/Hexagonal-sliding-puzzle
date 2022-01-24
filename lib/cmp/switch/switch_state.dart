// ignore_for_file: public_member_api_docs

part of 'switch_bloc.dart';

class SwitchState extends Equatable {
  const SwitchState({
    this.isTapped = false,
  });

  final bool isTapped;

  @override
  List<Object> get props => [isTapped];

  SwitchState copyWith({
    bool? isTapped,
  }) {
    return SwitchState(
      isTapped: isTapped ?? this.isTapped,
    );
  }
}
