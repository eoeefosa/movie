
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:torihd/provider/movieprovider.dart';
import 'package:torihd/screens/moviescreen/widgets/detailcard.dart';

class MovieMetadata extends StatelessWidget {
  const MovieMetadata({
    super.key, required this.movieProvider,
  });

  final MovieProvider movieProvider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        height: 250.h,
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(),
            1: FlexColumnWidth(),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.top,
          children: [
            TableRow(
              children: [
                const Text("Type"),
                Text(
                  movieProvider.currentmovieinfo?.type ?? "Unknown",
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
            TableRow(
              children: [
                const Text("Release Date"),
                Text(
                  movieProvider.currentmovieinfo?.releasedate ??
                      "Unknown",
                ),
              ],
            ),
            TableRow(
              children: [
                const Text("Country"),
                Text(
                  movieProvider.currentmovieinfo?.country ?? "Unknown",
                ),
              ],
            ),
            TableRow(
              children: [
                const Text("Language"),
                Wrap(
                  alignment: WrapAlignment.start,
                  children:
                      movieProvider.currentmovieinfo?.language?.map(
                            (e) {
                              return DetailCard(
                                title: e,
                              );
                            },
                          ).toList() ??
                          [
                            "English",
                          ].map(
                            (e) {
                              return DetailCard(
                                title: e,
                              );
                            },
                          ).toList(),
                ),
              ],
            ),
            TableRow(
              children: [
                const Text("Source"),
                Text(movieProvider.currentmovieinfo?.source ??
                    "Unknown"),
              ],
            ),
            TableRow(
              children: [
                const Text("Genre"),
                Text(
                  movieProvider.currentmovieinfo?.genre ?? "Unknown",
                ),
              ],
            ),
            TableRow(
              children: [
                const Text("Cast"),
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: movieProvider.currentmovieinfo?.cast?.map(
                        (e) {
                          return DetailCard(
                            title: e,
                          );
                        },
                      ).toList() ??
                      [
                        "Unknown",
                      ].map(
                        (e) {
                          return DetailCard(
                            title: e,
                          );
                        },
                      ).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
