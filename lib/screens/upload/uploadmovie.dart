import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:movieboxclone/api/mockapiservice.dart';
import 'package:movieboxclone/screens/upload/previewmovie.dart';
import 'package:movieboxclone/styles/snack_bar.dart';
import 'package:provider/provider.dart';

import '../../models/appState/profile_manager.dart';

class UploadMovie extends StatefulWidget {
  const UploadMovie({super.key});

  @override
  State<UploadMovie> createState() => _UploadMovieState();
}

class _UploadMovieState extends State<UploadMovie> {
  List<XFile>? _mediaFileList;
  String? _retrieveDataError;
  String? selectedState = "Movie";

  void _setImageFileListFromFile(XFile? value) {
    _mediaFileList = value == null ? null : <XFile>[value];
  }

  Future<void> _onImageButtonPressed(
    ImageSource source, {
    required BuildContext context,
    bool isMultiImage = false,
  }) async {
    if (context.mounted) {
      if (isMultiImage) {
        try {
          final List<XFile> pickedFileList = await _picker.pickMultiImage(
            limit: 10,
          );
          setState(() {
            _mediaFileList = pickedFileList;
          });
        } catch (e) {
          setState(() {
            _pickImageError = e;
          });
        }
      } else {
        try {
          final XFile? pickedFile = await _picker.pickImage(source: source);
          setState(() {
            _setImageFileListFromFile(pickedFile);
          });
        } catch (e) {
          setState(() {
            ((e) {
              _pickImageError = e;
            });
          });
        }
      }
    }
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }

    if (_mediaFileList != null) {
      return Semantics(
        label: "Torhi hd",
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            final String? mime = lookupMimeType(_mediaFileList![index].path);
            return Semantics(
              label: 'Torhi image',
              child: kIsWeb
                  ? Image.network(_mediaFileList![index].path)
                  : Row(
                      children: [
                        Image.file(
                          File(_mediaFileList![index].path),
                          errorBuilder: (BuildContext context, Object error,
                              StackTrace? stackTrace) {
                            return const Center(
                              child: Text('This image type is not supported'),
                            );
                          },
                        ),
                        TextButton(
                          onPressed: () {
                            _onImageButtonPressed(
                              ImageSource.gallery,
                              context: context,
                              isMultiImage: false,
                            );
                          },
                          child: const Center(
                            child: Text(
                              'Tap to Change image',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
            );
          },
          itemCount: _mediaFileList!.length,
        ),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return TextButton(
        onPressed: () {
          _onImageButtonPressed(
            ImageSource.gallery,
            context: context,
            isMultiImage: false,
          );
        },
        child: const Center(
          child: Text(
            'Tap to Select a Movie Image',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  final TextEditingController stateController = TextEditingController();
  final MovieBoxCloneApi mockapi = MovieBoxCloneApi();

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.files == null) {
          _setImageFileListFromFile(response.file);
        } else {
          _mediaFileList = response.files;
        }
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  final ImagePicker _picker = ImagePicker();

  dynamic _pickImageError;

  // @override
  // void initState() {
  //   super.initState();

  // }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController movieTitleController = TextEditingController();
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
                Container(
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  height: 200,
                  width: 200,
                  child: FutureBuilder(
                    future: retrieveLostData(),
                    builder:
                        (BuildContext context, AsyncSnapshot<void> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return TextButton(
                            onPressed: () {
                              _onImageButtonPressed(
                                ImageSource.gallery,
                                context: context,
                                isMultiImage: false,
                              );
                            },
                            child: const Center(
                              child: Text(
                                'Tap to Select a Movie Image',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        case ConnectionState.done:
                          return _previewImages();
                        case ConnectionState.active:
                          if (snapshot.hasError) {
                            return Text(
                              'Pick image error: ${snapshot.error}',
                              textAlign: TextAlign.center,
                            );
                          } else {
                            return TextButton(
                              onPressed: () {
                                _onImageButtonPressed(
                                  ImageSource.gallery,
                                  context: context,
                                  isMultiImage: false,
                                );
                              },
                              child: const Center(
                                child: Text(
                                  'Tap to Select a Movie Image',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }
                      }
                    },
                  ),
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
                        "Trending",
                        "Top Picks"
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
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  controller: ratingController,
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
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_mediaFileList != null &&
                            _mediaFileList!.isNotEmpty &&
                            formKey.currentState!.validate()) {
                          try {
                            String filePath = _mediaFileList!.first.path;
                            var uploadedImageUrl =
                                await mockapi.uploadFile(File(filePath));
                            if (!context.mounted) return;

                            await context.read<ProfileManager>().addMovie(
                                  movieTitleController.text,
                                  selectedState!,
                                  uploadedImageUrl,
                                  movieDescriptionController.text,
                                  downloadlinkController.text,
                                  youtubeTrailerlinkController.text,
                                );
                            showsnackBar('upload successfull');
                            if (!context.mounted) return;
                            context.go("/home/2");
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
                          if (_mediaFileList != null &&
                              _mediaFileList!.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MoviePreviewScreen(
                                  movieTitle: movieTitleController.text,
                                  movieDescription:
                                      movieDescriptionController.text,
                                  downloadLink: downloadlinkController.text,
                                  youtubeTrailerLink:
                                      youtubeTrailerlinkController.text,
                                  category: stateController.text,
                                  imagePath: _mediaFileList!.first.path,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select a movie image.'),
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
