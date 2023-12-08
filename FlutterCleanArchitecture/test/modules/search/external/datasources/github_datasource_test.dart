import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture/modules/search/domain/errors/errors.dart';
import 'package:flutter_clean_architecture/modules/search/external/datasources/github_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../utils/github_response.dart';
import 'github_datasource_test.mocks.dart';

@GenerateMocks([Dio])
main() {
  final dio = MockDio();
  final datasource = GithubDatasource(dio);
  
  test("Deve retornar uma lista de ResultSearchModel", () {
    when(dio.get(any))
        .thenAnswer((_) async => Response(
          data: jsonDecode(githubResult),
          // data: {"items": [{"title": "Nome", "content": "Erik", "img": "avatar"}]},
          statusCode:  200,
          requestOptions: RequestOptions(path: '')
        ));

    final future = datasource.getSearch("Erik");

    expect(future, completes);
  });

  test("Deve retornar um erro se o código não for 200", () {
    when(dio.get(any))
        .thenAnswer((_) async => Response(
          data: null,
          statusCode:  401,
          requestOptions: RequestOptions(path: '')
        ));

    final future = datasource.getSearch("Erik");

    expect(future, throwsA(isA<DataSourceError>()));
  });

  test("Deve retornar uma Exception se tiver um erro no dio", () {
    when(dio.get(any)).thenThrow(Exception());

    final future = datasource.getSearch("Erik");

    expect(future, throwsA(isA<Exception>()));
  });

}