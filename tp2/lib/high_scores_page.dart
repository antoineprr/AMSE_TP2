import 'package:flutter/material.dart';
import 'package:tp2/game_manager.dart';

class HighScoresPage extends StatefulWidget {
  const HighScoresPage({super.key});

  @override
  _HighScoresPageState createState() => _HighScoresPageState();
}

class _HighScoresPageState extends State<HighScoresPage> {
  String _sortOption = 'time';
  String _filterGridSize = 'All';
  String _filterDifficulty = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(8.0),
            color: Colors.indigo[100],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Filtres et tri :', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Trier par :'),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButton<String>(
                          value: _sortOption,
                          onChanged: (String? newValue) {
                            setState(() {
                              _sortOption = newValue!;
                            });
                          },
                          items: <String>['time', 'moves']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value == 'time' ? 'Temps' : 'Coups'),
                            );
                          }).toList(),
                          isExpanded: true,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Grille :'),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButton<String>(
                          value: _filterGridSize,
                          onChanged: (String? newValue) {
                            setState(() {
                              _filterGridSize = newValue!;
                            });
                          },
                          items: <String>['All', '2x2', '3x3', '4x4', '5x5', '6x6']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value == 'All' ? 'Toutes' : value),
                            );
                          }).toList(),
                          isExpanded: true,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Difficulté :'),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButton<String>(
                          value: _filterDifficulty,
                          onChanged: (String? newValue) {
                            setState(() {
                              _filterDifficulty = newValue!;
                            });
                          },
                          items: <String>['All', 'Facile', 'Moyen', 'Difficile']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value == 'All' ? 'Toutes' : value),
                            );
                          }).toList(),
                          isExpanded: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: GameManager.getBestGames(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var bestGames = snapshot.data!;

                if (_filterGridSize != 'All') {
                  bestGames = bestGames.where((game) => game['gridSize'] == _filterGridSize).toList();
                }
                if (_filterDifficulty != 'All') {
                  bestGames = bestGames.where((game) => game['difficulty'] == _filterDifficulty).toList();
                }

                bestGames.sort((a, b) {
                  switch (_sortOption) {
                    case 'time':
                      return a['time'].compareTo(b['time']);
                    case 'moves':
                      return a['moves'].compareTo(b['moves']);
                    default:
                      return a['time'].compareTo(b['time']);
                  }
                });

                if (bestGames.isEmpty) {
                  return const Center(
                    child: Text('Aucun résultat trouvé pour ces filtres'),
                  );
                }

                return ListView.builder(
                  itemCount: bestGames.length,
                  itemBuilder: (context, index) {
                    final game = bestGames[index];
                    final minutes = game['time'] ~/ 60;
                    final seconds = game['time'] % 60;
                    final formattedTime = '${minutes}m ${seconds}s';

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: ListTile(
                        title: Text('Grille: ${game['gridSize']}, Difficulté: ${game['difficulty']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Temps: $formattedTime, Coups: ${game['moves']}'),
                            Text(game['showNumbers'] ? 'Avec numéros' : 'Sans numéros'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}