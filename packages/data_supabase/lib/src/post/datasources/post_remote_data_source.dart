import 'dart:io';

import 'package:domain/post.dart';

import '../models/models.dart';

abstract interface class PostRemoteDataSource {
  Future<List<PostDisplayModel>> getPosts({
    required int offset,
    required int limit,
  });

  Future<PostDisplayModel> createPost({
    String? postId,
    required String title,
    required String content,
    String? imageUrl,
  });

  Future<ImageUploadResult> uploadPostImage({
    required File image,
    String? postId,
  });

  Future<PostDisplayModel> getPostDetail({required String postId});

  Future<List<CommentDisplayModel>> getComments({
    required String postId,
    required int offset,
    required int limit,
  });

  Future<LikeResultModel> toggleLike({required String postId});
}
