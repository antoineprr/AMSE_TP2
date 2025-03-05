import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tp2/game_manager.dart';
import 'package:tp2/tile.dart';

class TaquinBoard extends StatefulWidget {
  final String? imageUrl;
  final File? imageFile;
  final Uint8List? imageBytes;  
  final int gridSize;
  final bool showNumbers;
  final int difficulty;



  const TaquinBoard({
    super.key,
    this.imageUrl,
    this.imageFile,
    this.imageBytes,
    required this.gridSize,
    required this.showNumbers,
    required this.difficulty,
  });

  @override
  State<TaquinBoard> createState() => _TaquinBoardState();
}

class _TaquinBoardState extends State<TaquinBoard> {
  late String imageUrl;
  late double _sliderValue;
  late List<List<Tile>> tileMatrix;
  late bool showNumbers;
  late int difficulty;
  late AudioPlayer _audioPlayer;

  
  int moveCount = 0;
  Stopwatch chrono = Stopwatch();
  late Timer timer;

  @override
  void initState() {
    super.initState();
    imageUrl = widget.imageUrl ?? 'https://picsum.photos/512/512?random=1';
    _sliderValue = widget.gridSize.toDouble();
    showNumbers = widget.showNumbers;
    difficulty = widget.difficulty;
    tileMatrix = createTileMatrix(_sliderValue.round());
    starttimer();
    _initAudio();
  }

  Future<void> _initAudio() async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer.setAsset('assets/audio/move.wav');
    await _audioPlayer.setVolume(1.0);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    timer.cancel();
    chrono.stop();
    super.dispose();
  }

  List<List<Tile>> createTileMatrix(int size) {
    var matrix = List.generate(size, (row) {
      return List.generate(size, (col) {
        int tileNumber = row * size + col + 1; 
        return Tile(
          imageURL: (widget.imageFile == null && widget.imageBytes == null) ? imageUrl : null,
          imageFile: widget.imageFile,
          imageBytes: widget.imageBytes,
          alignment: Alignment((col * 2 / (size - 1))-1, (row * 2 / (size - 1))-1),
          gridSize: size,
          isEmpty: false,
          number: tileNumber,
          showNumber: showNumbers,
        );
      });
    });

    var rng = Random();
    var emptyPos = (rng.nextInt(size), rng.nextInt(size));
    matrix[emptyPos.$1][emptyPos.$2].isEmpty = true;

    int shuffleMoves;
    switch (difficulty) {
      case 1: 
        shuffleMoves = 10 * size;
        break;
      case 2: 
        shuffleMoves = 30 * size;
        break;
      case 3: 
        shuffleMoves = 60 * size;
        break;
      default:
        shuffleMoves = 30 * size; 
    }

    for (int i = 0; i < shuffleMoves; i++) {
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
            timer.cancel();
            chrono.stop();
          },
        ),
        automaticallyImplyLeading: false,
        title: const Text('Jeu de taquin'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showFullImage(context);
            },
          ),
        ],
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
                  children: [(chrono.elapsedMilliseconds/1000 < 60 && timer.isActive)
                    ? Text('Temps : ${chrono.elapsedMilliseconds~/1000}s')
                    : Text('Temps : ${chrono.elapsedMilliseconds~/60000} min et ${(chrono.elapsedMilliseconds%60000)~/1000} s'),
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

    _initAudio();
    _audioPlayer.seek(Duration.zero);
    _audioPlayer.play();

    if (isFinished()){
      timer.cancel();
      chrono.stop();
      
    _audioPlayer.seek(Duration.zero);
    _audioPlayer.play();
      
      final int timeInSeconds = chrono.elapsedMilliseconds ~/ 1000;
      String gridSizeStr = "${_sliderValue.round()}x${_sliderValue.round()}";
      String difficultyStr;
      switch (difficulty) {
        case 1: 
          difficultyStr = "Facile";
          break;
        case 2: 
          difficultyStr = "Moyen";
          break;
        case 3: 
          difficultyStr = "Difficile";
          break;
        default:
          difficultyStr = "Moyen";
      }
      
      GameManager.addGame(gridSizeStr, difficultyStr, timeInSeconds, moveCount, showNumbers)
          .then((_) {
        print('Score enregistré avec succès');
      }).catchError((error) {
        print('Erreur lors de l\'enregistrement du score: $error');
      });

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
              ? Text('Temps : ${chrono.elapsedMilliseconds~/1000}s')
              : Text('Temps : ${chrono.elapsedMilliseconds~/60000} min et ${(chrono.elapsedMilliseconds%60000)~/1000} s'),
            const SizedBox(height: 8),
            const Text('Votre score a été enregistré !',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 200,
                height: 200,
                child: _buildImage(),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          Center(
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 40),
                  ),
                  child: const Text('Accueil'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();  
                  },
                ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 40),
                ),
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
              const SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 40),
                ),
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
            ),
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

  void starttimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }
  
 Widget _buildImage() {
  if (widget.imageBytes != null) {
    return Image.memory(
      widget.imageBytes!,
      fit: BoxFit.cover,
    );
  } else if (widget.imageFile != null) {
    return Image.file(
      widget.imageFile!,
      fit: BoxFit.cover,
    );
  } else {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey.shade300,
          child: const Center(
            child: Text('Erreur de chargement de l\'image'),
          ),
        );
      },
    );
  }
}

  void _showFullImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Image complète',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Flexible(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildImage(),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Fermer'),
              ),
            ],
          ),
        );
      },
    );
  }
}