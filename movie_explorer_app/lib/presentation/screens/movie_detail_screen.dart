import 'package:flutter/material.dart';
import '../../data/models/movie.dart';
import '../widgets/favorite_button.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 500,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                movie.title,
                style: const TextStyle(
                  shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                ),
              ),
              background: Hero( //animation 
                tag: movie.imdbID,
                child: Image.network(
                  movie.poster,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 100),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          label: Text(movie.year),
                          backgroundColor: Colors.deepPurple.withValues(alpha: 0.2),
                        ),
                        FavoriteButton(movie: movie),
                        IconButton(
                          icon: const Icon(Icons.favorite_border, color: Colors.red),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Added to Favorites')),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Sinopsis',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurpleAccent,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      movie.plot,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 17,
                            height: 1.5,
                          ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}