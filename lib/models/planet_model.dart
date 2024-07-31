import 'dart:convert';

PlanetResponse planetResponseFromJson(String str) =>
    PlanetResponse.fromJson(json.decode(str));

String planetResponseToJson(PlanetResponse data) => json.encode(data.toJson());

List<PlanetRes> planetListFromJson(String str) {
  final jsonData = json.decode(str);

  if (jsonData is List) {
    return jsonData
        .map((item) => PlanetRes.fromJson(item as Map<String, dynamic>))
        .toList();
  } else {
    return [];
  }
}

class PlanetResponse {
  List<PlanetRes>? items;
  Meta? meta;
  Links? links;

  PlanetResponse({
    this.items,
    this.meta,
    this.links,
  });

  factory PlanetResponse.fromJson(Map<String, dynamic> json) => PlanetResponse(
        items: json["items"] == null
            ? []
            : List<PlanetRes>.from(
                json["items"]!.map((x) => PlanetRes.fromJson(x))),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        links: json["links"] == null ? null : Links.fromJson(json["links"]),
      );

  Map<String, dynamic> toJson() => {
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
        "meta": meta?.toJson(),
        "links": links?.toJson(),
      };
}

class PlanetRes {
  int? id;
  String? name;
  bool? isDestroyed;
  String? description;
  String? image;
  dynamic deletedAt;

  PlanetRes({
    this.id,
    this.name,
    this.isDestroyed,
    this.description,
    this.image,
    this.deletedAt,
  });

  factory PlanetRes.fromJson(Map<String, dynamic> json) => PlanetRes(
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

class Links {
  String? first;
  String? previous;
  String? next;
  String? last;

  Links({
    this.first,
    this.previous,
    this.next,
    this.last,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        first: json["first"],
        previous: json["previous"],
        next: json["next"],
        last: json["last"],
      );

  Map<String, dynamic> toJson() => {
        "first": first,
        "previous": previous,
        "next": next,
        "last": last,
      };
}

class Meta {
  int? totalItems;
  int? itemCount;
  int? itemsPerPage;
  int? totalPages;
  int? currentPage;

  Meta({
    this.totalItems,
    this.itemCount,
    this.itemsPerPage,
    this.totalPages,
    this.currentPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        totalItems: json["totalItems"],
        itemCount: json["itemCount"],
        itemsPerPage: json["itemsPerPage"],
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
      );

  Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "itemCount": itemCount,
        "itemsPerPage": itemsPerPage,
        "totalPages": totalPages,
        "currentPage": currentPage,
      };
}
