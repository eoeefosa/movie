import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torihd/screens/upload/models/episode.dart';
import 'package:torihd/screens/upload/models/season.dart';
import 'package:torihd/screens/upload/provider/upload_provider.dart';
import 'package:torihd/screens/upload/widget/seasontile.dart';

class SeasonsList extends StatelessWidget {
  const SeasonsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UploadMovieProvider>(
      builder: (context, provider, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Seasons:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.seasons.length,
            itemBuilder: (context, index) => SeasonTile(
              seasonIndex: index,
              seasonData: provider.seasons[index],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton.icon(
              onPressed: provider.addSeason,
              icon: const Icon(Icons.add),
              label: const Text('Add Season'),
            ),
          ),
        ],
      ),
    );
  }
}
