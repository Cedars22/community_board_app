part of 'search_bloc.dart';

enum SearchStatus { initial, loadingUsers, loadingPost, failure }

class SearchState extends Equatable {
  const SearchState({
    required this.status,
    required this.users,
    required this.posts,
    required this.query,
    required this.currentTabIndex,
    this.failure,
    this.transientFailure,
  });

  final SearchStatus status;
  final List<UserEntity> users;
  final List<PostDisplay> posts;
  final String query;
  final int currentTabIndex;
  final Failure? failure;
  final Failure? transientFailure;

  @override
  List<Object?> get props => [
    status,
    users,
    posts,
    query,
    currentTabIndex,
    failure,
    transientFailure,
  ];
  SearchState copyWith({
    SearchStatus? status,
    List<UserEntity>? users,
    List<PostDisplay>? posts,
    String? query,
    int? currentTabIndex,
    Failure? Function()? failure,
    Failure? Function()? transientFailure,
  }) {
    return SearchState(
      status: status ?? this.status,
      users: users ?? this.users,
      posts: posts ?? this.posts,
      query: query ?? this.query,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      failure: failure != null ? failure() : this.failure,
      transientFailure: transientFailure != null
          ? transientFailure()
          : this.transientFailure,
    );
  }
}
