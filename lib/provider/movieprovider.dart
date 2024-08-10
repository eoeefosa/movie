import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:torihd/api/movie_api.dart';

import '../models/movie.dart';

class MovieProvider extends ChangeNotifier {
  bool storagepermision = false;
  bool loadingdownloads = false;
  bool _movieisloading = false;
  bool _trendingloading = false;
  bool _topPickloading = false;
  bool _tvseriesloading = false;
  bool _trendingCarouselloading = false;
  get movieisloading => _movieisloading;
  get trendingloading => _trendingloading;
  get topPickloading => _topPickloading;
  get tvseriesloading => _tvseriesloading;
  get trendingCarouselloading => _trendingCarouselloading;
  List<Movie> movies = [];
  List<Movie> trending = [];
  List<Movie> tvSeries = [];
  List<Movie> toppick = [];
  List<Movie> trendingCarousel = [];
  MovieApi api = MovieApi();

  List<VideoData> videoData = [];
  List<FileSystemEntity?> downloads = [];

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
    try {
      final videoInfo = FlutterVideoInfo();
      final downloadsDir = Directory('/storage/emulated/0/Download');

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
          info.filesize = info.filesize ?? 0;
          info.path = info.path ?? 'Unknown Path';
          info.orientation = info.orientation ?? 90;

          videoData.add(info);
        }
      }
      downloads = videofiles;
      loadingdownloads = false;
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  void fetchmovie() async {
    _movieisloading = true;
    notifyListeners();
    final moviesList = await api.fetchmovies();
    print(moviesList);
    movies = moviesList;
    _movieisloading = false;
    notifyListeners();
  }

  void fetchtrending() async {
    _trendingloading = true;
    fetchmovie();
    fetchTvSeries();
    fetchTopPick();
    notifyListeners();
    final trendingList = await api.fetchTrendingCarousel();
    trending = trendingList;
    _trendingloading = false;
    notifyListeners();
  }

  void fetchTrendingCarousel() async {
    _trendingCarouselloading = true;
    fetchtrending();
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
    notifyListeners();
    final tvseriesList = await api.fetchTvseries();
    tvSeries = tvseriesList;
    _tvseriesloading = false;
    notifyListeners();
  }

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
}
