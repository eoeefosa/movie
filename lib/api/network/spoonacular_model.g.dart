// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spoonacular_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpoonacularResults _$SpoonacularResultsFromJson(Map<String, dynamic> json) =>
    SpoonacularResults(
      results: (json['results'] as List<dynamic>)
          .map((e) => SpoonacularResult.fromJson(e as Map<String, dynamic>))
          .toList(),
      offset: (json['offset'] as num).toInt(),
      number: (json['number'] as num).toInt(),
      totalResults: (json['totalResults'] as num).toInt(),
    );

Map<String, dynamic> _$SpoonacularResultsToJson(SpoonacularResults instance) =>
    <String, dynamic>{
      'results': instance.results,
      'offset': instance.offset,
      'number': instance.number,
      'totalResults': instance.totalResults,
    };

SpoonacularResult _$SpoonacularResultFromJson(Map<String, dynamic> json) =>
    SpoonacularResult(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      image: json['image'] as String,
      imageType: json['imageType'] as String,
    );

Map<String, dynamic> _$SpoonacularResultToJson(SpoonacularResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'image': instance.image,
      'imageType': instance.imageType,
    };
