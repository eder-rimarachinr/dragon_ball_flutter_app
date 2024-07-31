import 'package:dbz_app/models/character_base_model.dart';
import 'package:dbz_app/models/planet_model.dart';
import 'package:dbz_app/models/transformation_model.dart';
import 'package:dbz_app/provider/api_provider.dart';
import 'package:dbz_app/screens/character_detail_screen.dart';
import 'package:dbz_app/screens/home_screen.dart';
import 'package:dbz_app/screens/planet_detail_screen.dart';
import 'package:dbz_app/screens/transformation_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        // Routes for character details
        GoRoute(
          path: 'character/:id',
          builder: (context, state) {
            final character = state.extra as Character;
            return CharacterDetailScreen(character: character);
          },
        ),
        // Routes for planet details
        GoRoute(
          path: 'planet/:id',
          builder: (context, state) {
            final planet = state.extra as PlanetRes;
            return PlanetDetailScreen(planet: planet);
          },
        ),
        // Routes for transformation details
        GoRoute(
          path: 'transformation/:id',
          builder: (context, state) {
            final transformation = state.extra as TransformationResponse;
            return TransformationDetailScreen(transformation: transformation);
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ApiProvider(),
      child: MaterialApp.router(
        title: 'DBZ Info',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
        routerConfig: _router,
      ),
    );
  }
}
