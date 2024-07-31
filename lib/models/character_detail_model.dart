import 'dart:convert';

CharacterDetailResponse characterDetailResponseFromJson(String str) =>
    CharacterDetailResponse.fromJson(json.decode(str));

String characterDetailResponseToJson(CharacterDetailResponse data) =>
    json.encode(data.toJson());

class CharacterDetailResponse {
  int? id;
  String? name;
  String? ki;
  String? maxKi;
  String? race;
  String? gender;
  String? description;
  String? image;
  String? affiliation;
  dynamic deletedAt;
  OriginPlanet? originPlanet;
  List<Transformation>? transformations;

  CharacterDetailResponse({
    this.id,
    this.name,
    this.ki,
    this.maxKi,
    this.race,
    this.gender,
    this.description,
    this.image,
    this.affiliation,
    this.deletedAt,
    this.originPlanet,
    this.transformations,
  });

  factory CharacterDetailResponse.fromJson(Map<String, dynamic> json) =>
      CharacterDetailResponse(
        id: json["id"],
        name: json["name"],
        ki: json["ki"],
        maxKi: json["maxKi"],
        race: json["race"],
        gender: json["gender"],
        description: json["description"],
        image: json["image"],
        affiliation: json["affiliation"],
        deletedAt: json["deletedAt"],
        originPlanet: json["originPlanet"] == null
            ? null
            : OriginPlanet.fromJson(json["originPlanet"]),
        transformations: json["transformations"] == null
            ? []
            : List<Transformation>.from(json["transformations"]!
                .map((x) => Transformation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "ki": ki,
        "maxKi": maxKi,
        "race": race,
        "gender": gender,
        "description": description,
        "image": image,
        "affiliation": affiliation,
        "deletedAt": deletedAt,
        "originPlanet": originPlanet?.toJson(),
        "transformations": transformations == null
            ? []
            : List<dynamic>.from(transformations!.map((x) => x.toJson())),
      };
}

class OriginPlanet {
  int? id;
  String? name;
  bool? isDestroyed;
  String? description;
  String? image;
  dynamic deletedAt;

  OriginPlanet({
    this.id,
    this.name,
    this.isDestroyed,
    this.description,
    this.image,
    this.deletedAt,
  });

  factory OriginPlanet.fromJson(Map<String, dynamic> json) => OriginPlanet(
        id: json["id"],
        name: json["name"],
        isDestroyed: json["isDestroyed"],
        description: json["description"],
        image: json["image"],
        deletedAt: json["deletedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "isDestroyed": isDestroyed,
        "description": description,
        "image": image,
        "deletedAt": deletedAt,
      };
}

class Transformation {
  int? id;
  String? name;
  String? image;
  String? ki;
  dynamic deletedAt;

  Transformation({
    this.id,
    this.name,
    this.image,
    this.ki,
    this.deletedAt,
  });

  factory Transformation.fromJson(Map<String, dynamic> json) => Transformation(
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
