import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../post.dart';

class DeletePostUseCase implements UseCase<void, String> {
  DeletePostUseCase({required PostRepository postRepository})
    : _postRepository = postRepository;

  final PostRepository _postRepository;

  @override
  Future<Either<Failure, void>> call(String params) {
    return _postRepository.deletePost(postId: params);
  }
}
