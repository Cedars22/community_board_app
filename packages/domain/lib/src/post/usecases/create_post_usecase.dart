import 'package:core/errors.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../post.dart';

class CreatePostParams extends Equatable {
  const CreatePostParams({
    this.postId,
    required this.title,
    required this.content,
    this.imageUrl,
  });

  final String? postId;
  final String title;
  final String content;
  final String? imageUrl;

  @override
  List<Object?> get props => [postId, title, content, imageUrl];
}

class CreatePostUseCase {
  CreatePostUseCase({required PostRepository postRepository})
    : _postRepository = postRepository;

  final PostRepository _postRepository;

  Future<Either<Failure, PostDisplay>> call(CreatePostParams params) async {
    return await _postRepository.createPost(
      postId: params.postId,
      title: params.title,
      content: params.content,
      imageUrl: params.imageUrl,
    );
  }
}
