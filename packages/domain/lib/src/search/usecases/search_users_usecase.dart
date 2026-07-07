import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../../../auth.dart';
import '../repositories/repositories.dart';

class SearchUsersUsecase implements UseCase<List<UserEntity>, String> {
  SearchUsersUsecase({required SearchRepository searchRepository})
    : _searchRepository = searchRepository;

  final SearchRepository _searchRepository;

  @override
  Future<Either<Failure, List<UserEntity>>> call(String params) async {
    return await _searchRepository.searchUsers(query: params);
  }
}
