import 'dart:io';

import 'package:flutter/material.dart';

class MoviePreviewScreen extends StatelessWidget {
  final String movieTitle;
  final String movieDescription;
  final String downloadLink;
  final String youtubeTrailerLink;
  final String category;
  final String imagePath;

  const MoviePreviewScreen({
    required this.movieTitle,
    required this.movieDescription,
    required this.downloadLink,
    required this.youtubeTrailerLink,
    required this.category,
    required this.imagePath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Preview'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.file(
                  File(imagePath),
                  height: 200,
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return const Center(
                      child: Text('This image type is not supported'),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              Text('Title: $movieTitle',
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 8.0),
              Text('Description: $movieDescription',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 8.0),
              Text('Category: $category',
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 8.0),
              Text('Download Link: $downloadLink',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 8.0),
              Text('YouTube Trailer Link: $youtubeTrailerLink',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Upload Screen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
