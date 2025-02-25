import 'package:flutter/material.dart';

class PlateauPage extends StatefulWidget {
  const PlateauPage({super.key});

  @override
  State<PlateauPage> createState() => _PlateauPageState();
}

class _PlateauPageState extends State<PlateauPage> {
  final String imageUrl = 'https://picsum.photos/512/512';
  double _sliderValue = 3;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    int crossAxisCount = _sliderValue.round();
    double maxGridHeight = screenHeight * 0.7; // Limite la hauteur de la grille
    double gridSize = (screenWidth < screenHeight ? screenWidth - 32 : screenHeight - 32).clamp(0, maxGridHeight);
    double tileSize = gridSize / crossAxisCount;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: maxGridHeight,
            child: Center(
              child: SizedBox(
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
                    
                    return ClipRect(
                      child: Container(
                        width: tileSize,
                        height: tileSize,
                        child: FittedBox(
                          fit: BoxFit.none,
                          alignment: Alignment(
                            -1 + (col * 2 / (crossAxisCount - 1)),
                            -1 + (row * 2 / (crossAxisCount - 1)),
                          ),
                          child: SizedBox(
                            width: gridSize,
                            height: gridSize,
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
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
    );
  }
}
