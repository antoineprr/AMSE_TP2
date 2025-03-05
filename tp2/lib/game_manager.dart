import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GameManager {
  static const String _keyBestGames = 'best_games';

  static Future<void> addGame(String gridSize, String difficulty, int time, int moves, bool showNumbers) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> bestGames = prefs.getStringList(_keyBestGames) ?? [];

      final game = {
        'gridSize': gridSize,
        'difficulty': difficulty,
        'time': time,
        'moves': moves,
        'showNumbers': showNumbers,  
        'date': DateTime.now().toIso8601String(),
      };

      final gameJson = jsonEncode(game);
      bestGames.add(gameJson);

      await prefs.setStringList(_keyBestGames, bestGames);
      print('Score enregistré avec succès');
    } catch (e) {
      print('Erreur lors de l\'enregistrement du score: $e');
      throw e;
    }
  }

  static Future<List<Map<String, dynamic>>> getBestGames() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> bestGames = prefs.getStringList(_keyBestGames) ?? [];
      
      List<Map<String, dynamic>> result = [];

      for (String gameStr in bestGames) {
        try {
          if (gameStr.startsWith('{')) {
            result.add(Map<String, dynamic>.from(jsonDecode(gameStr)));
          }
        } catch (e) {
          print('Erreur de décodage pour la chaîne: $gameStr - $e');
        }
      }

      return result;
    } catch (e) {
      print('Erreur lors du chargement des scores: $e');
      return [];
    }
  }

  static Future<void> clearAllGames() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyBestGames);
    print('Tous les scores ont été effacés');
  }

}