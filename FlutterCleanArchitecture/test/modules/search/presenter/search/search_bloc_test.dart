import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/modules/search/domain/entities/result_search.dart';
import 'package:flutter_clean_architecture/modules/search/domain/errors/errors.dart';
import 'package:flutter_clean_architecture/modules/search/domain/usecases/search_by_text.dart';
import 'package:flutter_clean_architecture/modules/search/presenter/search/search_bloc.dart';
import 'package:flutter_clean_architecture/modules/search/presenter/search/states/state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_bloc_test.mocks.dart';

@GenerateMocks([SearchByText])
main() {

  final usecase = MockSearchByText();
  final bloc = SearchBloc(usecase);

  test('Deve retornar os estados na ordem correta com sucesso', () {
    when(usecase.call(any))
        .thenAnswer((_) async => const Right(<ResultSearch>[]));

    expect(
        bloc.stream,
        emitsInOrder([
          isA<SearchLoading>(),
          isA<SearchSuccess>()
        ]));

    bloc.add("Erik");
  });

  test('Deve retornar os estados na ordem correta com erro', () {
    when(usecase.call(any))
        .thenAnswer((_) async => Left(InvalidTextError()));

    expect(
        bloc.stream,
        emitsInOrder([
          isA<SearchLoading>(),
          isA<SearchError>()
        ]));

    bloc.add("");
  });

}