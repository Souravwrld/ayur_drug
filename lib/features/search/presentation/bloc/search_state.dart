part of 'search_bloc.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

final class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<Drug> drugs;
  final String query;

  const SearchSuccess(this.drugs, this.query);

  @override
  List<Object> get props => [drugs, query];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object> get props => [message];
}

class CategoryDrugsLoading extends SearchState {}

class CategoryDrugsSuccess extends SearchState {
  final List<Drug> drugs;
  final String category;

  const CategoryDrugsSuccess(this.drugs, this.category);

  @override
  List<Object> get props => [drugs, category];
}

class CategoryDrugsError extends SearchState {
  final String message;
  final String category;

  const CategoryDrugsError(this.message, this.category);

  @override
  List<Object> get props => [message, category];
}
