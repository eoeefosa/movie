
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:torihd/provider/movieprovider.dart';

class MovieDetails extends StatelessWidget {
  const MovieDetails({
    super.key,
    required this.movieProvider,
  });

  final MovieProvider movieProvider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            movieProvider.currentmovieinfo?.title ?? "Error",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
          ),
          const SizedBox(height: 10),
          Text(
            movieProvider.currentmovieinfo?.description ?? "No description",
            style: TextStyle(fontSize: 16.sp),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
