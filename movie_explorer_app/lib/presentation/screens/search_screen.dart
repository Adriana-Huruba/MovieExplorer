import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/bloc/movie_bloc.dart';
import 'movie_detail_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search a movie...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (query) {
            if (query.length > 2) {
              context.read<MovieBloc>().add(SearchMovies(query)); // Trimite evenimentul către BLoC
            }
          },
        ),
      ),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) return const Center(child: CircularProgressIndicator());
          if (state is MovieLoaded) {
            return ListView.builder(
              itemCount: state.movies.length,
              itemBuilder: (context, index) {
                final movie = state.movies[index];
                return ListTile(
                  title: Text(movie.title),
                  leading: Image.network(movie.poster, width: 40),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: movie)),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Enter the name of a movie to search.'));
        },
      ),
    );
  }
}