import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torihd/screens/upload/provider/upload_provider.dart';
import 'package:torihd/screens/upload/widget/custom_form_field.dart';

class MovieFormFields extends StatelessWidget {
  const MovieFormFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UploadMovieProvider>(
      builder: (context, provider, _) => Column(
        children: [
          _buildImageField(provider),
          const SizedBox(height: 8.0),
          _buildTypeDropdown(provider),
          const SizedBox(height: 8.0),
          _buildBasicFields(provider),
          if (provider.selectedType != "TV series")
            _buildDownloadLinkField(provider),
          _buildAdditionalFields(provider),
        ],
      ),
    );
  }

  Widget _buildImageField(UploadMovieProvider provider) {
    return CustomTextField(
      controller: provider.controllers['movieImage']!,
      label: 'Movie Image Url',
      keyboardType: TextInputType.url,
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'Please enter a movie image URL';
        }
        return null;
      },
    );
  }

  Widget _buildTypeDropdown(UploadMovieProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Type",
            style: TextStyle(fontSize: 16),
          ),
          DropdownButton<String>(
            value: provider.selectedType,
            onChanged: (String? newValue) {
              if (newValue != null) {
                provider.setType(newValue);
              }
            },
            items: ["Movie", "TV series"]
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicFields(UploadMovieProvider provider) {
    return Column(
      children: [
        CustomTextField(
          controller: provider.controllers['movieTitle']!,
          label: 'Movie Title',
          validator: (value) => _requiredFieldValidator(value, 'title'),
        ),
        CustomTextField(
          controller: provider.controllers['rating']!,
          label: 'Movie Rating',
          keyboardType: TextInputType.number,
          validator: (value) => _ratingValidator(value),
        ),
        CustomTextField(
          controller: provider.controllers['details']!,
          label: 'Movie Details',
          maxLines: 2,
          validator: (value) => _requiredFieldValidator(value, 'details'),
        ),
        CustomTextField(
          controller: provider.controllers['description']!,
          label: 'Movie Description',
          maxLines: 9,
          validator: (value) => _requiredFieldValidator(value, 'description'),
        ),
      ],
    );
  }

  Widget _buildDownloadLinkField(UploadMovieProvider provider) {
    return CustomTextField(
      controller: provider.controllers['downloadLink']!,
      label: 'Download Link',
      validator: (value) => _requiredFieldValidator(value, 'download link'),
    );
  }

  Widget _buildAdditionalFields(UploadMovieProvider provider) {
    return Column(
      children: [
        CustomTextField(
          controller: provider.controllers['youtubeTrailer']!,
          label: 'Youtube Trailer Link',
          validator: (value) =>
              _requiredFieldValidator(value, 'Youtube trailer link'),
        ),
        CustomTextField(
          controller: provider.controllers['source']!,
          label: 'Source',
          validator: (value) => _requiredFieldValidator(value, 'source'),
        ),
        CustomTextField(
          controller: provider.controllers['country']!,
          label: 'Country',
          validator: (value) => _requiredFieldValidator(value, 'country'),
        ),
        CustomTextField(
          controller: provider.controllers['cast']!,
          label: 'Cast (separated by commas)',
          validator: (value) => _requiredFieldValidator(value, 'cast'),
        ),
        CustomTextField(
          controller: provider.controllers['releaseDate']!,
          label: 'Release Date',
          keyboardType: TextInputType.datetime,
          validator: (value) => _requiredFieldValidator(value, 'release date'),
        ),
        CustomTextField(
          controller: provider.controllers['language']!,
          label: 'Language(s) separate by comma if multiple',
          validator: (value) => _requiredFieldValidator(value, 'language'),
        ),
        CustomTextField(
          controller: provider.controllers['tags']!,
          label: 'Tags (separated by commas)',
          validator: (value) => _requiredFieldValidator(value, 'tags'),
        ),
      ],
    );
  }

  String? _requiredFieldValidator(String? value, String fieldName) {
    if (value?.isEmpty ?? true) {
      return 'Please enter the $fieldName';
    }
    return null;
  }

  String? _ratingValidator(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter the rating';
    }
    final rating = double.tryParse(value!);
    if (rating == null || rating < 0 || rating > 10) {
      return 'Rating must be a number between 0 and 10';
    }
    return null;
  }
}
