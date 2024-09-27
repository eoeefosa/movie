import 'package:flutter/material.dart';
import 'package:torihd/screens/home/trending/Movie.dart';
import 'package:torihd/screens/home/trending/trending.dart';
import 'package:torihd/screens/home/trending/tv_series.dart';
import 'package:torihd/screens/search/searchpage.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const SearchScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.search))
          ],
          title: const Text("Tori Hd"),
          centerTitle: true,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return TabBar(
                  tabAlignment: TabAlignment.center,

                  isScrollable: constraints.maxWidth <
                      600, // Scrollable for small screens
                  tabs: [
                    "Trending",
                    "Movie",
                    "TV/Series",
                  ]
                      .map((String label) => Tab(
                            text: label,
                            iconMargin: const EdgeInsets.all(4.0),
                          ))
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
