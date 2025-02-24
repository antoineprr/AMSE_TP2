import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Demo',
      home: const ImagePage(),
    );
  }
}

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  double _rotation = 0;
  double _scale = 1.0;
  bool _mirror = false;
  bool _animation = false;

  @override
  void initState() {
    super.initState();
    const d = Duration(milliseconds: 50);
    Timer.periodic(d, animate);
  }

  void animate(Timer t) {
    setState(() {
      if (_animation) {
        _rotation += 0.1;
        _scale += 0.01;
        if (_scale > 2) {
          _scale = 0.1;
        }
        if (_rotation > 2 * 3.14) {
          _rotation = 0;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(color: Colors.white),
                  padding: const EdgeInsets.all(20),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..rotateZ(_rotation)
                      ..scale(_mirror ? -_scale : _scale, _scale),
                    child: Image.network("https://picsum.photos/1024/512"),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Slider(
                value: _rotation,
                min: 0,
                max: 2 * 3.14,
                onChanged: (value) {
                  setState(() {
                    _rotation = value;
                  });
                },
              ),
              Slider(
                value: _scale,
                min: 0.1,
                max: 2,
                onChanged: (value) {
                  setState(() {
                    _scale = value;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Mirror'),
                  Switch(
                    value: _mirror,
                    onChanged: (value) {
                      setState(() {
                        _mirror = value;
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Start/Stop'),
                  OverflowBar(
                    children: [
                      IconButton(
                        icon: Icon(_animation ? Icons.pause : Icons.play_arrow),
                        onPressed: () {
                          _animation = !_animation;
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}