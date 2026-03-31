import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../../../post.dart';

class GetPostDetailUsecase implements UseCase<PostDisplay, String> {
  GetPostDetailUsecase({required PostRepository postRepository})
    : _postRepository = postRepository;

  final PostRepository _postRepository;

  @override
  Future<Either<Failure, PostDisplay>> call(String params) async {
    return await _postRepository.getPostDetail(postId: params);
  }
}
