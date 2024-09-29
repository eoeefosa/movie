import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torihd/provider/movieprovider.dart';

import '../moviescreen/moviescreen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    // Initialize fetching movies for search functionality
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MovieProvider>(context, listen: false).fetchmovie();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);
    final searchResults = movieProvider.searchResults;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              movieProvider.searchMovies(''); // Clear search results
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Search Input Field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for a movie...',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Perform search when the search icon is pressed
                    movieProvider.searchMovies(_searchController.text);
                  },
                ),
              ),
              onChanged: (value) {
                // Perform search when the text is changed
                movieProvider.searchMovies(value);
              },
            ),
            const SizedBox(height: 10),
            // Search Results List
            Expanded(
              child: movieProvider.movieisloading
                  ? const Center(child: CircularProgressIndicator())
                  : searchResults.isEmpty
                      ? const Center(child: Text('No results found.'))
                      : ListView.builder(
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            final movie = searchResults[index];
                            return ListTile(
                              leading: Image.network(
                                movie.movieImgurl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              title: Text(movie.title),
                              subtitle: Text(movie.description),
                              onTap: () {
                                // Navigate to movie detail screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Videoplayer(
                                      movieid: movie.id!,
                                      type: movie.type,
                                      youtubeid: movie.youtubetrailer,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
