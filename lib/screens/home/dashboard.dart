import 'package:flutter/material.dart';
import 'package:torihd/screens/home/trending/Movie.dart';
import 'package:torihd/screens/home/trending/trending.dart';
import 'package:torihd/screens/home/trending/tv_series.dart';


class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
                  tabs: [
                    "Trending",
                    "Movie",
                    "TV/Series",
                  ].map((String label) => Tab(text: label)).toList(),
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
                    children: [
                      "Trending",
                      "Movie",
                      "TV/Series",
                    ].map((String label) {
                      if (label == "Trending") {
                        return const Trending();
                      } else if (label == "Movie") {
                        return const MoviesScreen();
                      } else if (label == "TV/Series") {
                        return const TVSeries();
                      } else {
                        return Center(child: Text('Content for $label'));
                      }
                    }).toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
