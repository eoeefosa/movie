// import 'package:flutter/material.dart';
// import 'package:torihd/models/movie.dart';
// import 'package:torihd/models/season.dart';
// import 'package:torihd/screens/upload/previewmovie.dart';
// import 'package:torihd/styles/snack_bar.dart';
// import 'package:provider/provider.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// import '../../provider/profile_manager.dart';

// class UploadMovie extends StatefulWidget {
//   const UploadMovie({
//     super.key,
//     this.imageUrl,
//     this.title,
//     this.type,
//     this.rating,
//     this.detail,
//     this.description,
//     this.downloadlink,
//     this.youtubelink,
//     this.source,
//     this.country,
//     this.cast,
//     this.releasedate,
//     this.language,
//     this.tags,
//     this.id,
//     this.movie,
//     this.seasons,
//   });

//   final String? imageUrl;
//   final String? title;
//   final String? type;
//   final String? rating;
//   final String? detail;
//   final String? description;
//   final String? downloadlink;
//   final String? youtubelink;
//   final String? source;
//   final String? country;
//   final String? cast;
//   final String? releasedate;
//   final String? language;
//   final String? tags;
//   final String? id;
//   final Movie? movie;
//   final List<Map<String, dynamic>>? seasons;

//   @override
//   State<UploadMovie> createState() => _UploadMovieState();
// }

// class _UploadMovieState extends State<UploadMovie> {
//   String? _retrieveDataError;
//   String? selectedState = "Movie";

//   final TextEditingController stateController = TextEditingController();

//   static String convertIdToUrl(String? id,
//       {bool trimWhitespaces = true,
//       String format = "https://www.youtube.com/watch?v="}) {
//     if (id == null) {
//       return '';
//     }
//     if (trimWhitespaces) id = id.trim();

//     // Check if the ID is valid (11 characters long and contains valid characters)
//     if (id.length == 11 && RegExp(r"^[\w\-]+$").hasMatch(id)) {
//       return format + id;
//     }

//     return '';
//   }

//   final formKey = GlobalKey<FormState>();
//   final TextEditingController movieTitleController = TextEditingController();
//   final TextEditingController movieImageUrl = TextEditingController();
//   final TextEditingController detailsController = TextEditingController();
//   final TextEditingController ratingController = TextEditingController();
//   final TextEditingController movieDescriptionController =
//       TextEditingController();
//   final TextEditingController downloadlinkController = TextEditingController();
//   final TextEditingController youtubeTrailerlinkController =
//       TextEditingController();
//   final TextEditingController sourceController = TextEditingController();
//   final TextEditingController countryController = TextEditingController();
//   final TextEditingController castController = TextEditingController();
//   final TextEditingController releasedateController = TextEditingController();
//   final TextEditingController languageController = TextEditingController();
//   final TextEditingController tagsController = TextEditingController();
//   final List<TextEditingController> controllers = [];
//   List<Map<String, dynamic>> seasons = [];

//   @override
//   void initState() {
//     super.initState();
//     // Initialize the seasons list with one season if empty
//     if (widget.seasons != null) {
//       seasons = widget.seasons!;
//     }
//     if (seasons.isEmpty) {
//       _addInitialSeason();
//     }
//   }

//   @override
//   void dispose() {
//     for (var controller in controllers) {
//       controller.dispose();
//     }
//     // Dispose all controllers when the widget is removed
//     for (var season in seasons) {
//       season["seasonController"].dispose();
//       for (var episode in season["episodes"]) {
//         episode["episodeController"].dispose();
//         episode["linkController"].dispose();
//       }
//     }
//     super.dispose();
//   }

//   void addLinkField() {
//     setState(() {
//       controllers.add(TextEditingController());
//     });
//   }

//   void removeLinkField(int index) {
//     setState(() {
//       controllers[index].dispose();
//       controllers.removeAt(index);
//     });
//   }

//   void submit() {
//     if (formKey.currentState!.validate()) {
//       formKey.currentState?.save();
//       // Perform the login action here, e.g., send the email and password to your server
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text('Logging in...')));
//     }
//   }

//   final ProfileManager userProfile = ProfileManager();

//   @override
//   Widget build(BuildContext context) {
//     movieTitleController.text = widget.title ?? '';
//     movieImageUrl.text = widget.imageUrl ?? '';
//     detailsController.text = widget.detail ?? '';
//     ratingController.text = widget.rating ?? '';
//     movieDescriptionController.text = widget.description ?? '';
//     downloadlinkController.text = widget.downloadlink ?? '';
//     youtubeTrailerlinkController.text = widget.youtubelink ?? '';
//     final newlink = convertIdToUrl(youtubeTrailerlinkController.text);
//     youtubeTrailerlinkController.text = newlink;
//     sourceController.text = widget.movie?.source ?? '';
//     countryController.text = widget.movie?.country ?? '';
//     castController.text = widget.movie?.cast?.join(', ') ?? '';
//     releasedateController.text = widget.movie?.releasedate ?? '';
//     languageController.text = widget.movie?.language?.join(', ') ?? '';
//     tagsController.text = widget.movie?.tags?.join(', ') ?? '';

//     return Scaffold(
//       appBar: AppBar(
//         title: widget.title == null
//             ? const Text("Movie upload")
//             : const Text("Edit Movie"),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 Provider.of<ProfileManager>(context, listen: false)
//                     .toggleDarkmode();
//                 // setState(() {});
//               },
//               icon: Icon(
//                 Provider.of<ProfileManager>(context).themeMode ==
//                         ThemeModeType.light
//                     ? Icons.light_mode
//                     : Provider.of<ProfileManager>(context).themeMode ==
//                             ThemeModeType.dark
//                         ? Icons.dark_mode
//                         : Icons.brightness_auto, // For system theme mode
//                 color: Colors.yellow.shade700,
//               ))
//         ],
//       ),
//       body: Form(
//         key: formKey,
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: movieImageUrl,
//                   decoration: const InputDecoration(
//                     labelText: 'Movie Image Url',
//                     border: OutlineInputBorder(
//                         // borderSide: Border.al
//                         ),
//                   ),
//                   keyboardType: TextInputType.url,
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Please enter the movie image url';
//                     }
//                     return null;
//                   },
//                   // onSaved: (value) => movieTitle = value!,
//                 ),
//                 const SizedBox(height: 8.0),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text("Type"),
//                     DropdownButton<String>(
//                       value: selectedState,
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           selectedState = newValue!;
//                         });
//                       },
//                       items: <String>[
//                         "Movie",
//                         "TV series",
//                       ].map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8.0),
//                 TextFormField(
//                   controller: movieTitleController,
//                   decoration: const InputDecoration(
//                     labelText: 'Movie Title',
//                     border: OutlineInputBorder(
//                         // borderSide: Border.al
//                         ),
//                   ),
//                   keyboardType: TextInputType.text,
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Please enter the movie Title';
//                     }
//                     return null;
//                   },
//                   // onSaved: (value) => movieTitle = value!,
//                 ),
//                 const SizedBox(height: 8.0),
//                 TextFormField(
//                   controller: ratingController,
//                   decoration: const InputDecoration(
//                     labelText: 'Movie rating',
//                     border: OutlineInputBorder(
//                         // borderSide: Border.al
//                         ),
//                   ),
//                   keyboardType: TextInputType.number,
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Please enter the movie rating';
//                     }
//                     return null;
//                   },
//                   // onSaved: (value) => movieTitle = value!,
//                 ),
//                 const SizedBox(
//                   height: 8.0,
//                 ),
//                 TextFormField(
//                   maxLines: 2,
//                   controller: detailsController,
//                   decoration: const InputDecoration(
//                     labelText: 'Movie detail',
//                     hintText:
//                         "e.g Australia/Action, Adventure, Sci-Fi/2024-05-24/2h 28m",
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.text,
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Please enter the movie Title';
//                     }
//                     return null;
//                   },
//                   // onSaved: (value) => movieTitle = value!,
//                 ),
//                 const Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Text(
//                       "e.g Australia/Action, Adventure, Sci-Fi/2024-05-24/2h 28m",
//                       style: TextStyle(fontSize: 10),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 8.0,
//                 ),
//                 TextFormField(
//                   controller: movieDescriptionController,
//                   maxLines: 9,
//                   decoration: const InputDecoration(
//                     // labelText: 'Movie Description',
//                     hintText: 'Movie Description',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.text,
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Please enter the movie Description';
//                     }

//                     return null;
//                   },
//                   // onSaved: (value) => movieDescription = value!,
//                 ),

//                 selectedState == "TV series"
//                     ? Container()
//                     : const SizedBox(height: 16.0),

//                 selectedState == "TV series"
//                     ? Container()
//                     : TextFormField(
//                         controller: downloadlinkController,
//                         decoration: const InputDecoration(
//                           labelText: 'Download link',
//                           border: OutlineInputBorder(),
//                         ),
//                         keyboardType: TextInputType.text,
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter the Download Link';
//                           }

//                           return null;
//                         },
//                         // onSaved: (value) => downloadlink = value!,
//                       ),
//                 const SizedBox(height: 16.0),
//                 TextFormField(
//                   controller: youtubeTrailerlinkController,
//                   decoration: const InputDecoration(
//                     labelText: 'Youtube Trailer link',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.text,
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Please enter the Youtube Trailer Link';
//                     }

//                     return null;
//                   },
//                   // onSaved: (value) => youtubeTrailerLink = value!,
//                 ),
//                 const SizedBox(height: 16.0),
//                 TextFormField(
//                   controller: sourceController,
//                   decoration: const InputDecoration(
//                     labelText: 'Source',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.text,

//                   // onSaved: (value) => youtubeTrailerLink = value!,
//                 ),
//                 const SizedBox(height: 8.0),
//                 TextFormField(
//                   controller: countryController,
//                   decoration: const InputDecoration(
//                     labelText: 'Country',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.text,

//                   // onSaved: (value) => youtubeTrailerLink = value!,
//                 ),
//                 const SizedBox(height: 8.0),
//                 TextFormField(
//                   controller: castController,
//                   decoration: const InputDecoration(
//                     labelText: 'cast(separated by commas)',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.text,

//                   // onSaved: (value) => youtubeTrailerLink = value!,
//                 ),
//                 const SizedBox(height: 8.0),
//                 TextFormField(
//                   controller: releasedateController,
//                   decoration: const InputDecoration(
//                     labelText: 'Release date',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.datetime,

//                   // onSaved: (value) => youtubeTrailerLink = value!,
//                 ),
//                 const SizedBox(height: 8.0),
//                 TextFormField(
//                   controller: languageController,
//                   decoration: const InputDecoration(
//                     labelText: 'Language(s) separate by comma if multiple',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.text,

//                   // onSaved: (value) => youtubeTrailerLink = value!,
//                 ),
//                 const SizedBox(height: 8.0),
//                 TextFormField(
//                   controller: tagsController,
//                   decoration: const InputDecoration(
//                     labelText: 'Tags(seperated by commas)',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.text,

//                   // onSaved: (value) => youtubeTrailerLink = value!,
//                 ),
//                 const SizedBox(height: 8.0),
//                 selectedState == "TV series"
//                     ? const Text('Seasons:',
//                         style: TextStyle(fontWeight: FontWeight.bold))
//                     : Container(),
//                 selectedState == "TV series"
//                     ? ListView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: seasons.length,
//                         itemBuilder: (context, index) {
//                           return _buildSeasonTile(index);
//                         },
//                       )
//                     : Container(),
//                 selectedState == "TV series"
//                     ? const SizedBox(height: 10)
//                     : Container(),
//                 selectedState == "TV series"
//                     ? ElevatedButton(
//                         onPressed: _addSeason,
//                         child: const Text("Add Season"),
//                       )
//                     : Container(),
//                 const SizedBox(height: 16.0),
//                 // Inside your button logic where you handle the upload:
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () async {
//                         if (formKey.currentState!.validate()) {
//                           try {
//                             if (!context.mounted) return;

//                             // Check if we're uploading a TV series or a movie
//                             if (selectedState == "TV series") {
//                               // TV Series logic

//                               // Get YouTube Video ID
//                               String? videoId = YoutubePlayer.convertUrlToId(
//                                 youtubeTrailerlinkController.text,
//                               );

//                               // Prepare Seasons and Episodes for TV series
//                               List<Season> seasonList = [];
//                               for (var season in seasons) {
//                                 List<Episode> episodeList = [];
//                                 for (var episode in season['episodes']) {
//                                   // Assume we collect episode details from TextEditingControllers
//                                   episodeList.add(
//                                     Episode(
//                                       episodeNumber:
//                                           episode["episodeNumber"].toString(),
//                                       title: episode["titleController"].text,
//                                       description:
//                                           episode["descriptionController"].text,
//                                       releaseDate:
//                                           episode["releaseDateController"].text,
//                                       downloadLinks: [
//                                         DownloadLink(
//                                           url: episode["downloadLinkController"]
//                                               .text,
//                                           downloadLinkExpiration:
//                                               null, // Add if necessary
//                                         )
//                                       ],
//                                     ),
//                                   );
//                                 }

//                                 seasonList.add(
//                                   Season(
//                                     seasonNumber: season['seasonNumber'],
//                                     episodes: episodeList,
//                                   ),
//                                 );
//                               }

//                               // Create TVSeries object
//                               final uploadSeries = Movie(
//                                 id: widget.id ?? '',
//                                 type: selectedState!,
//                                 movieImgurl: movieImageUrl.text,
//                                 youtubetrailer:
//                                     youtubeTrailerlinkController.text,
//                                 title: movieTitleController.text,
//                                 rating: ratingController.text,
//                                 description: movieDescriptionController.text,
//                                 source: sourceController.text,
//                                 country: countryController.text,
//                                 cast: castController.text
//                                     .split(',')
//                                     .map((e) => e.trim())
//                                     .toList(),
//                                 language: languageController.text
//                                     .split(',')
//                                     .map((e) => e.trim())
//                                     .toList(),
//                                 tags: tagsController.text
//                                     .split(',')
//                                     .map((e) => e.trim())
//                                     .toList(),
//                                 seasons: seasonList,
//                                 detail: detailsController.text,
//                               );

//                               // Call the appropriate function to upload the series
//                               if (widget.title == null) {
//                                 await context
//                                     .read<ProfileManager>()
//                                     .addMovie(uploadSeries);
//                                 showsnackBar('TV series upload successful');
//                               } else {
//                                 await context
//                                     .read<ProfileManager>()
//                                     .updateMovie(uploadSeries);
//                                 showsnackBar('TV series updated successfully');
//                               }
//                             } else {
//                               // Movie logic as before
//                               String? videoId = widget.title == null
//                                   ? YoutubePlayer.convertUrlToId(
//                                       youtubeTrailerlinkController.text)
//                                   : youtubeTrailerlinkController.text == newlink
//                                       ? widget.youtubelink
//                                       : YoutubePlayer.convertUrlToId(
//                                           youtubeTrailerlinkController.text);

//                               final uploadmovie = Movie(
//                                 movieImgurl: movieImageUrl.text,
//                                 type: selectedState!,
//                                 title: movieTitleController.text,
//                                 rating: ratingController.text,
//                                 detail: detailsController.text,
//                                 description: movieDescriptionController.text,
//                                 downloadlink: downloadlinkController.text,
//                                 id: widget.movie?.id,
//                                 youtubetrailer: videoId ?? '',
//                                 source: sourceController.text,
//                                 country: countryController.text,
//                                 cast: castController.text
//                                     .split(',')
//                                     .map((e) => e.trim())
//                                     .toList(),
//                                 releasedate: releasedateController.text,
//                                 language: languageController.text
//                                     .split(',')
//                                     .map((e) => e.trim())
//                                     .toList(),
//                                 tags: tagsController.text
//                                     .split(',')
//                                     .map((e) => e.trim())
//                                     .toList(),
//                               );

//                               if (widget.title == null) {
//                                 await context
//                                     .read<ProfileManager>()
//                                     .addMovie(uploadmovie);
//                                 showsnackBar('Movie upload successful');
//                               } else {
//                                 await context
//                                     .read<ProfileManager>()
//                                     .updateMovie(uploadmovie);
//                                 showsnackBar('Movie updated successfully');
//                               }
//                             }

//                             if (!context.mounted) return;
//                             Navigator.pop(context);
//                           } catch (e) {
//                             showsnackBar('Failed to upload: $e');
//                           }
//                         }
//                       },
//                       child: selectedState == "TV series"
//                           ? const Text('Upload TV Series')
//                           : const Text('Upload Movie'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         // Preview button can remain similar, with logic to show either a movie or TV series preview
//                         if (formKey.currentState!.validate()) {
//                           if (movieImageUrl.text != '') {
//                             if (!context.mounted) return;
//                             String? videoId = YoutubePlayer.convertUrlToId(
//                                 youtubeTrailerlinkController.text);

//                             if (selectedState == "TV series") {
//                               // Prepare TV Series preview
//                               List<Season> seasonList = [];
//                               for (var season in seasons) {
//                                 List<Episode> episodeList = [];
//                                 for (var episode in season['episodes']) {
//                                   episodeList.add(
//                                     Episode(
//                                       episodeNumber:
//                                           episode["episodeNumber"].toString(),
//                                       title: episode["titleController"].text,
//                                       description:
//                                           episode["descriptionController"].text,
//                                       releaseDate:
//                                           episode["releaseDateController"].text,
//                                       downloadLinks: [
//                                         DownloadLink(
//                                           url: episode["downloadLinkController"]
//                                               .text,
//                                           downloadLinkExpiration: null,
//                                         )
//                                       ],
//                                     ),
//                                   );
//                                 }

//                                 seasonList.add(
//                                   Season(
//                                     seasonNumber: season['seasonNumber'],
//                                     episodes: episodeList,
//                                   ),
//                                 );
//                               }

//                               final previewSeries = Movie(
//                                 id: widget.id ?? '',
//                                 type: selectedState!,
//                                 movieImgurl: movieImageUrl.text,
//                                 youtubetrailer:
//                                     youtubeTrailerlinkController.text,
//                                 title: movieTitleController.text,
//                                 rating: ratingController.text,
//                                 description: movieDescriptionController.text,
//                                 source: sourceController.text,
//                                 country: countryController.text,
//                                 cast: castController.text
//                                     .split(',')
//                                     .map((e) => e.trim())
//                                     .toList(),
//                                 language: languageController.text
//                                     .split(',')
//                                     .map((e) => e.trim())
//                                     .toList(),
//                                 tags: tagsController.text
//                                     .split(',')
//                                     .map((e) => e.trim())
//                                     .toList(),
//                                 seasons: seasonList,
//                                 detail: detailsController.text,
//                               );

//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       MoviePreviewScreen(movie: previewSeries),
//                                 ),
//                               );
//                             } else {
//                               // Movie preview logic
//                               final uploadmovie = Movie(
//                                 movieImgurl: movieImageUrl.text,
//                                 type: selectedState!,
//                                 title: movieTitleController.text,
//                                 rating: ratingController.text,
//                                 detail: detailsController.text,
//                                 description: movieDescriptionController.text,
//                                 downloadlink: downloadlinkController.text,
//                                 id: widget.id ?? "",
//                                 youtubetrailer: videoId ?? '',
//                                 source: sourceController.text,
//                                 country: countryController.text,
//                                 cast: castController.text
//                                     .split(',')
//                                     .map((e) => e.trim())
//                                     .toList(),
//                                 releasedate: releasedateController.text,
//                                 language: languageController.text
//                                     .split(',')
//                                     .map((e) => e.trim())
//                                     .toList(),
//                                 tags: tagsController.text
//                                     .split(',')
//                                     .map((e) => e.trim())
//                                     .toList(),
//                               );

//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       MoviePreviewScreen(movie: uploadmovie),
//                                 ),
//                               );
//                             }
//                           } else {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content:
//                                     Text('Please select a movie image url.'),
//                               ),
//                             );
//                           }
//                         }
//                       },
//                       child: const Text('Preview'),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16.0),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Add Initial Season logic
//   void _addInitialSeason() {
//     setState(() {
//       // Add the first season with season number 1 and an empty episodes list
//       seasons.add({
//         "seasonNumber": 1,
//         "seasonController": TextEditingController(text: '1'),
//         "episodes": <Map<String, dynamic>>[]
//       });
//     });
//   }

//   // Add Season button logic
//   void _addSeason() {
//     setState(() {
//       // Add a new season with a new season number and an empty episodes list
//       int seasonNumber = seasons.length + 1;
//       seasons.add({
//         "seasonNumber": seasonNumber,
//         "seasonController":
//             TextEditingController(text: seasonNumber.toString()),
//         "episodes": <Map<String, dynamic>>[]
//       });
//     });
//   }

//   // Remove Season logic
//   void _removeSeason(int index) {
//     setState(() {
//       if (seasons.length > 1) {
//         // Remove the TextEditingController when removing the season
//         seasons[index]["seasonController"].dispose();
//         for (var episode in seasons[index]["episodes"]) {
//           episode["episodeController"].dispose();
//           episode["linkController"].dispose();
//         }
//         seasons.removeAt(index); // Remove the season at the provided index
//       } else {
//         // Ensure at least one season exists
//         seasons.clear();
//         _addInitialSeason();
//       }
//     });
//   }

//   // Add Episode button logic for a specific season
//   void _addEpisode(int seasonIndex) {
//     setState(() {
//       int episodeNumber = seasons[seasonIndex]["episodes"].length + 1;
//       seasons[seasonIndex]["episodes"].add({
//         "episodeNumber": episodeNumber,
//         "episodeController":
//             TextEditingController(text: episodeNumber.toString()),
//         "linkController":
//             TextEditingController(), // Controller for download link
//         "widget": _buildEpisodeTile(seasonIndex, episodeNumber)
//       });
//     });
//   }

//   // Remove Episode logic for a specific season
//   void _removeEpisode(int seasonIndex, int episodeIndex) {
//     setState(() {
//       if (seasons[seasonIndex]["episodes"].length > 1) {
//         // Dispose of the controllers for the episode being removed
//         seasons[seasonIndex]["episodes"][episodeIndex]["episodeController"]
//             .dispose();
//         seasons[seasonIndex]["episodes"][episodeIndex]["linkController"]
//             .dispose();
//         seasons[seasonIndex]["episodes"].removeAt(episodeIndex);
//       }
//     });
//   }

//   // Build each season's collapsible tile
//   Widget _buildSeasonTile(int seasonIndex) {
//     var seasonData = seasons[seasonIndex];
//     int seasonNumber = seasonData["seasonNumber"];
//     List<Map<String, dynamic>> episodes = seasonData["episodes"];
//     TextEditingController seasonController = seasonData["seasonController"];

//     return ExpansionTile(
//       key: Key("season_$seasonNumber"), // Unique key for each tile
//       title: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               keyboardType: TextInputType.number,
//               controller: seasonController,
//               decoration: const InputDecoration(labelText: 'Season Number'),
//               onSubmitted: (value) {
//                 setState(() {
//                   seasonData["seasonNumber"] =
//                       int.tryParse(value) ?? seasonNumber;
//                 });
//               },
//             ),
//           ),
//         ],
//       ),
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               // Display all the episodes for this season
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: episodes.length,
//                 itemBuilder: (context, index) {
//                   return episodes[index]["widget"];
//                 },
//               ),
//               const SizedBox(height: 10.0),
//               ElevatedButton(
//                 onPressed: () => _addEpisode(seasonIndex), // Add new episode
//                 child: const Text('Add Episode'),
//               ),
//               ElevatedButton(
//                 onPressed: () =>
//                     _removeSeason(seasonIndex), // Remove this season
//                 child: const Text('Remove Season'),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // Build each episode's collapsible tile with editable episode number and download link
//   Widget _buildEpisodeTile(int seasonIndex, int episodeNumber) {
//     // var episodeData = seasons[seasonIndex]["episodes"]
//     //     .firstWhere((e) => e["episodeNumber"] == episodeNumber);
//     var episodeData = seasons[seasonIndex]["episodes"].firstWhere(
//         (e) => e["episodeNumber"] == episodeNumber,
//         orElse: () => seasons[seasonIndex]["episodes"].firstWhere(
//             (e) => e[0] == episodeNumber) // Return null if no match is found
//         );

//     TextEditingController episodeController = episodeData["episodeController"];
//     TextEditingController linkController = episodeData["linkController"];

//     return ExpansionTile(
//       key: Key(
//           "season_${seasons[seasonIndex]['seasonNumber']}_episode_$episodeNumber"), // Unique key for each episode
//       title: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               keyboardType: TextInputType.number,
//               controller: episodeController,
//               decoration: const InputDecoration(labelText: 'Episode Number'),
//               onSubmitted: (value) {
//                 setState(() {
//                   int newEpisodeNumber = int.tryParse(value) ?? episodeNumber;
//                   episodeData["episodeNumber"] = newEpisodeNumber;
//                 });
//               },
//             ),
//           ),
//         ],
//       ),
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               // TextField for Download Link
//               TextField(
//                 controller: linkController,
//                 decoration: const InputDecoration(
//                   labelText: 'Download Link',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 8.0),
//               ElevatedButton(
//                 onPressed: () => _removeEpisode(
//                     seasonIndex, episodeNumber - 1), // Remove this episode
//                 child: const Text('Remove Episode'),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
