import 'dart:math';

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

  @override
  void initState() {
    super.initState();
    tileMatrix = createTileMatrix(_sliderValue.round());
  }

  List<List<Tile>> createTileMatrix(int size) {
    var matrix = List.generate(size, (row) {
      return List.generate(size, (col) {
        int tileNumber = row * size + col + 1; 
        bool isLastTile = (row == size - 1 && col == size - 1);
        return Tile(
          imageURL: imageUrl,
          alignment: Alignment((col * 2 / (size - 1))-1, (row * 2 / (size - 1))-1),
          gridSize: size,
          isEmpty: isLastTile,
          number: tileNumber,
        );
      });
    });
    
    var emptyPos = (size - 1, size - 1);
    var rng = Random();
    for (int i = 0; i < 100 * size; i++) {
      List<(int, int)> validMoves = [];
      if (emptyPos.$1 > 0) validMoves.add((emptyPos.$1 - 1, emptyPos.$2)); 
      if (emptyPos.$1 < size - 1) validMoves.add((emptyPos.$1 + 1, emptyPos.$2)); 
      if (emptyPos.$2 > 0) validMoves.add((emptyPos.$1, emptyPos.$2 - 1)); 
      if (emptyPos.$2 < size - 1) validMoves.add((emptyPos.$1, emptyPos.$2 + 1)); 
      
      var move = validMoves[rng.nextInt(validMoves.length)];
      
      var temp = matrix[emptyPos.$1][emptyPos.$2];
      matrix[emptyPos.$1][emptyPos.$2] = matrix[move.$1][move.$2];
      matrix[move.$1][move.$2] = temp;
      
      emptyPos = move;
    }
    return matrix;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    int crossAxisCount = _sliderValue.round();
    double maxGridHeight = screenHeight * 0.7;
    double gridSize = (screenWidth < screenHeight ? screenWidth - 32 : maxGridHeight - 32);

    if (tileMatrix.length != crossAxisCount) {
      tileMatrix = createTileMatrix(crossAxisCount);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jeu de taquin'),
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
                    for (var i = 0; i < tileMatrix.length; i++)
                      for (var j = 0; j < tileMatrix[i].length; j++)
                        Container(
                            decoration: BoxDecoration(
                            border: Border.all(
                              color: tileMatrix[i][j].isEmpty ? Colors.white : Colors.black,
                              width: tileMatrix[i][j].isEmpty ? 0 : 1
                            ),
                            ),
                            child: InkWell(
                            onTap: () {
                              var emptyPosition = findEmptyTile();
                              if (isAdjacentToEmpty(i, j, emptyPosition.$1, emptyPosition.$2)) {
                                swapTiles(i, j, emptyPosition.$1, emptyPosition.$2);
                              }
                            },
                            child: tileMatrix[i][j].croppedImageTile(),
                            )
                          ),
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

  void swapTiles(int row1, int col1, int row2, int col2) {
    setState(() {
      var temp = tileMatrix[row1][col1];
      tileMatrix[row1][col1] = tileMatrix[row2][col2];
      tileMatrix[row2][col2] = temp;
    });
  }

  (int, int) findEmptyTile() {
    for (int r = 0; r < tileMatrix.length; r++) {
      for (int c = 0; c < tileMatrix[r].length; c++) {
        if (tileMatrix[r][c].isEmpty) {
          return (r, c);
        }
      }
    }
    return (-1, -1);
  }

  bool isAdjacentToEmpty(int row, int col, int emptyRow, int emptyCol) {
    return (row == emptyRow && (col == emptyCol + 1 || col == emptyCol - 1)) || 
           (col == emptyCol && (row == emptyRow + 1 || row == emptyRow - 1));
  }
}