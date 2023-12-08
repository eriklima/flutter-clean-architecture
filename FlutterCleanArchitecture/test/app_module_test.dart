import 'package:dartz/dartz.dart' as dz;
import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture/app_module.dart';
import 'package:flutter_clean_architecture/modules/search/domain/entities/result_search.dart';
import 'package:flutter_clean_architecture/modules/search/domain/usecases/search_by_text.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:modular_test/modular_test.dart';

import 'modules/search/external/datasources/github_datasource_test.mocks.dart';


@GenerateMocks([Dio])
main() {
  final dio = MockDio();

  setUp(() {
    initModule(AppModule(), replaceBinds: [
      Bind.instance<Dio>(dio),
      // Bind<Dio>((i) => dio),
    ]);
  });

  test("Deve recuperar o usecase sem erros", () {
    final usecase = Modular.get<SearchByText>();
    expect(usecase, isA<SearchByTextImpl>());
  });

  /*
    Este teste deve ser evitado, pois está usando a implementação real do Dio,
    e portanto está acessando a Internet, o que não é uma boa prática para testes.
  */
  // test("Deve trazer uma lista de ResultSearch", () async {
  //   final usecase = Modular.get<SearchByText>();
  //
  //   final result = await usecase.call("erik");
  //
  //   expect(result.fold(dz.id, dz.id) , isA<List<ResultSearch>>());
  // });

  test("Deve trazer uma lista de ResultSearch", () async {
    when(dio.get(any))
        .thenAnswer((_) async => Response(
        data: {"items": [{"title": "Nome", "content": "Erik", "img": "avatar"}]},
        statusCode:  200,
        requestOptions: RequestOptions(path: '')
    ));

    final usecase = Modular.get<SearchByText>();
    final result = await usecase.call("erik");

    expect(result.fold(dz.id, dz.id) , isA<List<ResultSearch>>());
  });

}