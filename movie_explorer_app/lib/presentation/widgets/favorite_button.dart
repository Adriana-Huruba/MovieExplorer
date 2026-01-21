import 'package:flutter/material.dart';
import '../../data/models/movie.dart';
import '../../data/services/database_service.dart';
import '../../injection_container.dart';

class FavoriteButton extends StatefulWidget {
  final Movie movie;
  const FavoriteButton({super.key, required this.movie});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final favorites = await sl<DatabaseService>().getFavorites();
    final exists = favorites.any((m) => m.imdbID == widget.movie.imdbID);
    if (mounted) {
      setState(() {
        isFavorite = exists;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final db = sl<DatabaseService>();
    if (isFavorite) {
      await db.removeFavorite(widget.movie.imdbID);
    } else {
      await db.addFavorite(widget.movie);
    }

    setState(() {
      isFavorite = !isFavorite;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isFavorite ? 'Added to Favorites' : 'Removed from Favorites'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          key: ValueKey<bool>(isFavorite),
          color: Colors.red,
          size: 30,
        ),
      ),
      onPressed: _toggleFavorite,
    );
  }
}