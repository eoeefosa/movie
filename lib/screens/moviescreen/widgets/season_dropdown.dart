import 'package:flutter/material.dart';
import 'package:torihd/models/movie.dart';
import 'package:torihd/models/season.dart';

class SeasonDropdown extends StatelessWidget {
  final Movie tvSeries;
  final int selectedSeason;
  final Function(int) onSeasonSelected;

  const SeasonDropdown({
    required this.tvSeries,
    required this.selectedSeason,
    required this.onSeasonSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: selectedSeason,
      onChanged: (int? newValue) {
        if (newValue != null) {
          onSeasonSelected(newValue);
        }
      },
      items: tvSeries.seasons!
          .map<DropdownMenuItem<int>>((Season season) => DropdownMenuItem<int>(
                value: season.seasonNumber,
                child: Text("Season ${season.seasonNumber}"),
              ))
          .toList(),
    );
  }
}
