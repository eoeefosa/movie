import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torihd/screens/upload/models/season.dart';
import 'package:torihd/screens/upload/provider/upload_provider.dart';
import 'package:torihd/screens/upload/widget/episode_tile.dart';

class SeasonTile extends StatelessWidget {
  final int seasonIndex;
  final SeasonController seasonData;

  const SeasonTile({
    super.key,
    required this.seasonIndex,
    required this.seasonData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ExpansionTile(
        key: Key('season_${seasonData.seasonNumber}'),
        title: _buildSeasonHeader(),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildEpisodesList(),
                const SizedBox(height: 16),
                _buildActionButtons(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeasonHeader() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: seasonData.seasonController,
            decoration: const InputDecoration(
              labelText: 'Season Number',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter season number';
              }
              if (int.tryParse(value!) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEpisodesList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: seasonData.episodes.length,
      itemBuilder: (context, index) => EpisodeTile(
        seasonIndex: seasonIndex,
        episodeIndex: index,
        episodeData: seasonData.episodes[index],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () => _addEpisode(context),
          icon: const Icon(Icons.add),
          label: const Text('Add Episode'),
        ),
        ElevatedButton.icon(
          onPressed: () => _removeSeason(context),
          icon: const Icon(Icons.delete),
          label: const Text('Remove Season'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
        ),
      ],
    );
  }

  void _addEpisode(BuildContext context) {
    context.read<UploadMovieProvider>().addEpisode(seasonIndex);
  }

  void _removeSeason(BuildContext context) {
    context.read<UploadMovieProvider>().removeSeason(seasonIndex);
  }
}
