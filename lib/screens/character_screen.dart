import 'package:dbz_app/provider/api_provider.dart';
import 'package:dbz_app/screens/character_detail_screen.dart';
import 'package:dbz_app/widgets/character_search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({super.key});

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  final scrollController = ScrollController();
  bool isLoading = false;
  int page = 1;

  @override
  void initState() {
    super.initState();
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    apiProvider.getCharacters(page);
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isLoading = true;
        });
        page++;
        await apiProvider.getCharacters(page);
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiProvider = Provider.of<ApiProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Personajes',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: SearchCharacter());
                },
                icon: const Icon(Icons.search))
          ],
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: apiProvider.characters.isNotEmpty
              ? CharacterList(
                  apiProvider: apiProvider,
                  isLoading: isLoading,
                  scrollController: scrollController,
                )
              : const Center(child: CircularProgressIndicator()),
        ));
  }
}

class CharacterList extends StatelessWidget {
  final ApiProvider apiProvider;
  final ScrollController scrollController;
  final bool isLoading;

  const CharacterList(
      {super.key,
      required this.apiProvider,
      required this.scrollController,
      required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.87,
          mainAxisSpacing: 5,
          crossAxisSpacing: 10),
      itemCount: isLoading
          ? apiProvider.characters.length + 1
          : apiProvider.characters.length,
      controller: scrollController,
      itemBuilder: (BuildContext context, int index) {
        if (index < apiProvider.characters.length) {
          final character = apiProvider.characters[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      CharacterDetailScreen(character: character),
                ),
              );
            },
            child: Card(
              child: Column(
                children: [
                  Hero(
                    tag: character.id!,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 5.0),
                      width: double.infinity, // Ajusta el ancho según el diseño
                      height: 170, // Altura fija para la imagen
                      child: FadeInImage(
                        alignment: Alignment.topCenter,
                        image: NetworkImage(character.image!),
                        placeholder: const AssetImage('assets/images/ball.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    character.name!,
                    style: const TextStyle(
                        fontSize: 18,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '( ${character.race!} )',
                    style: const TextStyle(
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
