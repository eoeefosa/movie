import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:torihd/api/movie_api.dart';
import 'package:torihd/models/movie.dart';

class AdminMovieScreen extends StatefulWidget {
  final String movieId;
  final String movieType; // 'Movie', 'TV Series', etc.

  const AdminMovieScreen({
    super.key,
    required this.movieId,
    required this.movieType,
  });

  @override
  State<AdminMovieScreen> createState() => _AdminMovieScreenState();
}

class _AdminMovieScreenState extends State<AdminMovieScreen> {
  final _movieApi = MovieApi();
  Movie? _movie;
  final _downloadLinkController = TextEditingController();
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _fetchMovie();
  }

  Future<void> _fetchMovie() async {
    Movie? fetchedMovie =
        await _movieApi.fetchavideo(widget.movieType, widget.movieId);
    setState(() {
      _movie = fetchedMovie;
      _downloadLinkController.text = fetchedMovie?.downloadlink ?? '';
    });
  }

  Future<void> _updateDownloadLink() async {
    if (_downloadLinkController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a valid download link.')),
      );
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    try {
      await _movieApi.updateMovieById(
        widget.movieId,
        widget.movieType,
        {'downloadlink': _downloadLinkController.text},
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Download link updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update the download link.')),
      );
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Download Link'),
      ),
      body: _movie == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display movie image
                  _movie!.movieImgurl.isNotEmpty
                      ? Image.network(
                          _movie!.movieImgurl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey,
                          child: const Icon(Icons.movie,
                              size: 100, color: Colors.white),
                        ),
                  const SizedBox(height: 16),

                  // Movie title
                  Text(
                    _movie!.title,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Display current download link
                  TextFormField(
                    controller: _downloadLinkController,
                    decoration: const InputDecoration(
                      labelText: 'Download Link',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Expiration info
                  if (_movie!.downloadLinkExpiration != null)
                    Text(
                      'Download Link Expiration: ${_movie!.downloadLinkExpiration!.toLocal()}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 16),

                  // Button to update the download link
                  _isUpdating
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _updateDownloadLink,
                          child: const Text('Update Download Link'),
                        ),
                ],
              ),
            ),
    );
  }
}
