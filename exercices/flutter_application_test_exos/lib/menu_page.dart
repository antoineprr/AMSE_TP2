import 'package:flutter/material.dart';
import 'package:flutter_application_test_exos/image_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Page'),
      ),
      body: ListView(
        children: [
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
                        title: const Text('Exercice 2'),
                      ),
                      body: const ImagePage(),
                      );
                    },
                  ),
                );
              },
              child: const ListTile(
              title: Text('Exercice 2'),
              subtitle: Text('Rotate&Scale Image'),
              trailing: Icon(Icons.play_arrow),
              ),
            ),
          ),
          const Card(
            child: ListTile(
              title: Text('Exercice 2b'),
              subtitle: Text('Animates Rotate&Scale Image'),
              trailing: Icon(Icons.play_arrow),
            ),
          ),
          const Card(
            child: ListTile(
              title: Text('Exercice 4a'),
              subtitle: Text('Display a tile'),
              trailing: Icon(Icons.play_arrow),
            ),
          ),
          const Card(
            child: ListTile(
              title: Text('Exercice 5a'),
              subtitle: Text('Grid of colored boxes'),
              trailing: Icon(Icons.play_arrow),
            ),
          ),
          const Card(
            child: ListTile(
              title: Text('Exercice 5b'),
              subtitle: Text('Fixed grid of cropped images'),
              trailing: Icon(Icons.play_arrow),
            ),
          ),
        ],
      ),
    );
  }
}