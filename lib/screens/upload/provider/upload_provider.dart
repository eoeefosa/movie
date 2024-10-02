import 'package:flutter/material.dart';
import 'package:torihd/models/movie.dart';
import 'package:torihd/models/season.dart';
import 'package:torihd/screens/upload/models/episode.dart';
import 'package:torihd/screens/upload/models/season.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class UploadMovieProvider extends ChangeNotifier {
  // Map for managing various text controllers for movie properties
  final Map<String, TextEditingController> controllers = {
    'movieTitle': TextEditingController(),
    'movieImage': TextEditingController(),
    'details': TextEditingController(),
    'rating': TextEditingController(),
    'description': TextEditingController(),
    'downloadLink': TextEditingController(),
    'youtubeTrailer': TextEditingController(),
    'source': TextEditingController(),
    'country': TextEditingController(),
    'cast': TextEditingController(),
    'releaseDate': TextEditingController(),
    'language': TextEditingController(),
    'tags': TextEditingController(),
  };

  // List of season controllers
  List<SeasonController> seasons = [];

  // Movie type
  String selectedType = "Movie";

  UploadMovieProvider() {
    if (seasons.isEmpty) {
      addInitialSeason();
    }
  }

  // Initialize text controllers based on the provided movie object
  void initializeControllers(Movie? movie) {
    controllers['movieTitle']!.text = movie?.title ?? '';
    controllers['movieImage']!.text = movie?.movieImgurl ?? '';
    controllers['details']!.text = movie?.detail ?? '';
    controllers['rating']!.text = movie?.rating ?? '';
    controllers['description']!.text = movie?.description ?? '';
    controllers['downloadLink']!.text = movie?.downloadlink ?? '';
    controllers['youtubeTrailer']!.text = movie?.youtubetrailer ?? '';
    controllers['source']!.text = movie?.source ?? '';
    controllers['country']!.text = movie?.country ?? '';
    controllers['cast']!.text = movie?.cast?.join(', ') ?? '';
    controllers['releaseDate']!.text = movie?.releasedate ?? '';
    controllers['language']!.text = movie?.language?.join(', ') ?? '';
    controllers['tags']!.text = movie?.tags?.join(', ') ?? '';

    if (movie?.type == "TV series") {
      selectedType = "TV series";
      if (movie?.seasons != null && movie!.seasons!.isNotEmpty) {
        initializeSeasons(movie.seasons!);
      } else {
        addInitialSeason();
      }
    }
  }

  // Initialize seasons with given list of seasons
  void initializeSeasons(List<Season> movieSeasons) {
    seasons.clear();

    for (var season in movieSeasons) {
      final seasonController = SeasonController(
        seasonNumber: season.seasonNumber,
        episodes: <EpisodeController>[],
      );

      for (var episode in season.episodes) {
        final episodeController = EpisodeController(
          episodeNumber: int.parse(episode.episodeNumber),
          episodeController:
              TextEditingController(text: episode.episodeNumber.toString()),
          downloadLinkController: TextEditingController(
            text: (episode.downloadLinks.isNotEmpty)
                ? episode.downloadLinks[0].url
                : '',
          ),
        );

        seasonController.episodes.add(episodeController);
      }

      seasons.add(seasonController);
    }

    notifyListeners();
  }

  // Set the selected type (Movie or TV series)
  void setType(String type) {
    selectedType = type;
    if (type == "TV series" && seasons.isEmpty) {
      addInitialSeason();
    }
    notifyListeners();
  }

  // Add initial season with a single episode
  void addInitialSeason() {
    seasons.add(
      SeasonController(
        seasonNumber: 1,
        seasonController: TextEditingController(text: '1'),
        episodes: [
          EpisodeController(
            episodeNumber: 1,
            episodeController: TextEditingController(text: '1'),
            downloadLinkController: TextEditingController(),
          ),
        ],
      ),
    );
    notifyListeners();
  }

  // Add a new season
  void addSeason() {
    int seasonNumber = seasons.length + 1;
    seasons.add(
      SeasonController(
        seasonNumber: seasonNumber,
        seasonController: TextEditingController(text: seasonNumber.toString()),
        episodes: [
          EpisodeController(
            episodeNumber: 1,
            episodeController: TextEditingController(text: '1'),
            downloadLinkController: TextEditingController(),
          ),
        ],
      ),
    );
    notifyListeners();
  }

  // Add a new episode to the specified season
  void addEpisode(int seasonIndex) {
    if (seasonIndex >= 0 && seasonIndex < seasons.length) {
      final season = seasons[seasonIndex];
      int episodeNumber = season.episodes.length + 1;

      season.episodes.add(
        EpisodeController(
          episodeNumber: episodeNumber,
          episodeController:
              TextEditingController(text: episodeNumber.toString()),
          downloadLinkController: TextEditingController(),
        ),
      );

      notifyListeners();
    }
  }

  // Remove a season
  void removeSeason(int index) {
    if (seasons.length > 1) {
      seasons.removeAt(index);
    } else {
      seasons.clear();
      addInitialSeason();
    }
    notifyListeners();
  }

  // Remove an episode from a season
  void removeEpisode(int seasonIndex, int episodeIndex) {
    final season = seasons[seasonIndex];
    if (season.episodes.length > 1) {
      season.episodes.removeAt(episodeIndex);
      notifyListeners();
    }
  }

  // Dispose controllers for all seasons and episodes
  @override
  void dispose() {
    controllers.forEach((_, controller) => controller.dispose());
    for (var season in seasons) {
      for (var episode in season.episodes) {
        episode.episodeController.dispose();
        episode.downloadLinkController.dispose();
      }
    }
    super.dispose();
  }

  // Create a Movie object from the current state
  Movie createMovie(String? id) {
    String? videoId =
        YoutubePlayer.convertUrlToId(controllers['youtubeTrailer']!.text);

    if (selectedType == "TV series") {
      return Movie(
        id: id ?? '',
        type: selectedType,
        movieImgurl: controllers['movieImage']!.text,
        youtubetrailer: controllers['youtubeTrailer']!.text,
        title: controllers['movieTitle']!.text,
        rating: controllers['rating']!.text,
        description: controllers['description']!.text,
        source: controllers['source']!.text,
        country: controllers['country']!.text,
        cast:
            controllers['cast']!.text.split(',').map((e) => e.trim()).toList(),
        language: controllers['language']!
            .text
            .split(',')
            .map((e) => e.trim())
            .toList(),
        tags:
            controllers['tags']!.text.split(',').map((e) => e.trim()).toList(),
        seasons: _createSeasonsList(),
        detail: controllers['details']!.text,
      );
    } else {
      return Movie(
        movieImgurl: controllers['movieImage']!.text,
        type: selectedType,
        title: controllers['movieTitle']!.text,
        rating: controllers['rating']!.text,
        detail: controllers['details']!.text,
        description: controllers['description']!.text,
        downloadlink: controllers['downloadLink']!.text,
        id: id,
        youtubetrailer: videoId ?? '',
        source: controllers['source']!.text,
        country: controllers['country']!.text,
        cast:
            controllers['cast']!.text.split(',').map((e) => e.trim()).toList(),
        releasedate: controllers['releaseDate']!.text,
        language: controllers['language']!
            .text
            .split(',')
            .map((e) => e.trim())
            .toList(),
        tags:
            controllers['tags']!.text.split(',').map((e) => e.trim()).toList(),
      );
    }
  }

  // Create a list of seasons from the current state
  List<Season> _createSeasonsList() {
    return seasons.map((season) {
      return Season(
        seasonNumber: season.seasonNumber,
        episodes: season.episodes.map((episode) {
          return Episode(
            episodeNumber: episode.episodeNumber.toString(),
            title: '', // Placeholder if needed
            description: '', // Placeholder if needed
            releaseDate: '', // Placeholder if needed
            downloadLinks: [
              DownloadLink(
                url: episode.downloadLinkController.text,
                downloadLinkExpiration: null,
              ),
            ],
          );
        }).toList(),
      );
    }).toList();
  }
}
