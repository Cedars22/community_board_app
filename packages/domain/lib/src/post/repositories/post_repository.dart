import 'package:core/errors.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/entities.dart';

abstract interface class PostRepository {
  Future<Either<Failure, List<PostDisplay>>> getPosts({
    required int offset,
    required int limit,
  });
}
