import 'package:dbz_app/provider/api_provider.dart';
import 'package:dbz_app/screens/planet_detail_screen.dart';
import 'package:dbz_app/widgets/planet_search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlanetScreen extends StatefulWidget {
  const PlanetScreen({super.key});

  @override
  State<PlanetScreen> createState() => _PlanetScreenState();
}

class _PlanetScreenState extends State<PlanetScreen> {
  final scrollController = ScrollController();
  bool isLoading = false;
  int page = 1;

  @override
  void initState() {
    super.initState();
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    apiProvider.getPlanets(page);
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
          'Planetas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: SearchPlanet());
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: SizedBox(
        child: apiProvider.planets.isNotEmpty
            ? PlanetList(
                apiProvider: apiProvider,
                isLoading: isLoading,
                scrollController: scrollController,
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

class PlanetList extends StatelessWidget {
  final ApiProvider apiProvider;
  final ScrollController scrollController;
  final bool isLoading;

  const PlanetList({
    super.key,
    required this.apiProvider,
    required this.scrollController,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: apiProvider.planets.length,
      controller: scrollController,
      itemBuilder: (BuildContext context, int index) {
        if (index < apiProvider.planets.length) {
          final planet = apiProvider.planets[index];

          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PlanetDetailScreen(planet: planet),
                ),
              );
            },
            child: Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border:
                    Border.all(color: Colors.white, width: 1.5), // Borde blanco
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
                    horizontal: 16.0, vertical: 10.0),
                leading: planet.image != null
                    ? Image.network(
                        planet.image!,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.image,
                        size: 70), // Fallback icon if no image
                title: Text(planet.name ?? 'Unknown Planet'),
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
