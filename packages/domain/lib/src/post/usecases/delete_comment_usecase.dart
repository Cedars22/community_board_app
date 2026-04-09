import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../post.dart';

class DeleteCommentUsecase implements UseCase<void, String> {
  DeleteCommentUsecase({required PostRepository postRepository})
    : _postRepository = postRepository;

  final PostRepository _postRepository;

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await _postRepository.deleteComment(commentId: params);
  }
}
