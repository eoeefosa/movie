import 'package:flutter/material.dart';
import 'package:torihd/api/movie_api.dart';
import 'package:torihd/models/movie.dart';
import 'package:intl/intl.dart'; // For date formatting

class UpdatedListView extends StatefulWidget {
  const UpdatedListView({super.key});

  @override
  _UpdatedListViewState createState() => _UpdatedListViewState();
}

class _UpdatedListViewState extends State<UpdatedListView> {
  late Future<List<Movie>> _moviesFuture;

  @override
  void initState() {
    super.initState();
    _moviesFuture =
        MovieApi().fetchmovies(); // Fetch movies when the widget is created
  }

  bool isLinkExpired(DateTime? expirationDate) {
    if (expirationDate == null) {
      return true; // If the expiration date is null, consider it expired
    }
    return DateTime.now().isAfter(expirationDate); // Check if expired
  }

  // Method to refresh the list of movies
  void refreshMovies() {
    setState(() {
      _moviesFuture = MovieApi().fetchmovies(); // Re-fetch movies after update
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies with Expired Download Links'),
      ),
      body: FutureBuilder<List<Movie>>(
        future: _moviesFuture, // Use the future stored in the state
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No movies found'));
          }

          // Filter movies where the download expiration is null or expired
          final movies = snapshot.data!
              .where((movie) => isLinkExpired(movie.downloadLinkExpiration))
              .toList();

          if (movies.isEmpty) {
            return const Center(
                child: Text('No expired download links found.'));
          }

          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];

              return MovieListItem(movie: movie, onLinkUpdated: refreshMovies);
            },
          );
        },
      ),
    );
  }
}

class MovieListItem extends StatelessWidget {
  final Movie movie;
  final VoidCallback onLinkUpdated;

  const MovieListItem(
      {super.key, required this.movie, required this.onLinkUpdated});

  @override
  Widget build(BuildContext context) {
    // Format the expiration date using DateFormat
    String formattedExpirationDate = 'N/A'; // Default to 'N/A' if null
    if (movie.downloadLinkExpiration != null) {
      formattedExpirationDate =
          DateFormat.yMMMd().add_jm().format(movie.downloadLinkExpiration!);
    }

    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie image
            SizedBox(
              width: 100,
              height: 150,
              child: movie.movieImgurl.isNotEmpty
                  ? Image.network(
                      movie.movieImgurl,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.movie, size: 50),
            ),
            const SizedBox(width: 10),

            // Movie title, download link and number of downloads
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Movie title
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Download link
                  const Text(
                    'Download link:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {
                      // Implement link opening logic, e.g., launch the URL
                    },
                    child: Text(
                      movie.downloadlink ?? "",
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Number of downloads and expiration date
                  const Row(
                    children: [
                      Text(
                        'Downloads:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 4),
                      Text(
                        '0', // Placeholder for download count
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Download expiration date
                  Row(
                    children: [
                      const Text(
                        'Download Expiration:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formattedExpirationDate,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Edit button for the download link
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Add logic to open an edit dialog for the download link
                showEditDownloadDialog(context, movie);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Edit download link dialog
  void showEditDownloadDialog(BuildContext context, Movie movie) {
    final downloadLinkController =
        TextEditingController(text: movie.downloadlink);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Download Link'),
          content: TextField(
            controller: downloadLinkController,
            decoration: const InputDecoration(
              labelText: 'Download Link',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Logic to update the download link in Firestore
                final newExpirationDate =
                    DateTime.now().add(const Duration(days: 1));

                // Update the download link and the expiration date in Firestore
                await MovieApi().updateMovieById(
                  movie.id!,
                  'Movie', // Assuming 'Movie' is the collection type
                  {
                    'downloadlink': downloadLinkController.text,
                    'downloadLinkExpiration':
                        newExpirationDate, // Update expiration date
                  },
                );

                // Show a snackbar once the link is updated
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Download link updated successfully!'),
                  ),
                );

                // Refresh the movies list by calling the callback
                onLinkUpdated();

                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
