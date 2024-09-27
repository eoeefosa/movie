import 'package:flutter/material.dart';
import 'package:torihd/models/movie.dart';
import 'package:torihd/screens/upload/previewmovie.dart';
import 'package:torihd/styles/snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../provider/profile_manager.dart';

class UploadMovie extends StatefulWidget {
  const UploadMovie({
    super.key,
    this.imageUrl,
    this.title,
    this.type,
    this.rating,
    this.detail,
    this.description,
    this.downloadlink,
    this.youtubelink,
    this.source,
  });

  final String? imageUrl;
  final String? title;
  final String? type;
  final String? rating;
  final String? detail;
  final String? description;
  final String? downloadlink;
  final String? youtubelink;
  final String? source;

  @override
  State<UploadMovie> createState() => _UploadMovieState();
}

class _UploadMovieState extends State<UploadMovie> {
  String? _retrieveDataError;
  String? selectedState = "Movie";

  final TextEditingController stateController = TextEditingController();

  static String convertIdToUrl(String? id,
      {bool trimWhitespaces = true,
      String format = "https://www.youtube.com/watch?v="}) {
    if (id == null) {
      return '';
    }
    if (trimWhitespaces) id = id.trim();

    // Check if the ID is valid (11 characters long and contains valid characters)
    if (id.length == 11 && RegExp(r"^[\w\-]+$").hasMatch(id)) {
      return format + id;
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController movieTitleController = TextEditingController();
    movieTitleController.text = widget.title ?? '';
    final TextEditingController movieImageUrl = TextEditingController();
    movieImageUrl.text = widget.imageUrl ?? '';
    final TextEditingController detailsController = TextEditingController();
    detailsController.text = widget.detail ?? '';
    final TextEditingController ratingController = TextEditingController();
    ratingController.text = widget.rating ?? '';
    final TextEditingController movieDescriptionController =
        TextEditingController();
    movieDescriptionController.text = widget.description ?? '';
    final TextEditingController downloadlinkController =
        TextEditingController();
    downloadlinkController.text = widget.downloadlink ?? '';
    final TextEditingController youtubeTrailerlinkController =
        TextEditingController();
    final TextEditingController sourceController = TextEditingController();
    youtubeTrailerlinkController.text = widget.youtubelink ?? '';
    final newlink = convertIdToUrl(youtubeTrailerlinkController.text);
    youtubeTrailerlinkController.text = newlink;

    void submit() {
      if (formKey.currentState!.validate()) {
        formKey.currentState?.save();
        // Perform the login action here, e.g., send the email and password to your server
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Logging in...')));
      }
    }

    final ProfileManager userProfile = ProfileManager();

    return Scaffold(
      appBar: AppBar(
        title: widget.title == null
            ? const Text("Movie upload")
            : const Text("Edit Movie"),
        actions: [
          IconButton(
              onPressed: () {
                Provider.of<ProfileManager>(context, listen: false)
                    .toggleDarkmode();
                // setState(() {});
              },
              icon: Icon(
                Provider.of<ProfileManager>(context).themeMode ==
                        ThemeModeType.light
                    ? Icons.light_mode
                    : Provider.of<ProfileManager>(context).themeMode ==
                            ThemeModeType.dark
                        ? Icons.dark_mode
                        : Icons.brightness_auto, // For system theme mode
              ))
        ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  controller: movieImageUrl,
                  decoration: const InputDecoration(
                    labelText: 'Movie Image Url',
                    border: OutlineInputBorder(
                        // borderSide: Border.al
                        ),
                  ),
                  keyboardType: TextInputType.url,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the movie image url';
                    }
                    return null;
                  },
                  // onSaved: (value) => movieTitle = value!,
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Type"),
                    DropdownButton<String>(
                      value: selectedState,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedState = newValue!;
                        });
                      },
                      items: <String>[
                        "Movie",
                        "TV series",
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: movieTitleController,
                  decoration: const InputDecoration(
                    labelText: 'Movie Title',
                    border: OutlineInputBorder(
                        // borderSide: Border.al
                        ),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the movie Title';
                    }
                    return null;
                  },
                  // onSaved: (value) => movieTitle = value!,
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: ratingController,
                  decoration: const InputDecoration(
                    labelText: 'Movie rating',
                    border: OutlineInputBorder(
                        // borderSide: Border.al
                        ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the movie rating';
                    }
                    return null;
                  },
                  // onSaved: (value) => movieTitle = value!,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  maxLines: 2,
                  controller: detailsController,
                  decoration: const InputDecoration(
                    labelText: 'Movie detail',
                    hintText:
                        "e.g Australia/Action, Adventure, Sci-Fi/2024-05-24/2h 28m",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the movie Title';
                    }
                    return null;
                  },
                  // onSaved: (value) => movieTitle = value!,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "e.g Australia/Action, Adventure, Sci-Fi/2024-05-24/2h 28m",
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  controller: movieDescriptionController,
                  maxLines: 9,
                  decoration: const InputDecoration(
                    // labelText: 'Movie Description',
                    hintText: 'Movie Description',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the movie Description';
                    }

                    return null;
                  },
                  // onSaved: (value) => movieDescription = value!,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: downloadlinkController,
                  decoration: const InputDecoration(
                    labelText: 'Download link',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the Download Link';
                    }

                    return null;
                  },
                  // onSaved: (value) => downloadlink = value!,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: youtubeTrailerlinkController,
                  decoration: const InputDecoration(
                    labelText: 'Youtube Trailer link',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the Youtube Trailer Link';
                    }

                    return null;
                  },
                  // onSaved: (value) => youtubeTrailerLink = value!,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: sourceController,
                  decoration: const InputDecoration(
                    labelText: 'Source',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the Youtube Trailer Link';
                    }

                    return null;
                  },
                  // onSaved: (value) => youtubeTrailerLink = value!,
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: sourceController,
                  decoration: const InputDecoration(
                    labelText: 'Country',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the Youtube Trailer Link';
                    }

                    return null;
                  },
                  // onSaved: (value) => youtubeTrailerLink = value!,
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: sourceController,
                  decoration: const InputDecoration(
                    labelText: 'cast(separated by commas)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the Youtube Trailer Link';
                    }

                    return null;
                  },
                  // onSaved: (value) => youtubeTrailerLink = value!,
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: sourceController,
                  decoration: const InputDecoration(
                    labelText: 'Release date',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the Youtube Trailer Link';
                    }

                    return null;
                  },
                  // onSaved: (value) => youtubeTrailerLink = value!,
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: sourceController,
                  decoration: const InputDecoration(
                    labelText: 'Language',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the Youtube Trailer Link';
                    }

                    return null;
                  },
                  // onSaved: (value) => youtubeTrailerLink = value!,
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: sourceController,
                  decoration: const InputDecoration(
                    labelText: 'Tags',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the Youtube Trailer Link';
                    }

                    return null;
                  },
                  // onSaved: (value) => youtubeTrailerLink = value!,
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          try {
                            if (!context.mounted) return;
                            String? videoId = widget.title == null
                                ? YoutubePlayer.convertUrlToId(
                                    youtubeTrailerlinkController.text,
                                  )
                                : youtubeTrailerlinkController.text == newlink
                                    ? widget.youtubelink
                                    : YoutubePlayer.convertUrlToId(
                                        youtubeTrailerlinkController.text,
                                      );

                            final uploadmovie = Movie(
                              movieImgurl: movieImageUrl.text,
                              type: selectedState!,
                              title: movieTitleController.text,
                              rating: ratingController.text,
                              detail: detailsController.text,
                              description: movieDescriptionController.text,
                              downloadlink: downloadlinkController.text,
                              id: "",
                              youtubetrailer: videoId ?? '',
                              source: sourceController.text,
                            );
                            await context
                                .read<ProfileManager>()
                                .addMovie(uploadmovie);
                            showsnackBar('upload successfull');

                            Navigator.pop(context);
                            if (!context.mounted) return;
                            // context.go("/home/2");
                          } catch (e) {
                            showsnackBar('Failed to sign in $e');
                          }
                        }
                      },
                      child: widget.title == null
                          ? const Text('Upload movie')
                          : const Text('Update movie'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          if (movieImageUrl.text != '') {
                            if (!context.mounted) return;
                            String? videoId = YoutubePlayer.convertUrlToId(
                              youtubeTrailerlinkController.text,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MoviePreviewScreen(
                                  movieTitle: movieTitleController.text,
                                  movieDescription:
                                      movieDescriptionController.text,
                                  downloadLink: downloadlinkController.text,
                                  youtubeTrailerLink: videoId!,
                                  category: selectedState!,
                                  imagePath: movieImageUrl.text,
                                  rating: ratingController.text,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Please select a movie image url.'),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('Preview Movie'),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
