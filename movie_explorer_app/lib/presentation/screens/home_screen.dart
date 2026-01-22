import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_explorer_app/presentation/screens/favorites_screen.dart';
import 'package:movie_explorer_app/presentation/screens/search_screen.dart';
import '../../logic/bloc/movie_bloc.dart';
import '../../injection_container.dart';
import 'movie_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MovieBloc>()..add(FetchTrendingMovies()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Movie Explorer'),
          centerTitle: true,
          actions: [
            IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        );
      },
    ),
    IconButton(
      icon: const Icon(Icons.favorite),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FavoritesScreen()),
        );
      },
    ),
  ],
        ),
        body: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieLoading) {
              return const Center(child: CircularProgressIndicator()); 
            } 
            else if (state is MovieLoaded) {
              return GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: state.movies.length,
                itemBuilder: (context, index) {
                  final movie = state.movies[index];
                  
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailScreen(movie: movie),
                        ),
                      );
                    },
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 4,
                      child: Column(
                        children: [
                          Expanded(
                            child: Hero(
                              tag: movie.imdbID, 
                              child: Image.network(
                                movie.poster, 
                                fit: BoxFit.cover,
                                width: double.infinity,
                          
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  movie.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(movie.year),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } 
            else if (state is MovieError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(state.message, textAlign: TextAlign.center),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}