import '../models/models.dart';

abstract interface class PostRemoteDataSource {
  Future<List<PostDisplayModel>> getPosts({
    required int offset,
    required int limit,
  });
}
