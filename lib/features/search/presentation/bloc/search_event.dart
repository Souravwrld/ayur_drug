part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}

class SearchSubmitted extends SearchEvent {
  final String query;

  const SearchSubmitted(this.query);

  @override
  List<Object> get props => [query];
}

class SearchCleared extends SearchEvent {}

class CategoryDrugsRequested extends SearchEvent {
  final String category;

  const CategoryDrugsRequested(this.category);

  @override
  List<Object> get props => [category];
}
