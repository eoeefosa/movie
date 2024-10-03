import 'package:flutter/material.dart';
import 'package:torihd/models/movie.dart';
import 'package:torihd/models/season.dart';

class SeasonDropdown extends StatelessWidget {
  final Movie tvSeries;
  final int? selectedSeason; // Allow selectedSeason to be nullable
  final Function(int) onSeasonSelected;

  const SeasonDropdown({
    required this.tvSeries,
    required this.selectedSeason,
    required this.onSeasonSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Build the list of DropdownMenuItems from the seasons
    List<DropdownMenuItem<int>> seasonItems = tvSeries.seasons!
        .map<DropdownMenuItem<int>>((Season season) => DropdownMenuItem<int>(
              value: season.seasonNumber,
              child: Text("Season ${season.seasonNumber}"),
            ))
        .toList();

    // Ensure selectedSeason is valid within the seasonItems
    int? validSelectedSeason = selectedSeason;

    // Handle conflicting or invalid selectedSeason
    if (selectedSeason == null ||
        !seasonItems.any((item) => item.value == selectedSeason)) {
      if (seasonItems.isNotEmpty) {
        validSelectedSeason =
            seasonItems.first.value; // Default to first season
      } else {
        validSelectedSeason = null; // No valid seasons
      }
    }

    return DropdownButton<int>(
      value: validSelectedSeason,
      onChanged: (int? newValue) {
        if (newValue != null) {
          onSeasonSelected(newValue);
        }
      },
      items: seasonItems,
    );
  }
}
