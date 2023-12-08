import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/modules/search/domain/entities/result_search.dart';
import 'package:flutter_clean_architecture/modules/search/domain/errors/errors.dart';
import 'package:flutter_clean_architecture/modules/search/infra/datasources/search_datasource.dart';
import 'package:flutter_clean_architecture/modules/search/infra/models/result_search_model.dart';
import 'package:flutter_clean_architecture/modules/search/infra/repositories/search_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_repository_impl_test.mocks.dart';

@GenerateMocks([SearchDatasource])
main() {
  final datasource = MockSearchDatasource();
  final repository = SearchRepositoryImpl(datasource);

  test('Deve retornar uma lista de ResultSearch', () async {
    when(datasource.getSearch(any))
        .thenAnswer((_) async => <ResultSearchModel>[]);

    final result = await repository.search("Erik");

    expect(result, isA<Right>());
    expect(result | <ResultSearch>[], isA<List<ResultSearch>>());
  });

  test('Deve retornar um DatasourceError se o Datasource falhar', () async {
    when(datasource.getSearch(any))
        .thenThrow(Exception());

    final result = await repository.search("Erik");

    expect(result, isA<Left>());
    expect(result.fold(id, id), isA<DataSourceError>());
  });

  test('Deve retornar um InvalidTextError texto for vazio', () async {
    when(datasource.getSearch(any))
        .thenAnswer((_) async => <ResultSearchModel>[]);

    final result = await repository.search("");

    expect(result, isA<Left>());
    expect(result.fold(id, id), isA<InvalidTextError>());
  });

  test('Deve retornar um InvalidTextError texto for espaços', () async {
    when(datasource.getSearch(any))
        .thenAnswer((_) async => <ResultSearchModel>[]);

    final result = await repository.search(" ");

    expect(result, isA<Left>());
    expect(result.fold(id, id), isA<InvalidTextError>());
  });
}