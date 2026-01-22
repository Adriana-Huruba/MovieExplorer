import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/movie.dart';
import '../../data/services/api_service.dart';

//Events from what the user does
abstract class MovieEvent {}
class FetchTrendingMovies extends MovieEvent {}

// States - what the user sees on screen
abstract class MovieState {}
class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<Movie> movies;
  MovieLoaded(this.movies);
}

class MovieError extends MovieState {
  final String message;
  MovieError(this.message);
}

class SearchMovies extends MovieEvent {
  final String query;
  SearchMovies(this.query);
}

// Bloc - business logic component
class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final ApiService apiService;

  MovieBloc(this.apiService) : super(MovieInitial()) {
    on<FetchTrendingMovies>((event, emit) async {
      emit(MovieLoading());
      try {
        final movies = await apiService.searchMovies('Heart'); //as a start
        emit(MovieLoaded(movies));
      } catch (e) {
        emit(MovieError(e.toString()));
      }
    });

    on<SearchMovies>((event, emit) async {
      if (event.query.isEmpty) return;
      
      emit(MovieLoading());
      try {
        final movies = await apiService.searchMovies(event.query);
        emit(MovieLoaded(movies));
      } catch (e) {
        emit(MovieError(e.toString()));
      }
    });
  }
}