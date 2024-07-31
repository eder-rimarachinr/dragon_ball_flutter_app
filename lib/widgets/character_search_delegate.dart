import 'package:dbz_app/models/character_base_model.dart';
import 'package:dbz_app/provider/api_provider.dart';
import 'package:dbz_app/screens/character_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchCharacter extends SearchDelegate {
  late Future<List<Character>> searchResults;

  SearchCharacter() : super() {
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
    final characterProvider = Provider.of<ApiProvider>(context);

    searchResults = characterProvider.getCharactersByName(query);

    return FutureBuilder<List<Character>>(
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
            final character = snapshot.data![index];

            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        CharacterDetailScreen(character: character),
                  ),
                );
              },
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                      color: Colors.white, width: 1.5), // Borde blanco
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset:
                          const Offset(0, 3), // Cambiar posición del sombreado
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  leading: character.image != null
                      ? Image.network(
                          character.image!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image, size: 50),
                  title: Text(
                      '${character.name ?? 'Unknown'} - ${character.race ?? 'Unknown'}'),
                ),
              ),
            );
          },
        );
      },
    );
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
