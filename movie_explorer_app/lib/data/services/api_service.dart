import 'package:dio/dio.dart';
import '../models/movie.dart';

class ApiService {
  final Dio _dio;
  final String _baseUrl = 'https://www.omdbapi.com/';
  final String _apiKey = '28fd1b94'; 

  ApiService(this._dio);

  Future<List<Movie>> searchMovies(String query) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'apikey': _apiKey,
          's': query,
          'type': 'movie',
        },
      );

      if (response.data['Response'] == 'True') {
        List<dynamic> results = response.data['Search'];
        return results.map((m) => Movie.fromJson(m)).toList();
      } else {
        throw Exception(response.data['Error'] ?? 'Unknown error');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Movie> fetchMovieDetails(String imdbID) async {
    final response = await _dio.get('https://www.omdbapi.com/?apikey=$_apiKey&i=$imdbID');
    return Movie.fromJson(response.data);
  }
}