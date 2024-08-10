import 'package:flutter/material.dart';
import 'package:torihd/screens/home/trending/Movie.dart';
import 'package:torihd/screens/home/trending/trending.dart';
import 'package:torihd/screens/home/trending/tv_series.dart';

import '../../api/mockapiservice.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});
  final mockService = MovieBoxCloneApi();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: mockService.getCategories(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final List<String> tabnav = snapshot.data ?? [];
          return RefreshIndicator(
            onRefresh: () {
              return mockService.refresh();
            },
            child: DefaultTabController(
              length: tabnav.length,
              child: Scaffold(
                appBar: AppBar(
                  actions: const [],
                  title: TextField(
                    // onChanged: _filterItems,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                  elevation: 0,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(kToolbarHeight),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return TabBar(
                          isScrollable: constraints.maxWidth <
                              600, // Scrollable for small screens
                          tabs: tabnav
                              .map((String label) => Tab(text: label))
                              .toList(),
                        );
                      },
                    ),
                  ),
                ),
                body: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      children: [
                        Expanded(
                          child: TabBarView(
                            children: tabnav.map((String label) {
                              if (label == "Trending") {
                                return const Trending();
                              } else if (label == "Movie") {
                                return const MoviesScreen();
                              } else if (label == "TV/Series") {
                                return const TVSeries();
                              } else {
                                return Center(
                                    child: Text('Content for $label'));
                              }
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
