import 'package:flutter/material.dart';
import 'package:tp2/menu_page.dart';
import 'package:tp2/high_scores_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taquin',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Tac'1",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.indigo,
        ),
        body: const TabBarView(
          children: [
            MenuPage(),
            HighScoresPage(),
          ],
        ),
        bottomNavigationBar: Material(
          color: Colors.indigo,
          child: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Menu', icon: Icon(Icons.home)),
              Tab(text: 'Scores', icon: Icon(Icons.leaderboard)),
            ],
          ),
        ),
      ),
    );
  }
}