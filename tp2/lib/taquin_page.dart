import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tp2/tile.dart';

class TaquinBoard extends StatefulWidget {
  final String imageUrl;
  final int gridSize;

  const TaquinBoard({
    super.key,
    this.imageUrl = 'https://picsum.photos/512/512',
    this.gridSize = 3,
  });

  @override
  State<TaquinBoard> createState() => _TaquinBoardState();
}

class _TaquinBoardState extends State<TaquinBoard> {
  late String imageUrl;
  late double _sliderValue;
  late List<List<Tile>> tileMatrix;
  
  int moveCount = 0;
  Stopwatch chrono = Stopwatch();

  @override
  void initState() {
    super.initState();
    imageUrl = widget.imageUrl;
    _sliderValue = widget.gridSize.toDouble();
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
    double maxGridHeight = screenHeight * 0.6;
    double gridSize = min(screenWidth - 32, maxGridHeight);

    if (tileMatrix.length != crossAxisCount) {
      tileMatrix = createTileMatrix(crossAxisCount);
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Jeu de taquin'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: gridSize,
                        height: gridSize,
                        child: GridView.count(
                          shrinkWrap: true,
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
                                      color: tileMatrix[i][j].isEmpty ? Colors.transparent : Colors.black,
                                      width: tileMatrix[i][j].isEmpty ? 0 : 1
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      var emptyPosition = findEmptyTile();
                                      if (isAdjacentToEmpty(i, j, emptyPosition.$1, emptyPosition.$2)) {
                                        swapTiles(i, j, emptyPosition.$1, emptyPosition.$2);
                                        if(moveCount==0){
                                          chrono.start();
                                        }
                                        setState(() {
                                          moveCount++;
                                        });
                                      }
                                    },
                                    child: tileMatrix[i][j].croppedImageTile(),
                                  )
                                ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "$moveCount coups joués", 
                              style: Theme.of(context).textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
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
    if (isFinished()){
      chrono.stop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
        title: const Text('Félicitations !'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Vous avez résolu le puzzle en $moveCount coups.'),
            (chrono.elapsedMilliseconds/1000 < 60)
              ? Text('Et en ${chrono.elapsedMilliseconds~/1000}s')
              : Text('Et en ${chrono.elapsedMilliseconds~/60000} min et ${(chrono.elapsedMilliseconds%60000)~/1000} s'),
            const SizedBox(height: 16),
            Image.network(
              imageUrl,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Recommencer'),
            onPressed: () {
          setState(() {
            tileMatrix = createTileMatrix(_sliderValue.round());
            moveCount = 0;
            chrono.reset();
          });
          Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Nouvelle image'),
            onPressed: () {
          setState(() {
            final random = Random().nextInt(1000);
            imageUrl = 'https://picsum.photos/512/512?random=$random';
            tileMatrix = createTileMatrix(_sliderValue.round());
            moveCount = 0;
            chrono.reset();
          });
          Navigator.of(context).pop();
            },
          ),
        ],
          );
        },
      );
    }
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

  bool isFinished(){
    for (int i = 0; i < tileMatrix.length; i++) {
      for (int j = 0; j < tileMatrix[i].length; j++) {
        if (tileMatrix[i][j].number != i * tileMatrix.length + j + 1) {
          return false;
        }
      }
    }
    return true;
  }
}