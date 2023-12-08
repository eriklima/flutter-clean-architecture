import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_clean_architecture/modules/search/domain/entities/result_search.dart';
import 'package:flutter_clean_architecture/modules/search/domain/errors/errors.dart';
import 'package:flutter_clean_architecture/modules/search/domain/repositories/search_respository.dart';
import 'package:flutter_clean_architecture/modules/search/domain/usecases/search_by_text.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_by_text_test.mocks.dart';

@GenerateMocks([SearchRepository])
main() {
  final repository = MockSearchRepository();
  final usecase = SearchByTextImpl(repository);

  test('Deve retornar uma lista de resultados', () async {
    when(repository.search(any))
        .thenAnswer((_) async => const Right(<ResultSearch>[]));

    final result = await usecase.call("Erik");

    expect(result, isA<Right>());
    // expect(result.getOrElse(() => <ResultSearch>[]), isA<List<ResultSearch>>());
    expect(result | <ResultSearch>[], isA<List<ResultSearch>>());
  });

  test('Deve retornar uma InvalidTextError caso o texto seja vazio', () async {
    when(repository.search(any))
        .thenAnswer((_) async => const Right(<ResultSearch>[]));

    final result = await usecase.call("");

    expect(result, isA<Left>());
    // expect(result.fold((l) => l, (r) => r), isA<InvalidTextError>);
    expect(result.fold(id, id), isA<InvalidTextError>());
  });

  test('Deve retornar uma InvalidTextError caso o texto seja espaço', () async {
    when(repository.search(any))
        .thenAnswer((_) async => const Right(<ResultSearch>[]));

    final result = await usecase.call(" ");

    expect(result, isA<Left>());
    // expect(result.fold((l) => l, (r) => r), isA<InvalidTextError>);
    expect(result.fold(id, id), isA<InvalidTextError>());
  });

}