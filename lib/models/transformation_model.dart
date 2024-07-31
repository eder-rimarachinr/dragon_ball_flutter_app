import 'dart:convert';

List<TransformationResponse> transformationResponseFromJson(String str) =>
    List<TransformationResponse>.from(
        json.decode(str).map((x) => TransformationResponse.fromJson(x)));

String transformationResponseToJson(List<TransformationResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransformationResponse {
  int? id;
  String? name;
  String? image;
  String? ki;
  dynamic deletedAt;

  TransformationResponse({
    this.id,
    this.name,
    this.image,
    this.ki,
    this.deletedAt,
  });

  factory TransformationResponse.fromJson(Map<String, dynamic> json) =>
      TransformationResponse(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        ki: json["ki"],
        deletedAt: json["deletedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "ki": ki,
        "deletedAt": deletedAt,
      };
}
