import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:domain/post.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/bus/global_event.dart';
import '../../../../../core/bus/global_event_bus.dart';
import '../post_list/post_list_bloc.dart';

part 'my_post_list_event.dart';
part 'my_post_list_state.dart';

const _pageSize = 5;

class MyPostListBloc extends Bloc<MyPostListEvent, MyPostListState> {
  MyPostListBloc({
    required GetMyPostUseCase getMyPostuseCase,
    required ToggleLikeUseCase toggleLikeUseCase,
    required GlobalEventBus globalEventBus,
  }) : _getMyPostUseCase = getMyPostuseCase,
       _toggleLikeUseCase = toggleLikeUseCase,
       _globalEventBus = globalEventBus,
       super(const MyPostListState()) {
    on<MyPostListFetched>(_onMyPostListFetched);
    on<MyPostListNextPageFetched>(_onMyPostListNextFetched);
    on<MyPostListRefreshed>(_onMyPostListRefreshed);
    on<MyPostListTransientFailureConsumed>(
      _onMyPostListTransientFailureConsumed,
    );

    _globalEventBusSuscription = _globalEventBus.stream.listen((event) {
      add(_GlobalEventReceived(event: event));
    });
  }

  final GetMyPostUseCase _getMyPostUseCase;
  final ToggleLikeUseCase _toggleLikeUseCase;

  final GlobalEventBus _globalEventBus;

  StreamSubscription<GlobalEvent>? _globalEventBusSuscription;

  String? _userId;

  bool get _isBusy =>
      state.status == MyPostListStatus.loading ||
      state.status == MyPostListStatus.fetchingNextPage ||
      state.status == MyPostListStatus.refreshing ||
      state.status == MyPostListStatus.refilling;

  Future<void> _onMyPostListFetched(
    MyPostListFetched event,
    Emitter<MyPostListState> emit,
  ) async {
    if (_isBusy) return;
    _userId = event.userId;

    emit(state.copyWith(status: MyPostListStatus.loading));

    final result = await _getMyPostUseCase(
      GetMyPostParams(userId: event.userId, offset: 0, limit: _pageSize),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: MyPostListStatus.failure,
            failure: () => failure,
          ),
        );
      },
      (posts) {
        emit(
          state.copyWith(
            status: MyPostListStatus.loaded,
            posts: posts,
            hasReachedMax: posts.length < _pageSize,
          ),
        );
      },
    );
  }

  Future<void> _onMyPostListNextFetched(
    MyPostListNextPageFetched event,
    Emitter<MyPostListState> emit,
  ) async {
    if (_isBusy || state.hasReachedMax) return;
    _userId = event.userId;

    emit(state.copyWith(status: MyPostListStatus.fetchingNextPage));

    await Future.delayed(const Duration(seconds: 1));

    final result = await _getMyPostUseCase(
      GetMyPostParams(
        userId: event.userId,
        offset: state.posts.length,
        limit: _pageSize,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: MyPostListStatus.loaded,
          transientFailure: () => failure,
        ),
      ),
      (newPosts) => emit(
        state.copyWith(
          status: MyPostListStatus.loaded,
          posts: state.posts + newPosts,
          hasReachedMax: newPosts.length < _pageSize,
        ),
      ),
    );
  }

  Future<void> _onMyPostListRefreshed(
    MyPostListRefreshed event,
    Emitter<MyPostListState> emit,
  ) async {
    if (_isBusy) return;
    _userId = event.userId;

    emit(state.copyWith(status: MyPostListStatus.refreshing));

    final result = await _getMyPostUseCase(
      GetMyPostParams(userId: event.userId, offset: 0, limit: _pageSize),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: MyPostListStatus.loaded,
          transientFailure: () => failure,
        ),
      ),
      (posts) => emit(
        MyPostListState(
          status: MyPostListStatus.loaded,
          posts: posts,
          hasReachedMax: posts.length < _pageSize,
        ),
      ),
    );
  }

  void _onMyPostListTransientFailureConsumed(
    MyPostListTransientFailureConsumed event,
    Emitter<MyPostListState> emit,
  ) {
    emit(state.copyWith(transientFailure: () => null));
  }
}
