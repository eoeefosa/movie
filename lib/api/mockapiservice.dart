import 'dart:ffi';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class MovieBoxCloneApi {
  final FirebaseStorage _storage = FirebaseStorage.instance;

 Future<String> uploadFile(File file) async {
  String downloadLink;
  Reference ref = _storage.ref().child("image1${DateTime.now()}");
  UploadTask uploadTask = ref.putFile(file);
  
  TaskSnapshot taskSnapshot = await uploadTask;
  downloadLink = await taskSnapshot.ref.getDownloadURL();
  
  return downloadLink;
}

  final movie = {
    'title': 'Furiosa',
    'title_img': "assets/images/food_cupcake.jpg",
    'series': false,
    'description': "Australia/Action, Adventure, Sci-Fi/2024-05-24/2h 28m",
    'rating': 6.2,
    'downloads': [
      {
        "title": "360p Nowhere",
        "size": 387.2,
        "source": "admin",
        "duration": 250
      },
      {
        "title": "480p Nowhere",
        "size": 587.2,
        "source": "admin",
        "duration": 250
      },
      {
        "title": "1080p Nowhere",
        "size": 587.2,
        "source": "admin",
        "duration": 250
      }
    ]
  };

  Future getmovie() async {
    return movie;
  }

  final downloads = [
    {
      'title': "Grown-ish 360p S01 EP02",
      'size': 46.6,
      'movieImg': "assets/images/food_cupcake.jpg",
      'duration': 22.55 * 60,
      'folder': 'MovieBox'
    },
    {
      'title': "The Flash 360p S01 EP04",
      'movieImg': "assets/images/food_cupcake.jpg",
      'size': 56.6,
      'duration': 22.55 * 60,
      'folder': 'MovieBox'
    }
  ];

  Future getsdownloads() async {
    return downloads;
  }

  final categories = [
    "Trending",
    "Movie",
    "TV/Series",
    // "Music",
    // "ShortTV",
    // "Animation",
    // "Education"
  ];

  Future getMovies() async {
    final carosel = await gettrendingCarosel();
    final content = await getTrendingContent();

    return [carosel, content];
  }

  Future<void> refresh() async {
    getCategories();
  }

  Future<List> getCategories() async {
    return categories;
  }

  final trendingItems = [
    {
      "title": "The Boys Season 4",
      "imgurl": "",
      "bg-color": "white",
      "type": "Free download"
    },
    {
      "title": "The Boys Season 4",
      "imgurl": "",
      "bg-color": "white",
      "type": "Free download"
    },
  ];

  Future getTrending() async {
    final carosel = await gettrendingCarosel();
    final content = await getTrendingContent();

    return [carosel, content];
  }

  final trendingcontent = [
    {
      "Category": "Top Picks",
      "movies": [
        {
          "title": "Kaiju No.8",
          "type": "Japan Anime",
          "img": "assets/images/food_cupcake.jpg",
          "rating": 8.4,
        },
        {
          "title": "The Wife",
          "type": "South Africa crime",
          "img": "assets/images/food_banana.jpg",
          "rating": 8.5,
        },
        {
          "title": "White Collar",
          "type": "United States Comedy",
          "img": "assets/images/food_cupcake.jpg",
          "rating": 8.2,
        },
        {
          "title": "Hercules",
          "type": "United States Action",
          "img": "assets/images/food_brussels_sprouts.jpg",
          "rating": 6.0,
        },
        {
          "title": "DC League of Super-Pets",
          "type": "United States Action",
          "img": "assets/images/food_burger.jpg",
          "rating": 7.1,
        },
        {
          "title": "DC League of Super-Pets",
          "type": "United States Action",
          "img": "assets/images/food_cucumber.jpg",
          "rating": 7.1,
        }
      ]
    },
    {
      "Category": "2024 Popular Movies",
      "type": "Movie",
      "movies": [
        {
          "title": "Kaiju No.8",
          "type": "Japan Anime",
          "img": "assets/images/food_cupcake.jpg",
          "rating": 8.4,
        },
        {
          "title": "The Wife",
          "type": "South Africa crime",
          "img": "assets/images/food_banana.jpg",
          "rating": 8.5,
        },
        {
          "title": "White Collar",
          "type": "United States Comedy",
          "img": "assets/images/food_cupcake.jpg",
          "rating": 8.2,
        },
        {
          "title": "Hercules",
          "type": "United States Action",
          "img": "assets/images/food_brussels_sprouts.jpg",
          "rating": 6.0,
        },
        {
          "title": "DC League of Super-Pets",
          "type": "United States Action",
          "img": "assets/images/food_burger.jpg",
          "rating": 7.1,
        },
        {
          "title": "DC League of Super-Pets",
          "type": "United States Action",
          "img": "assets/images/food_cucumber.jpg",
          "rating": 7.1,
        }
      ]
    },
  ];

  Future getTrendingContent() async {
    return trendingcontent;
  }

  final trendingCarosel = [
    {
      "title": "The Boys season 4",
      "img_url": "assets/images/food_salmon.jpg",
      "ads": false,
      "theme_color": "yellow"
    },
    {
      "title": "The Boys season 4",
      "img_url": "assets/images/food_salmon.jpg",
      "ads": true,
      "theme_color": "yellow"
    },
    {
      "title": "The Boys season 4",
      "img_url": "assets/images/food_salmon.jpg",
      "ads": false,
      "theme_color": "yellow"
    }
  ];
  Future<List> gettrendingCarosel() async {
    return trendingCarosel;
  }
}
