import 'package:flutter/material.dart';
import 'package:tp2/menu_page.dart';
import 'package:tp2/high_scores_page.dart';
import 'package:tp2/game_manager.dart';

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
            'Taquin',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.indigo,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () async {
                final action = await showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Paramètres'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.delete_forever),
                            title: const Text('Réinitialiser les scores'),
                            onTap: () async {
                              await GameManager.clearAllGames();
                              if (context.mounted) {
                                Navigator.of(context).pop('reset');
                              }
                            },
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          child: const Text('Annuler'),
                          onPressed: () {
                            Navigator.of(context).pop('cancel');
                          },
                        ),
                      ],
                    );
                  },
                );
                
                if (action == 'reset' && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Les scores ont été réinitialisés'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  
                  if (DefaultTabController.of(context).index == 1) {
                    DefaultTabController.of(context).animateTo(0);
                    Future.delayed(const Duration(milliseconds: 100), () {
                      DefaultTabController.of(context).animateTo(1);
                    });
                  }
                }
              },
            ),
          ],
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