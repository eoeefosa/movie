import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart'; // Import the Shimmer package
import 'package:torihd/provider/movieprovider.dart';
import 'package:torihd/provider/profile_manager.dart';
import 'package:torihd/screens/upload/uploadmovie.dart';

class MovieCard extends StatefulWidget {
  const MovieCard({
    super.key,
    required this.title,
    required this.imgUrl,
    required this.rating,
    required this.movieid,
    required this.type,
    required this.youtubeid,
    required this.detail,
    required this.description,
    required this.downloadlink,
    required this.source,
    this.isLoading = false, // Add isLoading parameter with default value
  });

  final String title;
  final String imgUrl;
  final String rating;
  final String movieid;
  final String detail;
  final String description;
  final String downloadlink;
  final String source;
  final String type;
  final String youtubeid;
  final bool isLoading; // Flag to check if the card is loading

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  void _showAlertDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: Colors.red.shade300, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.grey.shade700, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Provider.of<MovieProvider>(context, listen: false)
                    .deletMovie(widget.movieid, widget.title, widget.type);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onSelectedMenuOption(BuildContext context, String option) {
    switch (option) {
      case 'delete':
        _showAlertDialog(context, 'Delete Movie',
            'Are you sure you want to delete  ${widget.title}');
        break;
      case 'edit':
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => UploadMovie(
              imageUrl: widget.imgUrl,
              type: widget.type,
              title: widget.title,
              rating: widget.rating,
              description: widget.description,
              detail: widget.detail,
              downloadlink: widget.downloadlink,
              source: widget.source,
              youtubelink: widget.youtubeid,
            ),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isLoading
        ? _buildShimmerCard() // Show shimmer card when loading
        : _buildMovieCard(); // Show actual movie card when not loading
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200.h,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 14.h,
                width: 100.w,
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.h),
              child: Container(
                height: 11.h,
                width: 60.w,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: CachedNetworkImage(
              imageUrl: widget.imgUrl,
              height: 200.h, // Set height to 100
              width: double.infinity,
              fit: BoxFit.cover, // Ensures the image covers the available space
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Rating: ${widget.rating}",
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
                const Icon(Icons.star, color: Colors.amber, size: 11),
              ],
            ),
          ),
          Consumer<ProfileManager>(builder: (context, profileProvider, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.source),
                profileProvider.isAdmin
                    ? PopupMenuButton<String>(
                        icon: const RotatedBox(
                            quarterTurns: 1, child: Icon(Icons.more_horiz)),
                        onSelected: (String result) {
                          _onSelectedMenuOption(context, result);
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: TextButton.icon(
                              onPressed: null,
                              label: Text(
                                'Delete movie',
                                style: TextStyle(color: Colors.red.shade700),
                              ),
                              icon: Icon(Icons.delete,
                                  color: Colors.red.shade700),
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'edit',
                            child: TextButton.icon(
                              onPressed: null,
                              label: Text(
                                'Edit movie',
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              icon: Icon(
                                Icons.edit,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'trend',
                            child: TextButton.icon(
                              onPressed: null,
                              label: Text(
                                'Make Trending',
                                style: TextStyle(color: Colors.yellow.shade700),
                              ),
                              icon: Icon(
                                Icons.star,
                                color: Colors.yellow.shade700,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ],
            );
          }),
        ],
      ),
    );
  }
}
