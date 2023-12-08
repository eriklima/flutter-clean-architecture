import 'package:flutter_clean_architecture/modules/search/domain/entities/result_search.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/modules/search/domain/repositories/search_respository.dart';

import '../errors/errors.dart';

abstract class SearchByText {
  Future<Either<FailureSearch, List<ResultSearch>>> call(String searchText);
}

class SearchByTextImpl implements SearchByText {
  final SearchRepository repository;

  SearchByTextImpl(this.repository);

  @override
  Future<Either<FailureSearch, List<ResultSearch>>> call(String searchText) async {
    if (searchText.trim().isEmpty) {
      return Left(InvalidTextError());
    }

    return repository.search(searchText);
  }

}