// presentation/bloc/first_aid_event.dart
part of 'first_aid_bloc.dart';

sealed class FirstAidEvent extends Equatable {
  const FirstAidEvent();
  @override
  List<Object> get props => [];
}

class LoadFirstAidGuides extends FirstAidEvent {
  final BuildContext context;

  const LoadFirstAidGuides(this.context);

  @override
  List<Object> get props => [context];
}

class SearchFirstAid extends FirstAidEvent {
  final String query;

  SearchFirstAid(this.query);

  @override
  List<Object> get props => [query];
}

class FilterFirstAid extends FirstAidEvent {
  final String category;

  FilterFirstAid(this.category);

  @override
  List<Object> get props => [category];
}
