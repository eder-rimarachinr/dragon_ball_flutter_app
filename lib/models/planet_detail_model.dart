import 'dart:convert';

import 'package:dbz_app/models/character_base_model.dart';

PlanetDetailResponse planetDetailResponseFromJson(String str) =>
    PlanetDetailResponse.fromJson(json.decode(str));

String planetDetailResponseToJson(PlanetDetailResponse data) =>
    json.encode(data.toJson());

class PlanetDetailResponse {
  int? id;
  String? name;
  bool? isDestroyed;
  String? description;
  String? image;
  dynamic deletedAt;
  List<Character>? characters;

  PlanetDetailResponse({
    this.id,
    this.name,
    this.isDestroyed,
    this.description,
    this.image,
    this.deletedAt,
    this.characters,
  });

  factory PlanetDetailResponse.fromJson(Map<String, dynamic> json) =>
      PlanetDetailResponse(
        id: json["id"],
        name: json["name"],
        isDestroyed: json["isDestroyed"],
        description: json["description"],
        image: json["image"],
        deletedAt: json["deletedAt"],
        characters: json["characters"] == null
            ? []
            : List<Character>.from(
                json["characters"]!.map((x) => Character.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "isDestroyed": isDestroyed,
        "description": description,
        "image": image,
        "deletedAt": deletedAt,
        "characters": characters == null
            ? []
            : List<dynamic>.from(characters!.map((x) => x.toJson())),
      };
}
