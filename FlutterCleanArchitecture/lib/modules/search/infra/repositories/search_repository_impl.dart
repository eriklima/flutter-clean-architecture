import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/modules/search/domain/entities/result_search.dart';
import 'package:flutter_clean_architecture/modules/search/domain/errors/errors.dart';
import 'package:flutter_clean_architecture/modules/search/domain/repositories/search_respository.dart';
import 'package:flutter_clean_architecture/modules/search/infra/datasources/search_datasource.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchDatasource datasource;

  SearchRepositoryImpl(this.datasource);

  @override
  Future<Either<FailureSearch, List<ResultSearch>>> search(String searchText) async {
    try {
      if (searchText.trim().isEmpty) {
        throw InvalidTextError();
      }
      final result = await datasource.getSearch(searchText);
      return Right(result);
    } on FailureSearch catch (e) {
      return Left(e);
    } catch (e) {
       return Left(DataSourceError());
    }
  }

}