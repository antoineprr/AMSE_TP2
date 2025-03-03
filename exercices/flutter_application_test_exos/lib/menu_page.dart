import 'package:flutter/material.dart';
import 'package:flutter_application_test_exos/Exercice5a.dart';
import 'package:flutter_application_test_exos/exo4.dart';
import 'package:flutter_application_test_exos/exo6a.dart';
import 'package:flutter_application_test_exos/exo6b.dart';
import 'package:flutter_application_test_exos/exo2.dart';
import 'package:flutter_application_test_exos/exo2b.dart';
import 'package:flutter_application_test_exos/exo5b.dart';
import 'package:flutter_application_test_exos/exo7.dart';

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
                        title: const Text('Exercice 2b'),
                      ),
                      body: const ImagePageAnimate(),
                      );
                    },
                  ),
                );
              },
              child: const ListTile(
              title: Text('Exercice 2b'),
              subtitle: Text('Rotate&Scale&Animate Image'),
              trailing: Icon(Icons.play_arrow),
              ),
            ),
          ),
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
                        title: const Text('Exercice 4a'),
                      ),
                      body: const DisplayTileWidget(),
                      );
                    },
                  ),
                );
              },
              child: const ListTile(
              title: Text('Exercice 4a'),
              subtitle: Text('Display Cropped Image'),
              trailing: Icon(Icons.play_arrow),
              ),
            ),
          ),
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
                        title: const Text('Exercice 5a'),
                      ),
                      body: const Exercice5a(),
                      );
                    },
                  ),
                );
              },
              child: const ListTile(
              title: Text('Exercice 5a'),
              subtitle: Text('Grid of Colored Tiles'),
              trailing: Icon(Icons.play_arrow),
              ),
            ),
          ),
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
                        title: const Text('Exercice 5b'),
                      ),
                      body: const Exercice5b(),
                      );
                    },
                  ),
                );
              },
              child: const ListTile(
              title: Text('Exercice 5b'),
              subtitle: Text('Fixed Grid of Cropped Image'),
              trailing: Icon(Icons.play_arrow),
              ),
            ),
          ),
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
                        title: const Text('Exercice 6a'),
                      ),
                      body: const PositionedTiles(),
                      );
                    },
                  ),
                );
              },
              child: const ListTile(
              title: Text('Exercice 6a'),
              subtitle: Text('Moving Tiles'),
              trailing: Icon(Icons.play_arrow),
              ),
            ),
          ),
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
                        title: const Text('Exercice 6b'),
                      ),
                      body: const PlateauPage(),
                      );
                    },
                  ),
                );
              },
              child: const ListTile(
              title: Text('Exercice 6b'),
              subtitle: Text('Mouvement fonctionnel'),
              trailing: Icon(Icons.play_arrow),
              ),
            ),
          ),
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
                        title: const Text('Exercice 7'),
                      ),
                      body: const TaquinBoard(),
                      );
                    },
                  ),
                );
              },
              child: const ListTile(
              title: Text('Exercice 7'),
              subtitle: Text('Taquin'),
              trailing: Icon(Icons.play_arrow),
              ),
            ),
          ),
        ],
      ),
    );
  }
}