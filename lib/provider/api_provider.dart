import 'package:dbz_app/models/character_base_model.dart';
import 'package:dbz_app/models/character_detail_model.dart';
import 'package:dbz_app/models/character_model.dart';
import 'package:dbz_app/models/planet_detail_model.dart';
import 'package:dbz_app/models/planet_model.dart';
import 'package:dbz_app/models/transformation_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiProvider with ChangeNotifier {
  final url = 'dragonball-api.com';
  List<Character> characters = [];
  List<PlanetRes> planets = [];
  List<TransformationResponse> transformations = [];
  late CharacterDetailResponse _characterDetail;
  late PlanetDetailResponse _planetDetail;

  CharacterDetailResponse get characterDetail => _characterDetail;
  PlanetDetailResponse get planetDetail => _planetDetail;

  Future<void> getCharacters(int page) async {
    final result = await http
        .get(Uri.https(url, '/api/characters', {'page': page.toString()}));
    final response = characterResponseFromJson(result.body);
    characters.addAll(response.items as Iterable<Character>);
    notifyListeners();
  }

  Future<void> getCharacterById(int id) async {
    final result =
        await http.get(Uri.https(url, '/api/characters/${id.toString()}'));
    _characterDetail = characterDetailResponseFromJson(result.body);

    if (kDebugMode) {
      print("consulta detail");
      print(id);
      print(_characterDetail.name);
    }

    notifyListeners(); // Notify listeners to update UI
  }

  Future<List<Character>> getCharactersByName(String name) async {
    final response =
        await http.get(Uri.https(url, '/api/characters', {'name': name}));

    if (response.statusCode == 200) {
      final result = characterListFromJson(response.body);

      return result;
    }
    return [];
  }

  // Plantes
  Future<void> getPlanets(int page) async {
    final result = await http
        .get(Uri.https(url, '/api/planets', {'page': page.toString()}));
    final response = planetResponseFromJson(result.body);
    planets.addAll(response.items as Iterable<PlanetRes>);

    if (kDebugMode) {
      print("planetas");
      print(planets);
    }
    notifyListeners();
  }

  Future<void> getPlanetById(int id) async {
    final result =
        await http.get(Uri.https(url, '/api/planets/${id.toString()}'));
    _planetDetail = planetDetailResponseFromJson(result.body);

    if (kDebugMode) {
      print("consulta detail");
      print(id);
      print(_planetDetail.name);
    }

    notifyListeners(); // Notify listeners to update UI
  }

  Future<List<PlanetRes>> getPlanetsByName(String name) async {
    final response =
        await http.get(Uri.https(url, '/api/planets', {'name': name}));

    if (response.statusCode == 200) {
      final result = planetListFromJson(response.body);

      return result;
    }
    return [];
  }
}
