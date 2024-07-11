import 'package:json_annotation/json_annotation.dart';
import '../data/models/models.dart';
part 'spoonacular_model.g.dart';

@JsonSerializable()
class SpoonacularResults {
 // TODO: Add Fields
 List<SpoonacularResult> results;
int offset;
int number;
int totalResults;
 // TODO: Add Constructor
 SpoonacularResults({
 required this.results,
 required this.offset,
 required this.number,
 required this.totalResults,
});
 // TODO: Add fromJson
 factory SpoonacularResults.fromJson(Map<String, dynamic> json) 
=>
 _$SpoonacularResultsFromJson(json);
 // TODO: Add toJson
} 
// TODO: Add SpoonacularResult
// 1
@JsonSerializable()
class SpoonacularResult {
 // 2
 int id;
 String title;
 String image;
 String imageType;
 // 3
 SpoonacularResult({
 required this.id,
 required this.title,
 required this.image,
 required this.imageType,
 });
 // 4
 factory SpoonacularResult.fromJson(Map<String, dynamic> json) 
=>
 _$SpoonacularResultFromJson(json);
 Map<String, dynamic> toJson() => 
_$SpoonacularResultToJson(this);
}