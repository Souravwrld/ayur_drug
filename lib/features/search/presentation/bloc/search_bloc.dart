import 'package:ayur_drug/features/search/domain/repo/drug_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/models/drug_model.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final DrugRepository _drugRepository;

  SearchBloc({required DrugRepository drugRepository})
      : _drugRepository = drugRepository,
        super(SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SearchSubmitted>(_onSearchSubmitted);
    on<SearchCleared>(_onSearchCleared);
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    // if (event.query.length < 2) {
    //   return; // Don't search for queries less than 2 characters
    // }

    emit(SearchLoading());

    try {
      final drugs = await _drugRepository.searchDrugs(event.query);
      emit(SearchSuccess(drugs, event.query));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onSearchSubmitted(
    SearchSubmitted event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    try {
      final drugs = await _drugRepository.searchDrugs(event.query);
      emit(SearchSuccess(drugs, event.query));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  void _onSearchCleared(
    SearchCleared event,
    Emitter<SearchState> emit,
  ) {
    emit(SearchInitial());
  }
}
