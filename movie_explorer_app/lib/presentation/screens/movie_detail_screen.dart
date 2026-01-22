import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; 
import '../../data/models/movie.dart';
import '../../data/services/api_service.dart';
import '../widgets/favorite_button.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Future<Movie> _movieDetailsFuture;
  late ApiService _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(Dio()); 
    _movieDetailsFuture = _apiService.fetchMovieDetails(widget.movie.imdbID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Movie>(
        future: _movieDetailsFuture,
        builder: (context, snapshot) {
          final bool isLoading = snapshot.connectionState == ConnectionState.waiting;
          final Movie movieData = snapshot.data ?? widget.movie;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 500,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    movieData.title,
                    style: const TextStyle(
                      shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                    ),
                  ),
                  background: Hero(
                    tag: movieData.imdbID,
                    child: Image.network(
                      movieData.poster,
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
                            Wrap(
                              spacing: 8,
                              children: [
                                Chip(label: Text(movieData.year)),
                                Chip(
                                  label: Text(isLoading ? '⭐ ...' : '⭐ ${movieData.imdbRating}'),
                                  backgroundColor: Colors.amber.withOpacity(0.2),
                                ),
                              ],
                            ),
                            FavoriteButton(movie: movieData),
                          ],
                        ),
                        if (isLoading) 
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: LinearProgressIndicator(),
                          ),
                        const SizedBox(height: 20),
                        Text(
                          movieData.title,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 204, 109, 109),
                              ),
                        ),
                        const SizedBox(height: 20),
                        _buildInfoSection(context, 'Genre', movieData.genre),
                        _buildInfoSection(context, 'Director', movieData.director),
                        _buildInfoSection(context, 'Main actors', movieData.actors),
                        _buildInfoSection(context, 'Runtime', movieData.runtime),
                        const SizedBox(height: 20),
                        Text(
                          'Plot Summary',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 204, 109, 109),
                              ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          movieData.plot,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 16, color: Colors.white), // TEXT ALB
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          TextSpan(text: value, style: const TextStyle(color: Colors.white70)),
        ],
        ),
      )
    );
  }
}