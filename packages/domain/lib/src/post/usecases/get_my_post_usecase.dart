import 'package:core/src/errors/failures.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import '../post.dart';

class GetMyPostParams extends Equatable {
  const GetMyPostParams({
    required this.userId,
    required this.offset,
    required this.limit,
  });

  final String userId;
  final int offset;
  final int limit;

  @override
  List<Object> get props => [userId, offset, limit];
}

class GetMyPostUseCase implements UseCase<List<PostDisplay>, GetMyPostParams> {
  GetMyPostUseCase({required PostRepository postRepository})
    : _postRepository = postRepository;

  final PostRepository _postRepository;

  @override
  Future<Either<Failure, List<PostDisplay>>> call(
    GetMyPostParams params,
  ) async {
    return await _postRepository.getMyPosts(
      userId: params.userId,
      offset: params.offset,
      limit: params.limit,
    );
  }
}
