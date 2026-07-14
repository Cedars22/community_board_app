import 'package:core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../blocs/search/search_bloc.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SearchBloc>(),
      child: const SearchView(),
    );
  }
}

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_tabListener);
    _searchController.addListener(_searchListener);
  }

  void _tabListener() {
    if (_tabController.indexIsChanging) {
      context.read<SearchBloc>().add(
        SearchTabChanged(tabIndex: _tabController.index),
      );
    }
  }

  void _searchListener() {
    context.read<SearchBloc>().add(
      SearchQueryChanged(query: _searchController.text),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_searchListener);
    _tabController.removeListener(_tabListener);
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchBloc, SearchState>(
      listenWhen: (previous, current) {
        final prevTransientFailure = previous.transientFailure;
        final currentTransientFailure = current.transientFailure;
        final isTransientFailure =
            prevTransientFailure == null && currentTransientFailure != null;

        return isTransientFailure;
      },
      listener: (context, state) {
        showErrorSnackbar(
          context,
          message: state.transientFailure?.message ?? 'Unknow error',
        );
        context.read<SearchBloc>().add(SearchTransientFailureConsumed());
      },
      builder: (context, state) {
        final isLoading =
            state.status == SearchStatus.loadingUsers ||
            state.status == SearchStatus.loadingPost;

        return Scaffold(
          appBar: AppBar(
            title: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search users or posts...',
                border: InputBorder.none,
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: _searchController.clear,
                        icon: const Icon(Icons.clear, size: 20),
                      )
                    : null,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kTextTabBarHeight + 3),
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Users'),
                      Tab(text: 'Posts'),
                    ],
                  ),
                  SizedBox(
                    height: 3,
                    child: isLoading ? const LinearProgressIndicator() : null,
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(controller: _tabController, children: []),
        );
      },
    );
  }
}
