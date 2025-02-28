import 'package:flutter/material.dart';

class Tile {
  String imageURL;
  Alignment alignment;
  int gridSize;
  bool isEmpty;
  int number; 

  Tile({
    required this.imageURL, 
    required this.alignment,
    required this.gridSize,
    this.isEmpty = false,
    required this.number, 
  });

  Widget croppedImageTile() {
    if (isEmpty) {
      return Container(
        color: Colors.white,
      );
    }
    return Stack(
      children: [
        FittedBox(
          fit: BoxFit.fill,
          child: ClipRect(
            child: Align(
              alignment: alignment,
              widthFactor: 1/gridSize,   
              heightFactor: 1/gridSize, 
              child: Image.network(
                imageURL,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Center(
            child: Container(
            child: Text(
              '${number}',
              style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              shadows: [
                Shadow(
                blurRadius: 3.0,
                color: Colors.black,
                offset: Offset(1.0, 1.0),
                ),
              ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Tile tile = new Tile(
    imageURL: 'https://picsum.photos/512', alignment: Alignment(0, 0), gridSize: 3, number: 1);

class DisplayTileWidget extends StatelessWidget {
  const DisplayTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Display a Tile as a Cropped Image'),
        centerTitle: true,
      ),
      body: Center(
          child: Column(children: [
        SizedBox(
            width: 150.0,
            height: 150.0,
            child: Container(
                margin: EdgeInsets.all(20.0),
                child: this.createTileWidgetFrom(tile))),
        Container(
            height: 200,
            child: Image.network('https://picsum.photos/512',
                fit: BoxFit.cover))
      ])),
    );
  }

  Widget createTileWidgetFrom(Tile tile) {
    return InkWell(
      child: tile.croppedImageTile(),
      onTap: () {
        print("tapped on tile");
      },
    );
  }
}