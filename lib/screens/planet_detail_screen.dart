import 'package:dbz_app/models/character_base_model.dart';
import 'package:dbz_app/models/planet_detail_model.dart';
import 'package:dbz_app/models/planet_model.dart';
import 'package:dbz_app/provider/api_provider.dart';
import 'package:dbz_app/screens/character_detail_screen.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlanetDetailScreen extends StatefulWidget {
  final PlanetRes planet;
  const PlanetDetailScreen({super.key, required this.planet});

  @override
  State<PlanetDetailScreen> createState() => _PlanetDetailScreenState();
}

class _PlanetDetailScreenState extends State<PlanetDetailScreen> {
  late Future<void> _loadPlanetDetail;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadPlanetDetail = _loadPlanetDetails();
  }

  Future<void> _loadPlanetDetails() async {
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    await apiProvider.getPlanetById(widget.planet.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Planeta',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _loadPlanetDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.connectionState == ConnectionState.done) {
            final planetDetail = Provider.of<ApiProvider>(context).planetDetail;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPlanetImage(planetDetail.image!),
                  _buildTitleAndStatus(planetDetail),
                  _buildDescription(planetDetail.description!),
                  _buildListCharacters(planetDetail.characters!)
                ],
              ),
            );
          } else {
            return const Center(child: Text('No hay datos disponibles'));
          }
        },
      ),
    );
  }

  Widget _buildPlanetImage(String imageUrl) {
    return Stack(
      children: [
        Image.network(
          imageUrl,
          width: double.infinity,
          height: 350,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Mostrar una imagen alternativa en caso de error
            return Image.asset(
              'assets/images/ball.png', // Ruta de la imagen alternativa
              width: 50.0,
              height: 50.0,
              fit: BoxFit.fill,
            );
          },
        ),
        Container(
          width: double.infinity,
          height: 350,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              colors: [Colors.black38, Colors.black],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleAndStatus(PlanetDetailResponse planetDetail) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTitle(planetDetail.name!),
          _buildStatus(planetDetail.isDestroyed!),
        ],
      ),
    );
  }

  Widget _buildTitle(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: const Color.fromARGB(255, 98, 164, 217).withOpacity(0.6),
        border: Border.all(width: 2.0),
      ),
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildStatus(bool isDestroyed) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: isDestroyed
            ? const Color.fromARGB(255, 184, 25, 25)
            : const Color.fromARGB(126, 0, 255, 106),
        border: Border.all(width: 1.0),
      ),
      child: Text(
        isDestroyed ? 'Destruido' : 'Activo',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDescription(String description) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 6.0),
            child: Text(
              'Descripción',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Text(
            _isExpanded || description.length <= 150
                ? description
                : '${description.substring(0, 150)}...',
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.justify,
            maxLines: _isExpanded ? null : 3,
            overflow:
                _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
          if (description.length > 150)
            TextButton(
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Text(
                _isExpanded ? 'Mostrar menos' : 'Leer más',
                style: const TextStyle(color: Colors.blue, fontSize: 14),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildListCharacters(List<Character> characters) {
    if (characters.isEmpty) {
      return Container();
    }

    return SizedBox(
      height: 300.0, // Ajusta la altura según sea necesario
      child: ListView.builder(
        itemCount: characters.length,
        itemBuilder: (context, index) {
          final character = characters[index];

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            height: 60.0, // Altura fija para cada ítem
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        CharacterDetailScreen(character: character),
                  ),
                );
              },
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    children: [
                      // Imagen del personaje
                      character.image != null
                          ? Image.network(
                              alignment: Alignment.topCenter,
                              character.image!,
                              width: 60.0,
                              height: 60.0,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // Mostrar una imagen alternativa en caso de error
                                return Image.asset(
                                  'assets/images/ball.png', // Ruta de la imagen alternativa
                                  width: 50.0,
                                  height: 50.0,
                                  fit: BoxFit.fill,
                                );
                              },
                            )
                          : const Icon(Icons.image, size: 60.0),

                      // Espacio entre la imagen y el nombre
                      const SizedBox(width: 12.0),

                      // Nombre del personaje
                      Expanded(
                        child: Text(
                          '${character.name ?? 'Unknown'} - ${character.race!}',
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
