import 'package:flutter/material.dart';
import 'package:flutter_application_test_exos/tuile_page.dart';

class PlateauPage extends StatefulWidget {
  const PlateauPage({super.key});

  @override
  State<PlateauPage> createState() => _PlateauPageState();
}

class _PlateauPageState extends State<PlateauPage> {
  final String imageUrl = 'https://picsum.photos/512/512';
  double _sliderValue = 3;
  late List<List<Tile>> tileMatrix;

  List<List<Tile>> createTileMatrix(int size) {
    return List.generate(size, (row) {
      return List.generate(size, (col) {
        return Tile(
          imageURL: imageUrl,
          alignment: Alignment(
            -1 + (col * 2 / (size - 1)),
            -1 + (row * 2 / (size - 1)),
          ),
          gridSize: size, number: 0,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    int crossAxisCount = _sliderValue.round();
    double maxGridHeight = screenHeight * 0.7;
    double gridSize = (screenWidth < screenHeight ? screenWidth - 32 : maxGridHeight - 32);

    tileMatrix = createTileMatrix(crossAxisCount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Taquin Board'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
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
