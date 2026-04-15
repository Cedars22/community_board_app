import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../post.dart';

class DeletePostFolderUseCase implements UseCase<void, String> {
  DeletePostFolderUseCase({required PostRepository postRepository})
    : _postRepository = postRepository;

  final PostRepository _postRepository;

  @override
  Future<Either<Failure, void>> call(String params) {
    return _postRepository.deletePostFolder(postId: params);
  }
}
