import 'package:flutter/material.dart';
import 'package:flutter_application_test_exos/tuile_page.dart';

class Exercice5a extends StatefulWidget {
  const Exercice5a({super.key});

  @override
  State<Exercice5a> createState() => _Exercice5aState();
}

class _Exercice5aState extends State<Exercice5a> {
  final String imageUrl = 'https://picsum.photos/512/512';
  double _sliderValue = 3;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    int crossAxisCount = _sliderValue.round();
    double maxGridHeight = screenHeight * 0.7;
    double gridSize = (screenWidth < screenHeight ? screenWidth - 32 : maxGridHeight - 32);
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Image with tiles'),
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
                    gridSize: crossAxisCount,
                    number: index,
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
          ],
        ),
      ),
    );
  }
}
