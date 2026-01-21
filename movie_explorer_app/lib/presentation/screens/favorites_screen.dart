import 'package:flutter/material.dart';
import '../../data/models/movie.dart';
import '../../data/services/database_service.dart';
import '../../injection_container.dart';
import 'movie_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: FutureBuilder<List<Movie>>(
        future: sl<DatabaseService>().getFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('You haven\'t added any movies to favorites.'));
          }

          final favorites = snapshot.data!;

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final movie = favorites[index];
              return ListTile(
                leading: Image.network(movie.poster, width: 50, fit: BoxFit.cover),
                title: Text(movie.title),
                subtitle: Text(movie.year),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await sl<DatabaseService>().removeFavorite(movie.imdbID);
                    setState(() {});
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailScreen(movie: movie),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}