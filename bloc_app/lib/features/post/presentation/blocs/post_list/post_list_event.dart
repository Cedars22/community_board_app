part of 'post_list_bloc.dart';

sealed class PostListEvent {}

final class PostListFetched extends PostListEvent {}

final class PostLitstNextPageFetched extends PostListEvent {}

final class PostListRefreshed extends PostListEvent {}

final class PostListTransientFailureConsumed extends PostListEvent {}
