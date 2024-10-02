
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torihd/screens/upload/models/episode.dart';
import 'package:torihd/screens/upload/provider/upload_provider.dart';

class EpisodeTile extends StatelessWidget {
  final int seasonIndex;
  final int episodeIndex;
  final EpisodeController episodeData;

  const EpisodeTile({
    super.key,
    required this.seasonIndex,
    required this.episodeIndex,
    required this.episodeData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ExpansionTile(
        key: Key('episode_${episodeData.episodeNumber}'),
        title: _buildEpisodeHeader(),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildEpisodeFields(),
                const SizedBox(height: 16),
                _buildRemoveButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEpisodeHeader() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: episodeData.episodeController,
            decoration: const InputDecoration(
              labelText: 'Episode Number',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter episode number';
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

  Widget _buildEpisodeFields() {
    return Column(
      children: [
        TextFormField(
          controller: episodeData.titleController,
          decoration: const InputDecoration(
            labelText: 'Episode Title',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter episode title';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: episodeData.descriptionController,
          decoration: const InputDecoration(
            labelText: 'Episode Description',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter episode description';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: episodeData.releaseDateController,
          decoration: const InputDecoration(
            labelText: 'Release Date',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter release date';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: episodeData.downloadLinkController,
          decoration: const InputDecoration(
            labelText: 'Download Link',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter download link';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRemoveButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _removeEpisode(context),
      icon: const Icon(Icons.delete),
      label: const Text('Remove Episode'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
      ),
    );
  }

  void _removeEpisode(BuildContext context) {
    context.read<UploadMovieProvider>().removeEpisode(seasonIndex, episodeIndex);
  }
}
