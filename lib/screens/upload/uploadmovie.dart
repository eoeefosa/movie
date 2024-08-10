import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:torihd/api/mockapiservice.dart';
import 'package:torihd/screens/upload/previewmovie.dart';
import 'package:torihd/styles/snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../models/appState/profile_manager.dart';

class UploadMovie extends StatefulWidget {
  const UploadMovie({super.key});

  @override
  State<UploadMovie> createState() => _UploadMovieState();
}

class _UploadMovieState extends State<UploadMovie> {
  String? _retrieveDataError;
  String? selectedState = "Movie";

  final TextEditingController stateController = TextEditingController();
  final MovieBoxCloneApi mockapi = MovieBoxCloneApi();
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController movieTitleController = TextEditingController();
    final TextEditingController movieImageUrl = TextEditingController();
    final TextEditingController detailsController = TextEditingController();
    final TextEditingController ratingController = TextEditingController();
    final TextEditingController movieDescriptionController =
        TextEditingController();
    final TextEditingController downloadlinkController =
        TextEditingController();
    final TextEditingController youtubeTrailerlinkController =
        TextEditingController();

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
        title: const Text("Image upload"),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ProfileManager>(context, listen: false)
                  .toggleDarkmode();
              // setState(() {});
            },
            icon: Provider.of<ProfileManager>(context, listen: false).darkMode
                ? const Icon(Icons.light_mode)
                : const Icon(Icons.dark_mode),
          )
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
                  controller: youtubeTrailerlinkController,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          try {
                            if (!context.mounted) return;
                            String? videoId = YoutubePlayer.convertUrlToId(
                              youtubeTrailerlinkController.text,
                            );

                            await context.read<ProfileManager>().addMovie(
                                  movieTitleController.text,
                                  selectedState!,
                                  ratingController.text,
                                  movieImageUrl.text,
                                  movieDescriptionController.text,
                                  downloadlinkController.text,
                                  videoId ?? youtubeTrailerlinkController.text,
                                );
                            showsnackBar('upload successfull');
                            if (!context.mounted) return;
                            // context.go("/home/2");
                          } catch (e) {
                            showsnackBar('Failed to sign in $e');
                          }
                        }
                      },
                      child: const Text('Upload movie'),
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
