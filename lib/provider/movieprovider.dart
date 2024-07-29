import 'package:flutter/material.dart';
import 'package:torihd/api/movie_api.dart';

import '../models/movie.dart';

class MovieProvider extends ChangeNotifier {
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
    notifyListeners();
    final trendingList = await api.fetchTrendingCarousel();
    trending = trendingList;
    _trendingloading = false;
    notifyListeners();
  }

  void fetchTrendingCarousel() async {
    _trendingCarouselloading = true;
    notifyListeners();
    final trendingCarouselList = await api.fetchTrendingCarousel();
    trendingCarousel = trendingCarouselList;
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
    _topPickloading = false;
    notifyListeners();
  }
}
