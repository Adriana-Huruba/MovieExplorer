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
      backgroundColor: Colors.black, // Fundal negru pentru toată pagina
      appBar: AppBar(
        title: const Text('Favorites', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Movie>>(
        future: sl<DatabaseService>().getFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'You haven\'t added any movies to favorites.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }

          final favorites = snapshot.data!;

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final movie = favorites[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    movie.poster,
                    width: 50,
                    height: 70,
                    fit: BoxFit.cover,
                    // Protecție pentru eroarea SocketException pe care o ai
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 50,
                      color: Colors.grey[800],
                      child: const Icon(Icons.broken_image, color: Colors.white54),
                    ),
                  ),
                ),
                title: Text(
                  movie.title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  movie.year,
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () async {
                    await sl<DatabaseService>().removeFavorite(movie.imdbID);
                    setState(() {}); // Reîmprospătează lista
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