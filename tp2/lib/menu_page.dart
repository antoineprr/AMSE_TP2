import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tp2/taquin_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final TextEditingController _imageUrlController = TextEditingController(text: 'https://picsum.photos/512/512');
  int _gridSize = 3;

  void _changeImage() {
    final random = Random().nextInt(1000);
    _imageUrlController.text = 'https://picsum.photos/512/512?random=$random';
    setState(() {});
  }

  void _increaseGridSize() {
    if (_gridSize < 6) {
      setState(() {
        _gridSize++;
      });
    }
  }

  void _decreaseGridSize() {
    if (_gridSize > 2) {
      setState(() {
        _gridSize--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _changeImage,
                  child: Text('Changer l\'image'),
                ),
                const SizedBox(height: 16),
                Image.network(
                  _imageUrlController.text,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text('Impossible de charger l\'image');
                  },
                ),
                const SizedBox(height: 16),
                Text('Taille de la grille : $_gridSize x $_gridSize'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: _decreaseGridSize,
                    ),
                    Text('$_gridSize'),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: _increaseGridSize,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<Widget>(
                        builder: (BuildContext context) {
                          return Scaffold(
                            appBar: AppBar(
                              title: const Text('Taquin'),
                            ),
                            body: TaquinBoard(
                              imageUrl: _imageUrlController.text,
                              gridSize: _gridSize,
                            ),
                          );
                        },
                      ),
                    );
                  },
                  child: const Text('Jouer'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}