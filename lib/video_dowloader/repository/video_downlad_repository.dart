import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:insta_extractor/insta_extractor.dart';
import 'package:torihd/video_dowloader/data/video_downloader_api.dart';
import 'package:torihd/video_dowloader/models/video_quality_model.dart';

import '../models/video_download_model.dart';

class VideoDownloaderRepository {
  VideoDownloaderAPI api = VideoDownloaderAPI(
    apiKey: "pleasereplaceitwithyourownapikeyrespectthework",
  );

  Future<VideoDownloadModel?> getAvailableYTVideos(String url) async {
    try {
      var response = await api.getYouTubeVideoLinks(url);

      if (response.statusCode == 200) {
        var result = Map.from(jsonDecode(response.body));

        List<VideoQualityModel> links = [];

        for (var _link in result['url']) {
          if (_link["ext"] == "mp4" && _link["downloadable"] == true) {
            links.add(VideoQualityModel.fromMap({
              "url": _link['url'],
              "quality": _link['quality'],
            }));
          }
        }

        return VideoDownloadModel.fromMap({
          "title": result['meta']['title'],
          "source": result['meta']['source'],
          "thumbnail": result['thumb'],
          "videos": links,
        });
      } else {
        return null;
      }
    } on Exception catch (e) {
      debugPrint("Exception occured $e");
      return null;
    }
  }

  Future<VideoDownloadModel?> getAvailableFBVideos(String url) async {
    try {
      var response = await api.getFacebookVideoLinks(url);

      if (response.statusCode == 200) {
        var result = Map.from(jsonDecode(response.body));

        List<VideoQualityModel> links = [];

        for (var _link in result['url']) {
          if (_link["ext"] == "mp4") {
            links.add(VideoQualityModel.fromMap({
              "url": _link['url'],
              "quality": _link['subname'],
            }));
          }
        }

        return VideoDownloadModel.fromMap({
          "title": result['meta']['title'],
          "source": result['meta']['source'],
          "thumbnail": result['thumb'],
          "videos": links,
        });
      } else {
        return null;
      }
    } on Exception catch (e) {
      debugPrint("Exception occured $e");
      return null;
    }
  }

  Future<VideoDownloadModel?> getAvailableTWVideos(String url) async {
    try {
      var response = await api.getTwitterVideoLinks(url);

      if (response.statusCode == 200) {
        var result = Map.from(jsonDecode(response.body));

        List<VideoQualityModel> links = [];

        for (var _link in result['url']) {
          if (_link["ext"] == "mp4") {
            links.add(VideoQualityModel.fromMap({
              "url": _link['url'],
              "quality": _link['quality'].toString(),
            }));
          }
        }

        return VideoDownloadModel.fromMap({
          "title": result['meta']['title'],
          "source": result['meta']['source'],
          "thumbnail": result['thumb'],
          "videos": links,
        });
      } else {
        return null;
      }
    } on Exception catch (e) {
      debugPrint("Exception occured $e");
      return null;
    }
  }

  Future<VideoDownloadModel?> getAvailableIGVideos(String url) async {
    try {
      // InstagramData response = await InstaExtractor.getDetails(url);
      //  var _response = await InstaExtractor.getDetails(url);

      // if (_response.shortcodeMedia.content.isVideo) {
      //   return VideoDownloadModel.fromJson({
      //     "title": _response.shortcodeMedia.owner.username,
      //     "source": url,
      //     "thumbnail": _response.shortcodeMedia.content.displayUrl,
      //     "videos": [
      //       VideoQualityModel(
      //         url: _response.shortcodeMedia.content.videoUrl,
      //         quality: "720",
      //       )
      //     ],
      //   });
      // } else {

      // if (response.videoUrls != null) {
      //   return VideoDownloadModel.fromMap({
      //     "title": response.user!.username,
      //     "source": url,
      //     "thumbnail": response.user!.profilePicUrl,
      //     "videos": [
      //       VideoQualityModel(
      //         url: response.videoUrls!.first.url,
      //         quality: "720",
      //       )
      //     ],
      //   });
      // } else {
        return null;
      // }
    } on Exception catch (e) {
      debugPrint("Exception occured $e");
      return null;
    }
  }
}

enum VideoType { youtube, facebook, twitter, instagram, none }
