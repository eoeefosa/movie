import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torihd/api/mockapiservice.dart';
import 'package:torihd/screens/home/trending/Movie.dart';
import 'package:torihd/screens/home/trending/trending.dart';
import 'package:torihd/screens/home/trending/tv_series.dart';

import '../../provider/movieprovider.dart';

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
                    bottom: TabBar(
                      isScrollable: true,
                      tabs: tabnav
                          .map((String label) => Tab(text: label))
                          .toList(),
                    ),
                  ),
                  body: SizedBox(
                    height: 500,
                    child: Column(
                      children: [
                        // TODO: ALLOW SLIDE SCROLLING OF APPBAR
                        Expanded(
                          child: TabBarView(children: [
                            const Trending(),
                            const MoviesScreen(),
                            TVSeries(),
                            // const Center(child: Text('Following context')),
                            // const Center(child: Text('Following context')),
                            // const Center(child: Text('Following context')),
                            // const Center(child: Text('Following context')),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
