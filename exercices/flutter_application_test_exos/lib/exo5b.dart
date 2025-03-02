import 'package:flutter/material.dart';
import 'package:flutter_application_test_exos/tuile_page.dart';

class Exercice5b extends StatefulWidget {
  const Exercice5b({super.key});

  @override
  State<Exercice5b> createState() => _Exercice5bState();
}

class _Exercice5bState extends State<Exercice5b> {
  final String imageUrl = 'https://picsum.photos/512/512';
  double _sliderValue = 3;
  late List<List<Tile>> tileMatrix;

  List<List<Tile>> createTileMatrix(int size) {
    int compteur = 0;
    return List.generate(size, (row) {
      return List.generate(size, (col) {
        compteur++;
        return Tile(
          imageURL: imageUrl,
          alignment: Alignment((col * 2 / (size - 1))-1, (row * 2 / (size - 1))-1,
          ),
          gridSize: size, number: compteur,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    int crossAxisCount = _sliderValue.round();
    
    double availableHeight = screenHeight - kToolbarHeight - 120; 
    
    double gridSize = (screenWidth < availableHeight) 
        ? screenWidth * 0.9 
        : availableHeight * 0.9; 
        
    tileMatrix = createTileMatrix(crossAxisCount);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Taquin Board'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    width: gridSize,
                    height: gridSize,
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 2.0,
                      children: [
                        for (var row in tileMatrix)
                          for (var tile in row)
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 1),
                              ),
                              child: tile.croppedImageTile(),
                            )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    children: [
                      Text('Grid size: ${crossAxisCount}x${crossAxisCount}'),
                      Slider(
                        value: _sliderValue,
                        min: 2,
                        max: 6,
                        divisions: 4,
                        onChanged: (value) {
                          setState(() {
                            _sliderValue = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
