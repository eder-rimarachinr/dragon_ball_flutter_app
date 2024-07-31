import 'package:dbz_app/screens/planet_screen.dart';
import 'package:flutter/material.dart';
import 'package:dbz_app/screens/character_screen.dart';

// import 'package:dbz_app/screens/transformation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    CharacterScreen(),
    PlanetScreen(),
    // TransformationScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue, // Color para el ítem seleccionado
        unselectedItemColor:
            Colors.grey, // Color para los ítems no seleccionados
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Personajes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: 'Planetas',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.transform),
          //   label: 'Transformaciones',
          // ),
        ],
      ),
    );
  }
}
