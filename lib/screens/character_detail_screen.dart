import 'package:dbz_app/models/character_base_model.dart';
import 'package:dbz_app/models/character_detail_model.dart';
import 'package:dbz_app/provider/api_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CharacterDetailScreen extends StatefulWidget {
  final Character character;
  const CharacterDetailScreen({super.key, required this.character});

  @override
  State<CharacterDetailScreen> createState() => _CharacterDetailScreenState();
}

class _CharacterDetailScreenState extends State<CharacterDetailScreen> {
  late Future<void> _loadCharacterDetail;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    _loadCharacterDetail = apiProvider.getCharacterById(widget.character.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.character.name!),
      ),
      body: FutureBuilder<void>(
        future: _loadCharacterDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.connectionState == ConnectionState.done) {
            final characterDetail =
                Provider.of<ApiProvider>(context).characterDetail;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCharacterInfo(characterDetail),
                  _buildCharacterDescription(characterDetail),
                  _buildAdditionalInfo(characterDetail),
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

  Widget _buildCharacterInfo(CharacterDetailResponse characterDetail) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCharacterImage(characterDetail),
          const SizedBox(width: 20),
          _buildCharacterDetails(characterDetail),
        ],
      ),
    );
  }

  Widget _buildCharacterImage(CharacterDetailResponse characterDetail) {
    return Card(
      child: Hero(
        tag: characterDetail.id!,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          width: 130,
          height: 170,
          child: FadeInImage(
            alignment: Alignment.topCenter,
            image: NetworkImage(characterDetail.image!),
            placeholder: const AssetImage('assets/images/ball.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildCharacterDetails(CharacterDetailResponse characterDetail) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('Nombre:', characterDetail.name!),
          _buildDetailRow('Raza:', characterDetail.race!),
          _buildDetailRow('Género:', characterDetail.gender!),
          _buildDetailRow(
              'Afiliación:', characterDetail.affiliation ?? 'Desconocido'),
          _buildDetailRow(
            'Origen:',
            characterDetail.originPlanet?.name ?? 'Desconocido',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(),
              overflow: TextOverflow
                  .visible, // Permite que el texto haga salto de línea
              softWrap: true, // Habilita el ajuste del texto
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterDescription(CharacterDetailResponse characterDetail) {
    final description = characterDetail.description ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Información",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 16,
            ),
          ),
          Text(
            _isExpanded || description.length <= 250
                ? description
                : '${description.substring(0, 250)}...',
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.justify,
            maxLines: _isExpanded ? null : 6,
            overflow:
                _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
          if (description.length > 250)
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
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo(CharacterDetailResponse characterDetail) {
    final planetName = characterDetail.originPlanet?.name ?? 'Desconocido';
    final hasTransformations =
        characterDetail.transformations?.isNotEmpty ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          const Text(
            "Adicional",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          // Botón del Planeta
          SizedBox(
            width: double.infinity, // Ocupa todo el ancho disponible
            child: FloatingActionButton.extended(
              onPressed: () {
                // Acción para el botón del planeta
                if (kDebugMode) {
                  print('Origen: $planetName');
                }

                if (planetName != 'Desconocido') {}
              },
              label: Text('Origen: $planetName'),
              icon: const Icon(Icons.public),
              backgroundColor: Theme.of(context)
                  .colorScheme
                  .primary, // Color de fondo predeterminado
              foregroundColor:
                  Theme.of(context).colorScheme.onPrimary, // Color del texto
            ),
          ),
          const SizedBox(height: 10),
          // Botón de Transformaciones (solo si hay transformaciones)
          if (hasTransformations)
            SizedBox(
              width: double.infinity, // Ocupa todo el ancho disponible
              child: FloatingActionButton.extended(
                onPressed: () {
                  // Acción para el botón de transformaciones
                  if (kDebugMode) {
                    print('Transformaciones disponibles');
                  }
                },
                label: const Text('Transformaciones'),
                icon: const Icon(Icons.transform),
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .primary, // Color de fondo predeterminado
                foregroundColor:
                    Theme.of(context).colorScheme.onPrimary, // Color del texto
              ),
            ),
        ],
      ),
    );
  }
}
