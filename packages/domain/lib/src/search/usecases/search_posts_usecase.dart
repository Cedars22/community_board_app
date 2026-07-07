import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../../../post.dart';
import '../repositories/repositories.dart';

class SearchPostsUsecase implements UseCase<List<PostDisplay>, String> {
  SearchPostsUsecase({required SearchRepository searchRepository})
    : _searchRepository = searchRepository;

  final SearchRepository _searchRepository;

  @override
  Future<Either<Failure, List<PostDisplay>>> call(String params) async {
    return await _searchRepository.searchPosts(query: params);
  }
}
