// presentation/bloc/first_aid_state.dart
part of 'first_aid_bloc.dart';

sealed class FirstAidState extends Equatable {
  final List<FirstAidEntity> allGuides;
  final List<FirstAidEntity> displayedGuides;

  const FirstAidState({
    this.allGuides = const [],
    this.displayedGuides = const [],
  });

  @override
  List<Object> get props => [allGuides, displayedGuides];
}

class FirstAidInitial extends FirstAidState {}

class FirstAidLoading extends FirstAidState {
  const FirstAidLoading({super.allGuides, super.displayedGuides});
}

class FirstAidLoaded extends FirstAidState {
  final List<FirstAidEntity> allGuides;
  final List<FirstAidEntity> displayedGuides;
  FirstAidLoaded({required this.allGuides, required this.displayedGuides});

  FirstAidLoaded copyWith({
    List<FirstAidEntity>? allGuides,
    List<FirstAidEntity>? displayedGuides,
  }) {
    return FirstAidLoaded(
      allGuides: allGuides ?? this.allGuides,
      displayedGuides: displayedGuides ?? this.displayedGuides,
    );
  }
}

class FirstAidError extends FirstAidState {
  final String message;

  const FirstAidError(this.message);
}
