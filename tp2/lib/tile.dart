import 'package:flutter/material.dart';

class Tile {
final String imageURL;
final Alignment alignment;
final int gridSize;
bool isEmpty;
final int number; 
bool showNumber;

  Tile({
    required this.imageURL, 
    required this.alignment,
    required this.gridSize,
    required this.isEmpty,
    required this.number, 
    this.showNumber = true,
  });

  Widget croppedImageTile() {
    if (isEmpty) {
      return Container(color: Colors.white);
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
        if (showNumber)
          Center(
              child: Container(
                child: Text(
                  '$number',
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