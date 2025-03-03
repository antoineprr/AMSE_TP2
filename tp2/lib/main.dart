import 'package:flutter/material.dart';
import 'package:tp2/menu_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exercices TP2',
      home: MenuPage(),
    );
  }
}