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

// Bloc - business logic component
class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final ApiService apiService;

  MovieBloc(this.apiService) : super(MovieInitial()) {
    on<FetchTrendingMovies>((event, emit) async {
      emit(MovieLoading());
      try {
        final movies = await apiService.searchMovies('Batman'); //as a start
        emit(MovieLoaded(movies));
      } catch (e) {
        emit(MovieError(e.toString()));
      }
    });
  }
}