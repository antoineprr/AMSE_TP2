import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class Tile {
  final String? imageURL;
  final File? imageFile;
  final Uint8List? imageBytes;
  final Alignment alignment;
  final int gridSize;
  bool isEmpty;
  final int number;
  final bool showNumber;
  
  static final Map<String, ui.Image> _imageCache = {};
  static final Map<String, Widget> _widgetCache = {};

  Tile({
    this.imageURL,
    this.imageFile,
    this.imageBytes,
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

    final String widgetKey = _generateWidgetKey();
    
    if (_widgetCache.containsKey(widgetKey)) {
      return _widgetCache[widgetKey]!;
    }
    
    Widget imageWidget;
    if (imageBytes != null) {
      imageWidget = Image.memory(
        imageBytes!,
        fit: BoxFit.cover,
      );
    } else if (imageFile != null) {
      return _buildFileImageTile(widgetKey);
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

    Widget finalWidget = Stack(
      children: [
        FittedBox(
          fit: BoxFit.cover,
          child: ClipRect(
            child: Align(
              alignment: alignment,
              widthFactor: 1/gridSize,   
              heightFactor: 1/gridSize, 
              child: SizedBox(
                width: gridSize * 400.0,  
                height: gridSize * 400.0, 
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: imageWidget,
                ),
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
    
    if (imageFile == null) {
      _widgetCache[widgetKey] = finalWidget;
    }
    
    return finalWidget;
  }
  
  Widget _buildFileImageTile(String widgetKey) {
    final String cacheKey = imageFile!.path;
    
    if (_widgetCache.containsKey(widgetKey)) {
      return _widgetCache[widgetKey]!;
    }
    
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        if (_imageCache.containsKey(cacheKey)) {
          final Widget cachedWidget = _buildCompleteWidget(_imageCache[cacheKey]!);
          _widgetCache[widgetKey] = cachedWidget;
          return cachedWidget;
        } else {
          _loadAndCacheImage(cacheKey, setState);
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }
  
  void _loadAndCacheImage(String cacheKey, StateSetter setState) async {
    if (!_imageCache.containsKey(cacheKey)) {
      final optimizedImage = await _getOptimizedSquareImage(imageFile!);
      _imageCache[cacheKey] = optimizedImage;
      setState(() {});
    }
  }
  
  Widget _buildCompleteWidget(ui.Image image) {
    return Stack(
      children: [
        FittedBox(
          fit: BoxFit.cover,
          child: ClipRect(
            child: Align(
              alignment: alignment,
              widthFactor: 1/gridSize,   
              heightFactor: 1/gridSize, 
              child: SizedBox(
                width: gridSize * 400.0,  
                height: gridSize * 400.0, 
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: RawImage(
                    image: image,
                    fit: BoxFit.cover,
                  ),
                ),
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
  
  String _generateWidgetKey() {
    String baseKey = '';
    if (imageFile != null) {
      baseKey = 'file_${imageFile!.path}';
    } else if (imageBytes != null) {
      baseKey = 'bytes_${imageBytes.hashCode}';
    } else if (imageURL != null) {
      baseKey = 'url_$imageURL';
    }
    return '${baseKey}_${alignment.x}_${alignment.y}_${gridSize}_${number}_${showNumber}';
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