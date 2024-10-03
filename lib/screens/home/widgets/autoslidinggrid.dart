import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart'; // Import shimmer package
import 'package:torihd/screens/moviescreen/viewmovies.dart';
import '../../../models/movie.dart';
import '../../../provider/movieprovider.dart';

class AutoSlidingGridView extends StatefulWidget {
  final MovieProvider movieProvider;

  const AutoSlidingGridView({required this.movieProvider, super.key});

  @override
  State<AutoSlidingGridView> createState() => _AutoSlidingGridViewState();
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
          nextScrollOffset = 0;
          // Smoothly scroll back to the start
          _scrollController.animateTo(
            nextScrollOffset,
            duration: _scrollDuration,
            curve: Curves.easeInOut,
          );
          return; // Exit early to avoid scrolling twice
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
      height: 200.h,
      width: 400.w,
      child: widget.movieProvider.movies.isEmpty
          ? _buildShimmerGrid() // Show shimmer grid when loading
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 400.w),
              controller: _scrollController,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget.movieProvider.movies.length,
              itemBuilder: (context, index) {
                final Movie currentmovie = widget.movieProvider.movies[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => Viewmovies(
                          movieid: currentmovie.id!,
                          type: currentmovie.type,
                          youtubeid: currentmovie.youtubetrailer,
                        ),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(10)),
                      child: CachedNetworkImage(
                        imageUrl: currentmovie.movieImgurl,
                        fit: BoxFit
                            .contain, // Ensures the image covers the available space
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  // Shimmer effect for grid items
  Widget _buildShimmerGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 400),
      controller: _scrollController,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: 6, // Number of shimmer items to show
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              width: 150,
              height: 200,
            ),
          ),
        );
      },
    );
  }
}
