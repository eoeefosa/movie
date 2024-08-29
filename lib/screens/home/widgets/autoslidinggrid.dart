import 'dart:async';
import 'package:flutter/material.dart';

import '../../../models/movie.dart';
import '../../../provider/movieprovider.dart';
import '../../moviescreen/moviescreen.dart';
import 'moviecard.dart';

class AutoSlidingGridView extends StatefulWidget {
  final MovieProvider movieProvider;

  const AutoSlidingGridView({required this.movieProvider, super.key});

  @override
  _AutoSlidingGridViewState createState() => _AutoSlidingGridViewState();
}

class _AutoSlidingGridViewState extends State<AutoSlidingGridView> {
  late ScrollController _scrollController;
  late Timer _timer;
  final Duration _scrollDuration =
      const Duration(seconds: 2); // Duration for scrolling
  final Duration _delay =
      const Duration(seconds: 3); // Delay before next scroll

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(_delay, (timer) {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.offset;
        double nextScrollOffset;

        if (currentScroll < maxScroll) {
          nextScrollOffset =
              currentScroll + 400; // Scroll by 400 pixels. Adjust as needed.
        } else {
          // Restart scroll from the beginning without snapping back abruptly
          nextScrollOffset = 0;
          _scrollController.jumpTo(0);
        }

        _scrollController.animateTo(
          nextScrollOffset,
          duration: _scrollDuration,
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: GridView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 400,
          mainAxisSpacing: 10,
          childAspectRatio: 5 / 3,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: widget.movieProvider.movies.length,
        itemBuilder: (context, index) {
          final Movie currentmovie = widget.movieProvider.movies[index];
          return InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => Videoplayer(
                  movieid: currentmovie.id,
                  type: currentmovie.type,
                  youtubeid: currentmovie.youtubetrailer,
                ),
              ),
            ),
            child: MovieCard(
              title: currentmovie.title,
              imgUrl: currentmovie.movieImgurl,
              rating: currentmovie.rating,
              movieid: currentmovie.id,
              type: currentmovie.type,
              youtubeid: currentmovie.youtubetrailer,
              detail: currentmovie.detail,
              description: currentmovie.description,
              downloadlink: currentmovie.downloadlink,
              source: currentmovie.source,
            ),
          );
        },
      ),
    );
  }
}
