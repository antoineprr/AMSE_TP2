import 'package:flutter/material.dart';
import 'package:flutter_application_test_exos/exo6b.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exercices TP2',
      home: PlateauPage(),
    );
  }
}