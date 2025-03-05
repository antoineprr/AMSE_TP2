import 'package:flutter/material.dart';
import 'package:tp2/game_manager.dart';

class HighScoresPage extends StatefulWidget {
  const HighScoresPage({super.key});

  @override
  _HighScoresPageState createState() => _HighScoresPageState();
}

class _HighScoresPageState extends State<HighScoresPage> {
  String _sortOption = 'time';
  String _filterGridSize = '3x3'; 
  String _filterDifficulty = 'All';
  String _filterShowNumbers = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meilleurs scores', 
          style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
        centerTitle: true,
        elevation: 2,
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12.0),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Colors.indigo[50],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Filtres et tri :', 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 18,
                      color: Colors.indigo,
                    )
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterLayout('Trier par :', _sortOption, 
                          <String>['time', 'moves'],
                          (String? newValue) {
                            setState(() {
                              _sortOption = newValue!;
                            });
                          },
                          valueToText: (value) => value == 'time' ? 'Temps' : 'Coups'
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterLayout('Grille :', _filterGridSize, 
                          <String>['All', '2x2', '3x3', '4x4', '5x5', '6x6'],
                          (String? newValue) {
                            setState(() {
                              _filterGridSize = newValue!;
                            });
                          },
                          valueToText: (value) => value == 'All' ? 'Toutes' : value
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterLayout('Difficulté :', _filterDifficulty, 
                          <String>['All', 'Facile', 'Moyen', 'Difficile'],
                          (String? newValue) {
                            setState(() {
                              _filterDifficulty = newValue!;
                            });
                          },
                          valueToText: (value) => value == 'All' ? 'Toutes' : value
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterLayout('Affichage :', _filterShowNumbers, 
                          <String>['All', 'Avec numéros', 'Sans numéros'],
                          (String? newValue) {
                            setState(() {
                              _filterShowNumbers = newValue!;
                            });
                          },
                          valueToText: (value) => value == 'All' ? 'Tous' : value
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
                  return const Center(child: CircularProgressIndicator(
                    color: Colors.indigo,
                  ));
                }

                var bestGames = snapshot.data!;

                if (_filterGridSize != 'All') {
                  bestGames = bestGames.where((game) => game['gridSize'] == _filterGridSize).toList();
                }
                if (_filterDifficulty != 'All') {
                  bestGames = bestGames.where((game) => game['difficulty'] == _filterDifficulty).toList();
                }
                if (_filterShowNumbers != 'All') {
                  bestGames = bestGames.where((game) => 
                    (_filterShowNumbers == 'Avec numéros' && game['showNumbers']) ||
                    (_filterShowNumbers == 'Sans numéros' && !game['showNumbers'])
                  ).toList();
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
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        const Text('Aucun résultat trouvé pour ces filtres',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: bestGames.length,
                  itemBuilder: (context, index) {
                    final game = bestGames[index];
                    final minutes = game['time'] ~/ 60;
                    final seconds = game['time'] % 60;
                    final formattedTime = '${minutes}m ${seconds}s';
                    
                    Color cardColor = Colors.white;
                    if (index == 0) cardColor = Colors.amber[50]!; 
                    else if (index == 1) cardColor = Colors.grey[100]!; 
                    else if (index == 2) cardColor = Colors.brown[50]!; 

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      elevation: index < 3 ? 3 : 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      color: cardColor,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor: Colors.indigo,
                          child: Text('${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        title: Text(
                          'Grille : ${game['gridSize']}, Difficulté : ${game['difficulty']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.timer, size: 16, color: Colors.indigo),
                                const SizedBox(width: 4),
                                Text('Temps : $formattedTime', style: TextStyle(color: Colors.indigo[700])),
                                const SizedBox(width: 16),
                                const Icon(Icons.swap_vert, size: 16, color: Colors.indigo),
                                const SizedBox(width: 4),
                                Text('Coups : ${game['moves']}', style: TextStyle(color: Colors.indigo[700])),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              game['showNumbers'] ? 'Avec numéros' : 'Sans numéros',
                              style: TextStyle(
                                color: Colors.grey[700], 
                                fontStyle: FontStyle.italic
                              ),
                            ),
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

  Widget _buildFilterLayout(String label, String currentValue, List<String> options, 
      Function(String?) onChanged, {String Function(String)? valueToText}) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label, 
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: _buildDropdown(currentValue, options, onChanged, valueToText: valueToText),
        ),
      ],
    );
  }

  Widget _buildDropdown(String currentValue, List<String> options, 
      Function(String?) onChanged, {String Function(String)? valueToText}) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.indigo.withOpacity(0.3)),
      ),
      child: DropdownButton<String>(
        value: currentValue,
        onChanged: onChanged,
        items: options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(valueToText != null ? valueToText(value) : value),
          );
        }).toList(),
        isExpanded: true,
        underline: Container(), 
        icon: const Icon(Icons.arrow_drop_down, color: Colors.indigo),
      ),
    );
  }
}