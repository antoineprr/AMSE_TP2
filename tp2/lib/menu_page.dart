import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tp2/taquin_page.dart';
import 'package:image_picker/image_picker.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final TextEditingController _imageUrlController = TextEditingController(text: 'https://picsum.photos/512/512');
  int _gridSize = 3;
  bool _showNumbers = true;
  int _difficulty = 2;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  void _changeImage() {
    final random = Random().nextInt(1000);
    _imageUrlController.text = 'https://picsum.photos/512/512?random=$random';
    setState(() {
      _selectedImage = null;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedImage = await _picker.pickImage(source: source);
      if (pickedImage != null) {
        setState(() {
          _selectedImage = File(pickedImage.path);
          _imageUrlController.text = '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sélection de l\'image: ${e.toString()}')),
      );
    }
  }

  void _increaseGridSize() {
    if (_gridSize < 6) {
      setState(() {
        _gridSize++;
      });
    }
  }

  void _decreaseGridSize() {
    if (_gridSize > 2) {
      setState(() {
        _gridSize--;
      });
    }
  }

  void _toggleShowNumbers() {
    setState(() {
      _showNumbers = !_showNumbers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jeu du Taquin'),
        backgroundColor: Colors.indigo,
        centerTitle: true,
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo.shade50, Colors.white],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            const Center(
              child: Text(
                'Bienvenue dans le jeu du Taquin',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Configurez votre partie et commencez à jouer !',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Choisir une image',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: _selectedImage != null
                            ? Image.file(
                                _selectedImage!,
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                _imageUrlController.text,
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 200,
                                    width: 200,
                                    color: Colors.grey.shade300,
                                    child: const Center(
                                      child: Text('Impossible de charger l\'image'),
                                    ),
                                  );
                                },
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    height: 200,
                                    width: 200,
                                    color: Colors.grey.shade200,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded / 
                                                loadingProgress.expectedTotalBytes!
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _changeImage,
                          icon: const Icon(Icons.refresh, color: Colors.white,),
                          label: const Text('Image aléatoire'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt, color: Colors.white,),
                          label: const Text('Photo'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library, color: Colors.white,),
                          label: const Text('Galerie'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Paramètres du jeu',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    ListTile(
                      leading: const Icon(Icons.grid_4x4, color: Colors.indigo),
                      title: const Text('Taille de la grille'),
                      subtitle: Text('$_gridSize x $_gridSize'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle),
                            onPressed: _decreaseGridSize,
                            color: Colors.red,
                          ),
                          Text(
                            '$_gridSize',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle),
                            onPressed: _increaseGridSize,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.speed, color: Colors.indigo),
                      title: const Text('Difficulté'),
                      subtitle: const Text('Nombre de mouvements aléatoires'),
                      trailing: DropdownButton<int>(
                        value: _difficulty,
                        onChanged: (int? newValue) {
                          setState(() {
                            _difficulty = newValue!;
                          });
                        },
                        items: [
                          DropdownMenuItem(value: 1, child: Text('Facile')),
                          DropdownMenuItem(value: 2, child: Text('Moyen')),
                          DropdownMenuItem(value: 3, child: Text('Difficile')),
                        ],
                      ),
                    ),
                    
                    const Divider(),
                    
                    SwitchListTile(
                      secondary: const Icon(Icons.numbers, color: Colors.indigo),
                      title: const Text('Afficher les numéros'),
                      subtitle: const Text('Superposer les numéros sur l\'image'),
                      value: _showNumbers,
                      activeColor: Colors.indigo,
                      onChanged: (bool value) {
                        _toggleShowNumbers();
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<Widget>(
                    builder: (BuildContext context) {
                      return Scaffold(
                        appBar: AppBar(
                          automaticallyImplyLeading: false,
                          title: const Text('Taquin'),
                          backgroundColor: Colors.indigo,
                        ),
                        body: TaquinBoard(
                          imageUrl: _selectedImage != null ? null : _imageUrlController.text,
                          imageFile: _selectedImage,
                          gridSize: _gridSize,
                          showNumbers: _showNumbers,
                          difficulty: _difficulty,
                        ),
                      );
                    },
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_arrow, size: 30),
                  SizedBox(width: 10),
                  Text(
                    'COMMENCER À JOUER',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            ExpansionTile(
              title: const Text(
                'Règles du jeu',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: const Icon(Icons.help_outline, color: Colors.indigo),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('• Le jeu du Taquin consiste à remettre en ordre les pièces d\'une image.'),
                      SizedBox(height: 8),
                      Text('• Vous pouvez déplacer une pièce en la faisant glisser vers la case vide.'),
                      SizedBox(height: 8),
                      Text('• Le but est de reconstituer l\'image complète le plus rapidement possible.'),
                      SizedBox(height: 8),
                      Text('• Plus la grille est grande, plus le défi est important !'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}