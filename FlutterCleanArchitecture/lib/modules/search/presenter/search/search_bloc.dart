import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/modules/search/domain/usecases/search_by_text.dart';
import 'package:flutter_clean_architecture/modules/search/presenter/search/states/state.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc extends Bloc<String, SearchState> {
  final SearchByText usecase;

  SearchBloc(this.usecase) : super(SearchStart()) {
    on<String>(_searchByTextUseCase, transformer: debounce(const Duration(milliseconds: 500)));
  }

  FutureOr<void> _searchByTextUseCase(event, emit) async {
    emit(SearchLoading());
    final result = await usecase.call(event);
    emit(result.fold((l) => SearchError(l), (r) => SearchSuccess(r)));
  }

  EventTransformer<String> debounce<String>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
  }

}