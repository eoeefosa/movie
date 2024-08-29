import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torihd/movieboxtheme.dart';
import 'package:torihd/provider/movieprovider.dart';
import 'package:torihd/provider/profile_manager.dart';
import 'package:torihd/screens/upload/uploadmovie.dart';

import '../../../models/movie.dart';
import '../../moviescreen/moviescreen.dart';

class TopPickCard extends StatefulWidget {
  const TopPickCard({
    super.key,
    required this.title,
    required this.type,
    required this.imgUrl,
    required this.rating,
    required this.youtubeid,
    required this.movieid,
    required this.movie,
  });

  final String title;
  final String type;
  final String youtubeid;
  final String imgUrl;
  final String rating;
  final String movieid;
  final Movie movie;

  @override
  State<TopPickCard> createState() => _TopPickCardState();
}

class _TopPickCardState extends State<TopPickCard> {
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

                // Add your delete
              },
            ),
          ],
        );
      },
    );
  }

  void _onSelectedMenuOption(BuildContext context, String option) {
    print(option);
    switch (option) {
      case 'delete':
        _showAlertDialog(context, 'Delete Movie',
            'Are you sure you want to delete  ${widget.title}');
// Perform delete action
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
              description: widget.movie.description,
              detail: widget.movie.detail,
              downloadlink: widget.movie.downloadlink,
              source: widget.movie.source,
              youtubelink: widget.youtubeid,
            ),
          ),
        );
// Perform edit action
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate the width and height based on the screen width
    double cardWidth = screenWidth * 0.3;
    double cardHeight = cardWidth * 1.3;

    return Column(
      children: [
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => Videoplayer(
                movieid: widget.movieid,
                type: widget.type,
                youtubeid: widget.youtubeid,
              ),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(4),
            constraints: BoxConstraints.expand(
              width: cardWidth,
              height: cardHeight,
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: const ColorFilter.srgbToLinearGamma(),
                image: CachedNetworkImageProvider(widget.imgUrl),
                fit: BoxFit.cover,
              ),
              // backgroundBlendMode: BlendMode.darken,
              // color: Colors.black.withOpacity(),
              borderRadius: const BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Consumer<ProfileManager>(
                    builder: (context, profileProvider, child) {
                  return profileProvider.isAdmin
                      ? Positioned(
                          top: 4,
                          right: 0,
                          child: PopupMenuButton<String>(
                            // surfaceTintColor: Colors.yellow,
                            elevation: 2,
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
                                    style:
                                        TextStyle(color: Colors.red.shade700),
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
                                    style:
                                        TextStyle(color: Colors.grey.shade700),
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
                                    style: TextStyle(
                                        color: Colors.yellow.shade700),
                                  ),
                                  icon: Icon(
                                    Icons.star,
                                    color: Colors.yellow.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ))
                      : Container();
                }),
                const Positioned(
                  bottom: 4,
                  left: 0,
                  child: Padding(
                    padding: EdgeInsets.only(top: 4.0, right: 2.0),
                    child: Icon(
                      Icons.download,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 0,
                  child: Text(
                    widget.rating,
                    style: MovieBoxTheme.darkTextTheme.bodySmall,
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          width: cardWidth,
          child: Text(
            widget.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: cardWidth,
          child: Text(
            widget.type,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
