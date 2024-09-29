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
    this.country,
    this.cast,
    this.releasedate,
    this.language,
    this.tags,
    this.id,
    this.movie,
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
  final String? country;
  final String? cast;
  final String? releasedate;
  final String? language;
  final String? tags;
  final String? id;
  final Movie? movie;

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

  final formKey = GlobalKey<FormState>();
  final TextEditingController movieTitleController = TextEditingController();
  final TextEditingController movieImageUrl = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();
  final TextEditingController movieDescriptionController =
      TextEditingController();
  final TextEditingController downloadlinkController = TextEditingController();
  final TextEditingController youtubeTrailerlinkController =
      TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController castController = TextEditingController();
  final TextEditingController releasedateController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();
  final List<TextEditingController> controllers = [];

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }

    super.dispose();
  }

  void addLinkField() {
    setState(() {
      controllers.add(TextEditingController());
    });
  }

  void removeLinkField(int index) {
    setState(() {
      controllers[index].dispose();
      controllers.removeAt(index);
    });
  }

  void submit() {
    if (formKey.currentState!.validate()) {
      formKey.currentState?.save();
      // Perform the login action here, e.g., send the email and password to your server
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Logging in...')));
    }
  }

  final ProfileManager userProfile = ProfileManager();

  @override
  Widget build(BuildContext context) {
    print(widget.cast);
    movieTitleController.text = widget.title ?? '';
    movieImageUrl.text = widget.imageUrl ?? '';
    detailsController.text = widget.detail ?? '';
    ratingController.text = widget.rating ?? '';
    movieDescriptionController.text = widget.description ?? '';
    downloadlinkController.text = widget.downloadlink ?? '';
    youtubeTrailerlinkController.text = widget.youtubelink ?? '';
    final newlink = convertIdToUrl(youtubeTrailerlinkController.text);
    youtubeTrailerlinkController.text = newlink;
    sourceController.text = widget.movie?.source ?? '';
    countryController.text = widget.movie?.country ?? '';
    castController.text = widget.movie?.cast?.join(', ') ?? '';
    releasedateController.text = widget.movie?.releasedate ?? '';
    languageController.text = widget.movie?.language?.join(', ') ?? '';
    tagsController.text = widget.movie?.tags?.join(', ') ?? '';

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
                color: Colors.yellow.shade700,
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
                Column(children: [
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controllers.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: TextFormField(
                            controller: controllers[index],
                            decoration: InputDecoration(
                              labelText: 'Download link(${index + 1})',
                              border: const OutlineInputBorder(),
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
                        );
                      }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text("Add or remove download links"),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          addLinkField();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (controllers.isNotEmpty) {
                            removeLinkField(controllers.length - 1);
                          }
                        },
                      ),
                    ],
                  ),
                ]),
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

                  // onSaved: (value) => youtubeTrailerLink = value!,
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: countryController,
                  decoration: const InputDecoration(
                    labelText: 'Country',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,

                  // onSaved: (value) => youtubeTrailerLink = value!,
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: castController,
                  decoration: const InputDecoration(
                    labelText: 'cast(separated by commas)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,

                  // onSaved: (value) => youtubeTrailerLink = value!,
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: releasedateController,
                  decoration: const InputDecoration(
                    labelText: 'Release date',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.datetime,

                  // onSaved: (value) => youtubeTrailerLink = value!,
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: languageController,
                  decoration: const InputDecoration(
                    labelText: 'Language(s) separate by comma if multiple',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,

                  // onSaved: (value) => youtubeTrailerLink = value!,
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: tagsController,
                  decoration: const InputDecoration(
                    labelText: 'Tags(seperated by commas)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,

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
                              id: widget.movie?.id,
                              youtubetrailer: videoId ?? '',
                              source: sourceController.text,
                              country: countryController.text,
                              cast: castController.text
                                  .split(',')
                                  .map((e) => e.trim())
                                  .toList(),
                              releasedate: releasedateController.text,
                              language: languageController.text
                                  .split(',')
                                  .map((e) => e.trim())
                                  .toList(),
                              tags: tagsController.text
                                  .split(',')
                                  .map((e) => e.trim())
                                  .toList(),
                            );
                            if (widget.title == null) {
                              await context
                                  .read<ProfileManager>()
                                  .addMovie(uploadmovie);
                              showsnackBar('upload successfull');
                            } else {
                              await context
                                  .read<ProfileManager>()
                                  .updateMovie(uploadmovie);
                              showsnackBar('upload successfull');
                            }

                            if (!context.mounted) return;
                            Navigator.pop(context);
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
                            final uploadmovie = Movie(
                              movieImgurl: movieImageUrl.text,
                              type: selectedState!,
                              title: movieTitleController.text,
                              rating: ratingController.text,
                              detail: detailsController.text,
                              description: movieDescriptionController.text,
                              downloadlink: downloadlinkController.text,
                              id: widget.id ?? "",
                              youtubetrailer: videoId ?? '',
                              source: sourceController.text,
                              country: countryController.text,
                              cast: castController.text
                                  .split(',')
                                  .map((e) => e.trim())
                                  .toList(),
                              releasedate: releasedateController.text,
                              language: languageController.text
                                  .split(',')
                                  .map((e) => e.trim())
                                  .toList(),
                              tags: tagsController.text
                                  .split(',')
                                  .map((e) => e.trim())
                                  .toList(),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MoviePreviewScreen(
                                  movie: uploadmovie,
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
