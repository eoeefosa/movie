import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torihd/models/movie.dart';
import 'package:torihd/provider/profile_manager.dart';
import 'package:torihd/screens/upload/provider/upload_provider.dart';
import 'package:torihd/screens/upload/previewmovie.dart';
import 'package:torihd/screens/upload/widget/movie_form_fields.dart';
import 'package:torihd/screens/upload/widget/seasonlist.dart';

class UploadTVMovie extends StatelessWidget {
  final String? id;
  final Movie? movie;
  final List<Map<String, dynamic>>? seasons;

  const UploadTVMovie({
    super.key,
    this.id,
    this.movie,
    this.seasons,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UploadMovieProvider()..initializeControllers(movie),
      child: Scaffold(
        appBar: AppBar(
          title: Text(movie == null ? "Movie upload" : "Edit Movie"),
          actions: [
            Consumer<ProfileManager>(
              builder: (context, profileManager, _) => IconButton(
                onPressed: () => profileManager.toggleDarkmode(),
                icon: Icon(
                  profileManager.themeMode == ThemeModeType.light
                      ? Icons.light_mode
                      : profileManager.themeMode == ThemeModeType.dark
                          ? Icons.dark_mode
                          : Icons.brightness_auto,
                  color: Colors.yellow.shade700,
                ),
              ),
            )
          ],
        ),
        body: const UploadTVMovieForm(),
      ),
    );
  }
}

class UploadTVMovieForm extends StatelessWidget {
  const UploadTVMovieForm({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const MovieFormFields(),
              Consumer<UploadMovieProvider>(
                builder: (context, provider, _) =>
                    provider.selectedType == "TV series"
                        ? const SeasonsList()
                        : const SizedBox.shrink(),
              ),
              const SizedBox(height: 16.0),
              const ActionButtons(),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UploadMovieProvider>(
      builder: (context, provider, _) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () => _handleUpload(context, provider),
            child: Text(provider.selectedType == "TV series"
                ? '${provider.initializemovie ? "update" : "upload"}  TV Series'
                : '${provider.initializemovie ? "update" : "upload"}  Movie'),
          ),
          ElevatedButton(
            onPressed: () => _handlePreview(context, provider),
            child: const Text('Preview'),
          ),
        ],
      ),
    );
  }

  void _handleUpload(BuildContext context, UploadMovieProvider provider) async {
    if (Form.of(context).validate()) {
      try {
        // Check if we're editing an existing movie or creating a new one
        final movie = provider.createMovie(null);

        if (provider.initializemovie) {
          await context.read<ProfileManager>().updateMovie(movie);
        } else {
          // Adding a new movie
          await context.read<ProfileManager>().addMovie(movie);
        }

        if (!context.mounted) return;

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${provider.selectedType == "TV series" ? "TV series" : "Movie"} ${provider.initializemovie ? "update" : "upload"} successful'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to ${provider.initializemovie ? "update" : "upload"}: $e')),
        );
      }
    }
  }

  void _handlePreview(BuildContext context, UploadMovieProvider provider) {
    if (Form.of(context).validate()) {
      if (provider.controllers['movieImage']!.text.isNotEmpty) {
        final movie = provider.createMovie(null);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MoviePreviewScreen(movie: movie),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a movie image url.')),
        );
      }
    }
  }
}
