import 'dart:convert';

import 'package:dbz_app/models/character_base_model.dart';

CharacterResponse characterResponseFromJson(String str) =>
    CharacterResponse.fromJson(json.decode(str));

String characterResponseToJson(CharacterResponse data) =>
    json.encode(data.toJson());

// Lista simple de characters
List<Character> characterListFromJson(String str) {
  final jsonData = json.decode(str);

  // Verifica si jsonData es una lista
  if (jsonData is List) {
    return jsonData
        .map((item) => Character.fromJson(item as Map<String, dynamic>))
        .toList();
  } else {
    // Devuelve una lista vacía si jsonData no es una lista
    return [];
  }
}

class CharacterResponse {
  List<Character>? items;
  Meta? meta;
  Links? links;

  CharacterResponse({
    this.items,
    this.meta,
    this.links,
  });

  factory CharacterResponse.fromJson(Map<String, dynamic> json) =>
      CharacterResponse(
        items: json["items"] == null
            ? []
            : List<Character>.from(
                json["items"]!.map((x) => Character.fromJson(x))),
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
