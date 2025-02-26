import 'package:flutter/material.dart';
import 'package:flutter_application_test_exos/tuile_page.dart';  // Add this import

class Exercice5b extends StatefulWidget {
  const Exercice5b({super.key});

  @override
  State<Exercice5b> createState() => _Exercice5bState();
}

class _Exercice5bState extends State<Exercice5b> {
  final String imageUrl = 'https://picsum.photos/512/512';
  double _sliderValue = 3;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    int crossAxisCount = _sliderValue.round();
    double maxGridHeight = screenHeight * 0.7;
    double gridSize = (screenWidth < screenHeight ? screenWidth - 32 : maxGridHeight - 32);
    double tileSize = gridSize / crossAxisCount;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Puzzle Game'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: gridSize,
              height: gridSize,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 2.0,
                  mainAxisSpacing: 2.0,
                ),
                itemCount: crossAxisCount * crossAxisCount,
                itemBuilder: (context, index) {
                  int row = index ~/ crossAxisCount;
                  int col = index % crossAxisCount;
                  
                  Tile tile = Tile(
                    imageURL: imageUrl,
                    alignment: Alignment(
                      -1 + (col * 2 / (crossAxisCount - 1)),
                      -1 + (row * 2 / (crossAxisCount - 1)),
                    ),
                  );
                  
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: tile.croppedImageTile(),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Grid size: ${_sliderValue.round()}x${_sliderValue.round()}'),
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
    );
  }
}
