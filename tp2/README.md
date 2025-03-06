# tp2

Réalisation d'un jeu de taquin dans le cadre de l'UV AMSE à IMT Nord Europe.

Ce projet est une application Flutter qui implémente le fameux jeu du taquin. L'utilisateur peut choisir une image (depuis le web ou la galerie) et adapter la difficulté du puzzle en modifiant la taille de la grille ou le nombre de mouvements aléatoires.

## Fonctionnalités

- **Choix de l'image** : 
  - Prise d'image via la caméra ou sélection dans la galerie.
  - Chargement d'image depuis une URL.
- **Configuration du jeu** :
  - Réglage de la taille de la grille (_gridSize_) permettant d'augmenter ou diminuer la complexité.
  - Sélection du niveau de difficulté (Facile, Moyen, Difficile) influant sur le nombre de mouvements aléatoires pour mélanger le puzzle.
  - Option d'afficher ou non les numéros sur les pièces du puzzle.
- **Multi-plateformes** :
- Support pour Android, iOS, Windows, macOS et Linux.
- **Visualisation des meilleurs scores** :
    - Tri et filtrage des meilleurs scores pour chaque paramètre possible.

## Prérequis

- [Flutter](https://flutter.dev/docs/get-started/install)
- [Dart](https://dart.dev/get-dart)

## Installation

1. **Clonez le dépôt** :
    ```sh
    git clone https://github.com/antoineprr/AMSE_TP2/tp2.git
    ```
2. **Accédez au répertoire du projet** :
    ```sh
    cd AMSE_TP2/tp2
    ```
3. **Installez les dépendances** :
    ```sh
    flutter pub get
    ```

## Exécution

Pour lancer l'application sur un émulateur ou un appareil connecté, utilisez la commande suivante :

```sh
flutter run