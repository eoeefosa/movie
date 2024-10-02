import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:torihd/models/movie.dart';
import 'package:torihd/provider/movieprovider.dart';
import 'package:torihd/provider/profile_manager.dart';
import 'package:torihd/screens/home/widgets/moviecard.dart';
import 'package:torihd/screens/moviescreen/viewmovies.dart';
import 'package:torihd/screens/moviescreen/widgets/advert_widgets.dart';

class RelatedMovie extends StatelessWidget {
  const RelatedMovie({super.key, required this.movieProvider});


  final MovieProvider movieProvider;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Related Movies",
                    style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
        SizedBox(
          height: Provider.of<ProfileManager>(context).isAdmin ? 320.h : 300.h,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400.w,
              mainAxisSpacing: 10.w,
              childAspectRatio: 5 / 3,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: movieProvider.movies.length,
            itemBuilder: (context, index) {
              final Movie currentmovie = movieProvider.movies[index];
              return InkWell(
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
                child: MovieCard(
                  movie: currentmovie,
                  title: currentmovie.title,
                  imgUrl: currentmovie.movieImgurl,
                  rating: currentmovie.rating,
                  movieid: currentmovie.id!,
                  type: currentmovie.type,
                  youtubeid: currentmovie.youtubetrailer,
                  detail: currentmovie.detail,
                  description: currentmovie.description,
                  source: currentmovie.source,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        const AdvertsWidget(), // Insert Ad Widget here
        const SizedBox(height: 10),
      ],
    );
  }
}
