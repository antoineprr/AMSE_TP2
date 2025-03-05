import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

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
      imageWidget = FutureBuilder<ui.Image>(
        future: _getOptimizedSquareImage(imageFile!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && 
              snapshot.hasData) {
            return RawImage(
              image: snapshot.data,
              fit: BoxFit.cover,
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    } else {
      imageWidget = Image.network(
        imageURL!,
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
              child: Text('Error loading image'),
            ),
          );
        },
      );
    }

    return Stack(
      children: [
        FittedBox(
          fit: BoxFit.cover,
          child: ClipRect(
            child: Align(
              alignment: alignment,
              widthFactor: 1/gridSize,   
              heightFactor: 1/gridSize, 
              child: imageWidget,
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
                  shadows: const [
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
  
  Future<ui.Image> _getOptimizedSquareImage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: 512,
      targetHeight: 512,
    );
    final frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }
}