import 'dart:async';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:torihd/api/movie_api.dart';
import 'package:torihd/styles/snack_bar.dart';

import '../models/movie.dart';

class MovieProvider extends ChangeNotifier {
  bool storagepermision = false;
  bool loadingdownloads = false;
  bool _movieisloading = false;
  bool _trendingloading = false;
  bool _topPickloading = false;
  bool _tvseriesloading = false;
  bool _trendingCarouselloading = false;
  bool _deleteisloading = false;

  List<Movie> topRatedMovies = [];
  List<Movie> nowPlayingMovies = [];
  List<Movie> popularMovies = [];

  get movieisloading => _movieisloading;
  get trendingloading => _trendingloading;
  get topPickloading => _topPickloading;
  get deleteisloading => _deleteisloading;
  get tvseriesloading => _tvseriesloading;
  get trendingCarouselloading => _trendingCarouselloading;

  bool movieinfoisloading = false;
  Movie? currentmovieinfo;

  List<Movie> movies = [];
  List<Movie> trending = [];
  List<Movie> tvSeries = [];
  List<Movie> toppick = [];
  List<Movie> trendingCarousel = [];
  MovieApi api = MovieApi();

  List<VideoData> videoData = [];
  List<FileSystemEntity?> downloads = [];

  // Search-related state
  String _searchQuery = '';
  List<Movie> _searchResults = [];

  List<Movie> get searchResults => _searchResults;

  void getmovieinfo(String type, String id) async {
    movieinfoisloading = true;
    notifyListeners();
    final Movie? movieinfo = await api.fetchavideo(type, id);
    currentmovieinfo = movieinfo;
    movieinfoisloading = false;
    notifyListeners();
  }

  void loadFiles() async {
    if (await Permission.storage.request().isGranted ||
        await Permission.manageExternalStorage.request().isGranted) {
      storagepermision = true;
      getDownloads();
      notifyListeners();
    } else {
      storagepermision = false;
      notifyListeners();
    }
  }

  void getDownloads() async {
    loadingdownloads = true;
    notifyListeners();

    // Request storage permissions
    if (await Permission.storage.request().isGranted) {
      try {
        // Start a timeout for the entire process
        await Future.any([
          _getVideoFiles(), // Call to the method that handles file retrieval
          Future.delayed(const Duration(milliseconds: 5)).then((_) {
            throw TimeoutException("Operation timed out");
          }),
        ]);
      } catch (e) {
        loadingdownloads = false;
        notifyListeners();
        return; // Exit if there's an error or timeout
      }

      loadingdownloads = false;
      notifyListeners();
    } else {
      loadingdownloads = false;
      notifyListeners();
    }
  }

// Method to handle the retrieval of video files
  Future<void> _getVideoFiles() async {
    final videoInfo = FlutterVideoInfo();

    // Get the path of the Download directory
    String downloadsPath = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    final downloadsDir = Directory('$downloadsPath/Tori');

    // Check if the directory exists
    if (!downloadsDir.existsSync()) {
      return;
    }

    // List video files in the directory
    List<FileSystemEntity> videofiles = downloadsDir
        .listSync(recursive: false, followLinks: false)
        .where((file) =>
            file is File &&
            (file.path.endsWith('.mp4') ||
                file.path.endsWith('.mov') ||
                file.path.endsWith('.mkv') ||
                file.path.endsWith('.avi')))
        .toList();

    for (var file in videofiles) {
      var info = await videoInfo.getVideoInfo(file.path);
      if (info != null) {
        // Handle potential null values in VideoData properties
        info.title = info.title ?? 'Unknown Title';
        showsnackBar(info.title.toString());
        info.filesize = info.filesize ?? 0;
        info.path = info.path ?? 'Unknown Path';
        info.orientation = info.orientation ?? 90;

        videoData.add(info);
      }
    }
    downloads = videofiles;
  }

  void fetchmovie() async {
    _movieisloading = true;
    notifyListeners();

    final moviesList = await api.fetchmovies();
    for (var movie in moviesList) {}

    movies = moviesList;
    _searchResults = movies; // Initialize search results
    _movieisloading = false;
    notifyListeners();
  }

  void fetchtrending() async {
    _trendingloading = true;
    notifyListeners();
    final trendingList = await api.fetchmovies();
    trending = trendingList;
    _trendingloading = false;
    notifyListeners();
  }

  void fetchTrendingCarousel() async {
    _trendingCarouselloading = true;
    notifyListeners();
    final trendingCarouselList = await api.fetchTrendingCarousel();
    trendingCarousel = trendingCarouselList;
    trendingCarouselList.addAll(movies);
    trendingCarouselList.addAll(tvSeries);
    _trendingCarouselloading = false;
    notifyListeners();
  }

  void fetchTvSeries() async {
    _tvseriesloading = true;
    print("fetching tvseries");
    notifyListeners();
    final tvseriesList = await api.fetchTvseries();
    print(tvseriesList);
    tvSeries = tvseriesList;
    _tvseriesloading = false;
    notifyListeners();
  }

  // void getData() async {
  //   MovieServices movieServices = MovieServices();
  //   topRatedMovies = await movieServices.fetchTopRatedMovies();
  //   nowPlayingMovies = await movieServices.fetchNowPlayingMovies();
  //   popularMovies = await movieServices.fetchPopularMovies();
  // }

  void fetchTopPick() async {
    _topPickloading = true;
    notifyListeners();
    final toppickslist = await api.topPick();
    toppick = toppickslist;
    toppick.addAll(movies);
    toppick.addAll(tvSeries);
    _topPickloading = false;
    notifyListeners();
  }

  void deletMovie(String id, String title, String type) async {
    _deleteisloading = true;
    notifyListeners();
    await api.deleteMovieById(id, type);

    fetchmovie();
    showsnackBar("$title deleted succefully");
    notifyListeners();
  }

  // Search method
  void searchMovies(String query) {
    _searchQuery = query.toLowerCase();
    _searchResults = movies.where((movie) {
      return movie.title.toLowerCase().contains(_searchQuery) ||
          movie.description.toLowerCase().contains(_searchQuery);
    }).toList();
    notifyListeners();
  }
}
