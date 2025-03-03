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

  void _changeImage() {
    final random = Random().nextInt(1000);
    _imageUrlController.text = 'https://picsum.photos/512/512?random=$random';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Page'),
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
                Card(
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    splashColor: Colors.blueGrey,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<Widget>(
                          builder: (BuildContext context) {
                            return Scaffold(
                              appBar: AppBar(
                                title: const Text('Taquin'),
                              ),
                              body: TaquinBoard(imageUrl: _imageUrlController.text),
                            );
                          },
                        ),
                      );
                    },
                    child: const ListTile(
                      title: Text('Taquin basique'),
                      subtitle: Text('Jeu de taquin basique'),
                      trailing: Icon(Icons.play_arrow),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}