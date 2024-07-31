import 'package:dbz_app/models/planet_model.dart';
import 'package:dbz_app/provider/api_provider.dart';
import 'package:dbz_app/screens/planet_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPlanet extends SearchDelegate {
  late Future<List<PlanetRes>> searchResults;

  SearchPlanet() : super() {
    searchResults = Future.value([]);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
          searchResults = Future.value([]);
          showSuggestions(context);
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final apiProvider = Provider.of<ApiProvider>(context);

    searchResults = apiProvider.getPlanetsByName(query);

    return FutureBuilder<List<PlanetRes>>(
        future: searchResults,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _circleLoading();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No results found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final planet = snapshot.data![index];

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PlanetDetailScreen(planet: planet),
                      // ignore: avoid_print
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                        color: Colors.white, width: 1.5), // Borde blanco
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(
                            0, 3), // Cambiar posición del sombreado
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    leading: planet.image != null
                        ? Image.network(
                            planet.image!,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image, size: 50),
                    title: Text(planet.name ?? 'Unknown'),
                    trailing: Text(
                      planet.isDestroyed! ? 'Destruido' : 'Activo',
                      style: TextStyle(
                        color: planet.isDestroyed!
                            ? Colors.red
                            : Colors
                                .green, // Color opcional para diferenciar el estado
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  Widget _circleLoading() {
    return const Center(
      child: CircleAvatar(
        radius: 100,
        backgroundImage: AssetImage('assets/images/ball.png'),
      ),
    );
  }
}
