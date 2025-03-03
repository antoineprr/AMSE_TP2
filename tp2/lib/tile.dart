import 'dart:io';
import 'package:flutter/material.dart';

class Tile {
  final String? imageURL;
  final File? imageFile;
  final Alignment alignment;
  final int gridSize;
  bool isEmpty;
  final int number;
  final bool showNumber;

  Tile({
    this.imageURL,
    this.imageFile,
    required this.alignment,
    required this.gridSize,
    required this.isEmpty,
    required this.number,
    required this.showNumber,
  });

  Widget croppedImageTile() {
    if (isEmpty) {
      return Container(
        color: Colors.white,
      );
    }

    Widget imageWidget;
    if (imageFile != null) {
      imageWidget = Image.file(
        imageFile!,
        fit: BoxFit.cover,
        alignment: alignment,
      );
    } else {
      imageWidget = Image.network(
        imageURL!,
        fit: BoxFit.cover,
        alignment: alignment,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        FittedBox(
          fit: BoxFit.fill,
          child: ClipRect(
            child: Container(
              width: 400 / gridSize,
              height: 400 / gridSize,
              child: FittedBox(
                fit: BoxFit.none,
                alignment: alignment,
                child: SizedBox(
                  width: 400,
                  height: 400,
                  child: imageWidget,
                ),
              ),
            ),
          ),
        ),
        if (showNumber)
          Center(
            child: Text(
              number.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
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
      ],
    );
  }
}